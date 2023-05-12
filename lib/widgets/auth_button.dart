import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/screens/auth_screen.dart';

class AuthButton extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function()? onTap;
  const AuthButton({Key? key, required this.iconData, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
