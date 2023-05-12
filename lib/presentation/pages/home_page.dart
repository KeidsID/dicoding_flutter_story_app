import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final unListenAuthProv = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      drawer: Drawer(
        child: ListView(
          children: [
            // Drawer header
            const SizedBox(height: 16.0),
            CircleAvatar(child: Text(unListenAuthProv.username[0])),
            const SizedBox(height: 8.0),
            Text('Welcome back ${unListenAuthProv.username}'),
            const SizedBox(height: 16.0),
            const Divider(),

            // Actions
            ListTile(
              onTap: () async {
                final showSnackBar = context.scaffoldMessenger.showSnackBar;

                try {
                  await unListenAuthProv.logout();
                } on HttpResponseException catch (e) {
                  showSnackBar(SnackBar(
                    content: Text('${e.statusCode}: ${e.message}'),
                  ));
                }
              },
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
            ),
          ],
        ),
      ),
      body: const Placeholder(),
    );
  }
}
