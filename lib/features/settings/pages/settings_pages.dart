/*

SETTINGS page

-DarkMode
-Blocked Users
-Account Settings

*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_jose_gael/responsive/constrained_scaffold.dart';
import 'package:social_app_jose_gael/themes/theme_cubit.dart';

class SettingsPages extends StatelessWidget {
  const SettingsPages({super.key});

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    // is dark mode
    bool isDarkMode = themeCubit.isDarkMode;

    // SCAFFOLD
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          // dark mode tile
          ListTile(
            title: Text("Dark Mode"),
            trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) {
                  themeCubit.toggleTheme();
                }),
          )
        ],
      ),
    );
  }
}
