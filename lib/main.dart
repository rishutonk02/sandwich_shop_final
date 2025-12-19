import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sandwich_shop/models/cart_model.dart';
import 'package:sandwich_shop/models/theme_model.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStyles.loadFontSize();
  try {
    // Prefer generated platform options when available. The FlutterFire
    // CLI will create `lib/firebase_options.dart` with `DefaultFirebaseOptions`.
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {
      // If options are not generated, fall back to native platform config.
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Catch any errors but allow the app to continue so you can finish setup.
    // ignore: avoid_print
    print('Firebase initialization failed: $e');
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => ThemeModel()),
      ],
      child: Consumer<ThemeModel>(
        builder: (context, theme, child) => MaterialApp(
          title: 'Sandwich Shop App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const OrderScreen(maxQuantity: 5),
        ),
      ),
    );
  }
}
