import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payflix/resources/routes/app_routes.dart';

class Playground extends StatefulWidget {
  const Playground({Key? key}) : super(key: key);

  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playground'),
        centerTitle: true,
      ),
      body: Center(
          child: IconButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (route) => false);
        },
        icon: const Icon(Icons.close),
      )),
    );
  }
}
