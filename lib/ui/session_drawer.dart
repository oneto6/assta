import 'package:assta/extension/common.dart';
import 'package:assta/model/session.dart';
import 'package:assta/provider/session.dart';
import 'package:assta/ui/prompt_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionDrawer extends ConsumerStatefulWidget {
  const SessionDrawer({super.key});

  @override
  ConsumerState<SessionDrawer> createState() => _SessionDrawerState();
}

class _SessionDrawerState extends ConsumerState<SessionDrawer> {
  late TextTheme textTheme;
  late ColorScheme colorScheme;
  @override
  void didChangeDependencies() {
    final themeData = Theme.of(context);
    textTheme = themeData.textTheme;
    colorScheme = themeData.colorScheme;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(sessionProvider);
    return Padding(
      padding: EdgeInsets.all(context.md),
      child: switch (data) {
        AsyncLoading<List<Session>>() => Center(
          child: SizedBox.square(dimension: context.md * 4),
        ),
        AsyncError<List<Session>>() => Center(child: Text("Network Error")),

        AsyncData<List<Session>>(value: final data) => ListView(
          children: [
            Text("Actions", style: textTheme.titleSmall),
            SizedBox(height: context.sm),
            ...action,
            SizedBox(height: context.md),
            Text("Chats", style: textTheme.titleSmall),
            SizedBox(height: context.sm),
            ...sessionList(data),
          ],
        ),
      },
    );
  }

  List<Widget> get action => [
    FilledButton.icon(
      onPressed: () {
        context.goNamed("chat", pathParameters: {"id": "session_new"});
        Scaffold.of(context).closeEndDrawer();
      },
      icon: Icon(Icons.note_outlined),
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        alignment: .centerLeft,
        padding: WidgetStatePropertyAll(.only(left: context.sm)),
      ),
      label: Text(
        "New Chat",
        style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
      ),
    ),
  ];

  List<Widget> sessionList(List<Session> list) {
    final res = <Widget>[];

    // res.add(Text(list.length.toString()));
    for (var i in list.reversed) {
      res.add(SessionCard(session: i));
    }
    if (PromptInherited.of(context).sessionID == "session_new") {
      res.insert(
        0,
        SessionCard(
          session: Session(id: "session_new", name: "New Chat"),
        ),
      );
    }

    return res;
  }
}

class SessionCard extends StatelessWidget {
  final Session session;
  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.xs),
      child: FilledButton(
        onPressed: () {
          context.goNamed("chat", pathParameters: {"id": session.id});
          Scaffold.of(context).closeEndDrawer();
        },
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: highlight(context),
          alignment: .centerLeft,
          padding: WidgetStatePropertyAll(.only(left: context.sm)),
        ),
        child: Text(session.name),
      ),
    );
  }

  WidgetStateColor? highlight(BuildContext context) {
    if (PromptInherited.of(context).sessionID != session.id) return null;
    final themeData = Theme.of(context);
    final color = themeData.colorScheme.onPrimary.withAlpha(25);
    return WidgetStateColor.fromMap({WidgetState.any: color});
  }
}
