import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart_model.dart';
import 'package:sandwich_shop/models/theme_model.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/cart_screen_page.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/models/cart.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OrderScreen(maxQuantity: 5),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) =>
          CheckoutScreen(cart: state.extra as Cart? ?? Cart()),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => ThemeModel()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark;
    try {
      isDark = Provider.of<ThemeModel>(context).isDark;
    } catch (_) {
      // Tests may pump `App` without wrapping providers — fall back to light theme.
      isDark = false;
    }
    return MaterialApp.router(
      title: 'Sandwich Shop',
      theme: isDark ? ThemeData.dark() : AppStyles.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
