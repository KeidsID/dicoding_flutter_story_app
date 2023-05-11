import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page'),
            const SizedBox(height: 16.0),
            Consumer<AuthProvider>(
              builder: (context, prov, child) {
                if (prov.state == AuthProviderState.loading) {
                  return const CircularProgressIndicator();
                }

                return FilledButton(
                  onPressed: () async {
                    final showSnackBar = context.scaffoldMessenger.showSnackBar;

                    try {
                      await prov.logout();
                    } on HttpResponseException catch (e) {
                      showSnackBar(SnackBar(
                        content: Text('${e.statusCode}: ${e.message}'),
                      ));
                    } catch (e) {
                      showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                  child: const Text('Log Out'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
