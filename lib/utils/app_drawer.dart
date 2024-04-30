import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:youstoryapp02/provider/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset('assets/logo.png'),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            height: 20,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.settings,
                ),
                SizedBox(width: 12),
                Text('Ganti Bahasa'),
              ],
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.info,
                ),
                SizedBox(width: 12),
                Text('Tentang Aplikasi'),
              ],
            ),
            onTap: () {
              // Handle item tap
            },
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            height: 20,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Row(
              children: [
                _buildLogoutIcon(authWatch.isLoadingLogout),
                const SizedBox(width: 12),
                const Text('Keluar'),
              ],
            ),
            onTap: () async {
              final result = await authWatch.logout();
              if (context.mounted && result) {
                context.goNamed('login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutIcon(bool isLoadingLogout) {
    return isLoadingLogout
        ? const CircularProgressIndicator(color: Colors.blue)
        : const Icon(Icons.exit_to_app);
  }
}
