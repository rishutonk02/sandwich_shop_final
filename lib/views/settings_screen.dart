import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_drawer.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/theme_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeModel? theme;
    try {
      theme = Provider.of<ThemeModel>(context);
    } catch (_) {
      theme = null;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: AppStyles.heading1)),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Enable Dark Mode', style: AppStyles.normalText),
            Switch(
              value: theme?.isDark ?? false,
              onChanged: theme != null
                  ? (value) {
                      theme!.setDark(value);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
