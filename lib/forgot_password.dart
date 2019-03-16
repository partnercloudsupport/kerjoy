import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  final Widget child;

  ForgotPassword({Key key, this.child}) : super(key: key);

  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "you have forgot Password."
      ),
    );
  }
}