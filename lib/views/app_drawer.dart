import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandwich_shop/views/cart_screen_page.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
// Navigation is handled by go_router when available; fall back to Navigator.push.

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 64,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sandwich Shop',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Close the drawer first
              Navigator.pop(context);
              debugPrint('Drawer: navigating to /');
              try {
                // Prefer go_router when available
                context.go('/');
                return;
              } catch (e) {
                // No GoRouter available — fall back to Navigator by popping
                // until the first route (the app's home) so this reliably
                // returns to the OrderScreen when the drawer is used.
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.pop(context);
              debugPrint('Drawer: navigating to /cart');
              try {
                GoRouter.of(context).go('/cart');
              } catch (e) {
                // fall back to pushing the Cart screen directly
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              debugPrint('Drawer: navigating to /profile');
              try {
                GoRouter.of(context).go('/profile');
              } catch (e) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              debugPrint('Drawer: navigating to /settings');
              try {
                GoRouter.of(context).go('/settings');
              } catch (e) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              try {
                context.go('/about');
              } catch (_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
