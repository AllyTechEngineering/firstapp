import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  /// changed to StatefulWidget
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// section 3 step 13 4:10 and 5:37
  @override
  void didChangeDependencies() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.updateEmailVerificationState();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  model.logOut();
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: Center(
          /// section 3 step 13 about 5:15
          child: model.emailVerified ?? false ? const Text('Email verified') : const Text('Email is not verified'),
        ),
      );
    });
  }
} //class HomeScreen
