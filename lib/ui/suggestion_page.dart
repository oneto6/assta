import 'package:assta/extension/common.dart';
import 'package:assta/model/suggestion.dart';
import 'package:assta/provider/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ScrollController scrollController;
  late ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    colorScheme = ColorScheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(suggestionProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: switch (state) {
        AsyncLoading<List<Suggestion>>() => Center(
          child: SizedBox.square(
            dimension: context.md * 4,
            child: CircularProgressIndicator(),
          ),
        ),
        AsyncData<List<Suggestion>>(value: final list) => RefreshIndicator(
          onRefresh: ref.read(suggestionProvider.notifier).refresh,
          child: Padding(
            padding: EdgeInsets.all(context.md),
            child: switch (context.layoutMode) {
              LayoutMode.mobile => ListView(
                controller: scrollController,
                children: [headLine, ...suggestionlistview(list), loadMore],
              ),
              LayoutMode.tablet => Row(
                children: [
                  Expanded(child: Center(child: headLine)),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [...suggestionlistview(list), loadMore],
                    ),
                  ),
                ],
              ),
              LayoutMode.desktop => Row(
                children: [
                  Expanded(child: headLine),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [...suggestionlistview(list), loadMore],
                    ),
                  ),
                ],
              ),
            },
          ),
        ),
        AsyncError<List<Suggestion>>() => Center(child: Text("Network Issue")),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed('chat_create');
        },
        child: Icon(Icons.auto_awesome_outlined),
      ),
    );
  }

  List<Widget> suggestionlistview(List<Suggestion> list) {
    final List<Widget> result = [];
    for (var i in list) {
      result.add(SuggestionCard(suggestion: i));
    }
    return result;
  }

  Widget get loadMore {
    return VisibilityDetector(
      key: Key("VisibilityDetector"),
      onVisibilityChanged: onVisibilityChanged,
      child: AspectRatio(
        aspectRatio: 16 / 4,
        child: Center(
          child: SizedBox.square(
            dimension: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void onVisibilityChanged(VisibilityInfo vi) async {
    if (vi.visibleFraction == 0) return;
    final offsetAim = scrollController.offset - vi.visibleBounds.bottom;

    final res = await ref.read(suggestionProvider.notifier).loadMore();
    if (res == 0 || scrollController.offset <= offsetAim) return;

    await scrollController.animateTo(
      offsetAim,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  Widget get headLine => ConstrainedBox(
    constraints: BoxConstraints(minHeight: context.sm * 40),
    child: HeadLine(),
  );
}

class HeadLine extends StatefulWidget {
  const HeadLine({super.key});

  @override
  State<HeadLine> createState() => _HeadLineState();
}

class _HeadLineState extends State<HeadLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      // duration: Duration(milliseconds: 300),
      duration: Duration(seconds: 3),
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: FadeTransition(
          opacity: animation,
          child: Text(
            "Explore these\nprompts",
            textAlign: .center,
            style: TextTheme.of(context).headlineLarge?.copyWith(height: 1.5),
          ),
        ),
      ),
    );
  }
}

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({super.key, required this.suggestion});
  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100),
      child: AspectRatio(
        aspectRatio: 4,
        child: GestureDetector(
          onTap: () {
            context.goNamed(
              'chat_create',
              queryParameters: {'q': suggestion.title},
            );
          },
          child: Card(
            // color: ColorScheme.of(context).primary,
            // color: ColorScheme.of(context).surface,
            child: Padding(
              padding: EdgeInsets.all(context.md),
              child: Column(
                mainAxisAlignment: .spaceEvenly,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    suggestion.title,
                    style: TextTheme.of(context).titleLarge,
                  ),
                  Text(
                    suggestion.description,
                    style: TextTheme.of(context).titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
