import 'package:assta/ui/prompt_page.dart';
import 'package:assta/ui/suggestion_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

final routerConfigProvider = NotifierProvider(GoRouterNotifier.new);

class GoRouterNotifier extends Notifier<GoRouter> {
  @override
  build() {
    final goRouter = GoRouter(
      routes: routes,
      onEnter: (context, state, state2, router) async {
        print(state.uri.path);
        return Allow();
      },
    );
    return goRouter;
  }

  List<RouteBase> get routes => [
    GoRoute(path: "/", name: 'home', builder: (_, _) => HomePage()),
    GoRoute(
      path: "/chat",
      name: 'chat_create',
      builder: (_, _) => PromptPageAdapter(),
    ),

    GoRoute(
      path: "/chat/:id",
      name: 'chat',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id']!;
        return CustomTransitionPage(
          child: PromptPage(sessionID: id),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              child: child,
            );
          },
        );
      },
    ),
  ];
}
