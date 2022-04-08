import 'package:flutter/material.dart';
import 'package:skoomin/src/base/themes.dart';

class AuthButton extends StatefulWidget {
  final String? text;
  final VoidCallback? onTap;
  final Color? colorTxt;
  final double? width;
  final double? radius;
  final double? height;
  final Color? btnColor;
  final double? elevation;

  const AuthButton({
    Key? key,
    this.elevation,
    this.width,
    this.text,
    this.onTap,
    this.colorTxt,
    this.btnColor,
    this.radius,
    this.height,
  }) : super(key: key);

  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: widget.btnColor ?? const Color(0xFF77A500),
        minimumSize: Size.fromHeight(widget.height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 8),
        ),
        splashFactory: InkSplash.splashFactory,
        shadowColor: Colors.white,
        elevation: widget.elevation ?? 2,
      ),
      onPressed: widget.onTap,
      child: Text(
        widget.text ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontFamily: "GoogleSans",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TextButtonWidget extends StatefulWidget {
  const TextButtonWidget({
    Key? key,
    this.title,
    this.child,
    required this.onPressed,
  }) : super(key: key);
  final String? title;
  final VoidCallback onPressed;
  final Widget? child;

  @override
  State<TextButtonWidget> createState() => _TextButtonWidgetState();
}

class _TextButtonWidgetState extends State<TextButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: widget.title == null
          ? widget.child!
          : Text(
              widget.title ?? '',
              style: const TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
      onPressed: widget.onPressed,
    );
  }
}
