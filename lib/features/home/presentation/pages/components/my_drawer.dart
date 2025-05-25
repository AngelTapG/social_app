import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:social_app_jose_gael/features/home/presentation/pages/components/my_drawer_tile.dart';
import 'package:social_app_jose_gael/features/search/presentation/cubits/pages/search_page.dart';
import 'package:social_app_jose_gael/features/settings/pages/settings_pages.dart';

import '../../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../../profile/domain/data/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              
              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).pop();
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                    ),
                  );
                },
              ),

             
              MyDrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                ),
              ),

              
              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPages()),
                ),
              ),

              const Spacer(),

              // logout tile
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.login,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
