import 'dart:math';
import 'dart:ui';

import 'package:assta/api/network_api.dart';
import 'package:assta/extension/common.dart';
import 'package:assta/model/prompt.dart';
import 'package:assta/provider/prompt.dart';
import 'package:assta/ui/component.dart';
import 'package:assta/ui/session_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PromptPageAdapter extends ConsumerStatefulWidget {
  const PromptPageAdapter({super.key});

  @override
  ConsumerState<PromptPageAdapter> createState() => _PromptPageAdapterState();
}

class _PromptPageAdapterState extends ConsumerState<PromptPageAdapter> {
  ApiState<String>? data; // null means loading

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(callback);
    super.initState();
  }

  void callback(_) async {
    data = await NetworkApi.instance.chatCreate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (data) {
        null => Center(
          child: SizedBox.square(
            dimension: context.md * 4,
            child: CircularProgressIndicator(),
          ),
        ),

        ApiStateData<String>(data: final sessionID) => () {
          final query = GoRouter.of(context).state.uri.queryParameters;
          context.goNamed(
            'chat',
            pathParameters: {'id': sessionID},
            extra: query,
          );
          return SizedBox();
        }(),

        ApiStateError<String>() => Center(child: Text("Unexpected Error")),
      },
    );
  }
}

class PromptPage extends ConsumerStatefulWidget {
  final String sessionID;
  const PromptPage({super.key, required this.sessionID});

  @override
  ConsumerState<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends ConsumerState<PromptPage> {
  final promptFieldKey = GlobalKey();
  late ColorScheme colorScheme;
  late final double promptFieldHeight;

  late final ScrollController scrollController;
  @override
  void didChangeDependencies() {
    colorScheme = ColorScheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prompt = ref.watch(promptProvider(widget.sessionID));
    ref.listen(promptProvider(widget.sessionID), (prev, next) {
      if (!scrollController.hasClients) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        );
      });
    });

    return PromptInherited(
      sessionID: widget.sessionID,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: AppBackButton(
            onPressed: () {
              context.goNamed('home');
            },
          ),
          actions: [AppEndDrawer(), SizedBox(width: 8)],
        ),
        body: PromptField(
          promptFieldKey: promptFieldKey,
          child: Padding(
            padding: EdgeInsets.all(context.sm),
            child: switch (prompt) {
              AsyncLoading<List<Prompt>>() => progressIndicator,
              AsyncError<List<Prompt>>() => Center(
                child: Text("Network Issue"),
              ),
              AsyncData<List<Prompt>>(value: final value) => () {
                if (value.isEmpty) {
                  return Center(
                    child: DefaultTextStyle(
                      style: TextTheme.of(context).headlineLarge!.copyWith(),
                      child: AnimatedText(text: "Ask Me Anything."),
                    ),
                  );
                }
                return Align(
                  alignment: .topCenter,
                  child: ListView(
                    controller: scrollController,
                    reverse: true,
                    shrinkWrap: true,
                    children: listPrompt(value),
                  ),
                );
              }(),
            },
          ),
        ),

        endDrawer: Drawer(child: SessionDrawer()),
      ),
    );
  }

  List<Widget> listPrompt(List<Prompt> list) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    final result = <Widget>[];
    result.add(SizedBox(height: promptFieldHeight));
    for (var p in list.reversed) {
      final widget = Align(
        alignment: (p is Agent) ? .centerLeft : .centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 40),
          child: PromptBubble(prompt: p),
        ),
      );
      result.add(widget);
    }
    if (list.last is Client) {
      result.insert(1, Align(alignment: .centerLeft, child: PromptLoading()));
    }
    return result;
  }

  void callback(Duration _) {
    final RenderBox renderBox;
    try {
      final currentContext = promptFieldKey.currentContext;
      if (currentContext == null) {
        promptFieldHeight = 0;
        return;
      }
      renderBox = currentContext.findRenderObject() as RenderBox;
    } catch (e) {
      promptFieldHeight = 0;
      return;
    }
    promptFieldHeight =
        MediaQuery.of(context).size.height -
        renderBox.localToGlobal(Offset.zero).dy;
  }

  Widget get progressIndicator => ListView.separated(
    itemBuilder: (context, index) {
      final widget = SizedBox(
        height: 36,
        width: 80 + Random().nextDouble() * (200 - 80),
        child: Card(),
      );
      if (index % 2 == 0) {
        return Align(alignment: .centerLeft, child: widget);
      }
      return Align(alignment: .centerRight, child: widget);
    },
    separatorBuilder: (_, _) => SizedBox(height: context.xs),
    itemCount: 16,
  );
}

class PromptLoading extends StatefulWidget {
  const PromptLoading({super.key});

  @override
  State<PromptLoading> createState() => _PromptLoadingState();
}

class _PromptLoadingState extends State<PromptLoading>
    with SingleTickerProviderStateMixin {
  late ColorScheme colorScheme;
  late final AnimationController animationController;
  late final Animation animation;

  @override
  void didChangeDependencies() {
    colorScheme = ColorScheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation = IntTween(begin: 0, end: 2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    animationController.repeat();
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
      child: Padding(
        padding: EdgeInsets.all(context.xs),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Text.rich(TextSpan(children: children));
          },
        ),
      ),
    );
  }

  List<InlineSpan> get children {
    final result = <TextSpan>[];
    for (var i = 0; i <= 2; i++) {
      result.add(
        TextSpan(
          text: " ● ",
          style: (i == animation.value)
              ? TextStyle(color: colorScheme.onPrimary)
              : TextStyle(color: colorScheme.surface),
        ),
      );
    }
    return result;
  }
}

class PromptField extends ConsumerStatefulWidget {
  final GlobalKey promptFieldKey;
  final Widget child;
  const PromptField({
    super.key,
    required this.promptFieldKey,
    required this.child,
  });

  @override
  ConsumerState<PromptField> createState() => _PromptFieldState();
}

class _PromptFieldState extends ConsumerState<PromptField> {
  final textFormFieldBorderRadius = BorderRadius.circular(40);
  late final TextEditingController textEditingController;
  late ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    colorScheme = Theme.of(context).colorScheme;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(callback);
    super.initState();
  }

  void callback(Duration _) async {
    final extra = GoRouter.of(context).state.extra;
    if (extra is! Map) return;
    final query = extra['q'];
    if (query is! String) return;
    textEditingController.text = query;
    await send();
    textEditingController.clear();
  }

  Future<void> send() async {
    focusNode.requestFocus();
    final text = textEditingController.text;
    if (text.isEmpty) return;
    textEditingController.clear();
    await ref
        .read(promptProvider(PromptInherited.of(context).sessionID).notifier)
        .send(text);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final promptFieldHeight = 48.0;

  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final double verticalSpacing = switch (context.layoutMode) {
      LayoutMode.mobile => context.xl,
      LayoutMode.tablet => context.xl * 4,
      LayoutMode.desktop => context.xl * 6,
    };
    return Stack(
      children: [
        widget.child,
        Positioned(
          key: widget.promptFieldKey,
          right: verticalSpacing,
          left: verticalSpacing,
          bottom: context.xl,
          child: Padding(
            padding: EdgeInsets.only(top: context.sm),
            child: SizedBox(
              height: promptFieldHeight,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: TextFormField(
                    focusNode: focusNode,
                    onFieldSubmitted: (_) => send(),
                    controller: textEditingController,
                    decoration: fieldDecoration,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration get fieldDecoration {
    return InputDecoration(
      filled: true,
      fillColor: colorScheme.surface.withAlpha(25),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: colorScheme.onPrimary),

        borderRadius: BorderRadius.circular(promptFieldHeight / 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(promptFieldHeight / 2),
      ),
    );
  }

  Widget get suffixIcon => SizedBox.square(
    dimension: promptFieldHeight,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton.filled(
        color: colorScheme.onPrimary,
        onPressed: send,
        icon: Icon(Icons.send),
      ),
    ),
  );
  Widget get prefixIcon => SizedBox.square(
    dimension: promptFieldHeight,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: PopupMenuButton<String>(
        icon: Icon(Icons.add, color: colorScheme.onPrimary), // ⋮
        onSelected: (value) {},
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'images',
            child: Row(
              children: [
                Icon(Icons.image_sharp),
                SizedBox(width: context.sm),
                Text('Images'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'document',
            child: Row(
              children: [
                Icon(Icons.note),
                SizedBox(width: context.sm),
                Text('Document'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'web',
            child: Row(
              children: [
                Icon(Icons.language),
                SizedBox(width: context.sm),
                Text('Web Search'),
              ],
            ),
          ),
        ],
      ),
      // IconButton(
      //   color: colorScheme.onPrimary,
      //   onPressed: () {},
      //   icon: Icon(Icons.add),
      // ),
    ),
  );
}

class PromptBubble extends StatelessWidget {
  final Prompt prompt;
  const PromptBubble({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.sm),
        child: Text(prompt.message, textAlign: .start),
      ),
    );
  }
}

class PromptInherited extends InheritedWidget {
  final String sessionID;
  const PromptInherited({
    super.key,
    required super.child,
    required this.sessionID,
  });

  static PromptInherited of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PromptInherited>();
    assert(result != null, 'PromptInherited not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant PromptInherited oldWidget) {
    return sessionID == oldWidget.sessionID;
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  const AnimatedText({super.key, required this.text});

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<int> animation;
  String initText = "";
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = IntTween(
      begin: 1,
      end: widget.text.length,
    ).animate(animationController);
    animation.addListener(listener);
    animationController.forward();
    super.initState();
  }

  void listener() {
    animation.value;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.text.substring(0, animation.value)),
            BlinkingCursor(),
          ],
        );
      },
    );
  }
}

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true); // 👈 ON/OFF loop

    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: const Text("▮"));
  }
}
