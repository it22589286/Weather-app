import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String text;
  final void Function()? OnTap;

  final IconData icon;
  const MyListTile(
      {super.key, required this.text, required this.icon, required this.OnTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon),
        title: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: OnTap);
  }
}
