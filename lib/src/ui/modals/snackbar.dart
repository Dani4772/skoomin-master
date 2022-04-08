import 'package:flutter/material.dart';

displaySnackBar(BuildContext context, String title) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );

hideSnackBar(BuildContext context) =>
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
