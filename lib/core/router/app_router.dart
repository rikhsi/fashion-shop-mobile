import 'package:go_router/go_router.dart';

import '../../features/shell/presentation/pages/shell_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'shell',
        builder: (context, state) => const ShellPage(),
      ),
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) => const WishlistPage(),
      ),
    ],
  );
}
