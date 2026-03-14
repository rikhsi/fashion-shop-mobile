import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../features/catalog/presentation/pages/category_detail_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/profile/presentation/pages/profile_menu_destination_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
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
      GoRoute(
        path: '/catalog/:categoryId',
        name: 'category-detail',
        builder: (context, state) => CategoryDetailPage(
          categoryId: state.pathParameters['categoryId']!,
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ProfileCubit>()..loadProfile(),
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profile-edit',
        builder: (context, state) => const ProfileEditPage(),
      ),
      GoRoute(
        path: '/profile/orders',
        name: 'profile-orders',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'My Orders',
          icon: Icons.receipt_long_outlined,
        ),
      ),
      GoRoute(
        path: '/profile/reviews',
        name: 'profile-reviews',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'My Reviews',
          icon: Icons.rate_review_outlined,
        ),
      ),
      GoRoute(
        path: '/profile/seller',
        name: 'profile-seller',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'Become a Seller',
          icon: Icons.storefront_outlined,
        ),
      ),
      GoRoute(
        path: '/profile/chats',
        name: 'profile-chats',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'My Chats',
          icon: Icons.chat_bubble_outline_rounded,
        ),
      ),
      GoRoute(
        path: '/profile/notifications',
        name: 'profile-notifications',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'Notifications',
          icon: Icons.notifications_none_rounded,
        ),
      ),
      GoRoute(
        path: '/profile/promo-codes',
        name: 'profile-promo-codes',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'My Promo Codes',
          icon: Icons.discount_outlined,
        ),
      ),
      GoRoute(
        path: '/profile/settings',
        name: 'profile-settings',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'Settings',
          icon: Icons.settings_outlined,
        ),
      ),
      GoRoute(
        path: '/profile/contact',
        name: 'profile-contact',
        builder: (context, state) => const ProfileMenuDestinationPage(
          title: 'Contact Us',
          icon: Icons.support_agent_outlined,
        ),
      ),
    ],
  );
}
