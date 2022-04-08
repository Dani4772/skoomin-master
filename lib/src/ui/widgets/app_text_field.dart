import 'package:flutter/material.dart';

const _pColor = Color(0xFF77A500);

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.hint,
    this.onTap,
    this.label,
    this.value,
    this.obscure = false,
    this.suffix,
    this.onSaved,
    this.onChanged,
    this.readonly = false,
    this.validator,
    this.keyboardType,
    this.floatLabel = false,
    required this.textEditingController,
    this.isBold = false,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.fillColor,
    this.style,
    this.inputDecoration,
    this.prefixIcon,
    // this.focusNode,
  }) : super(key: key);

  final IconData? prefixIcon;
  final bool? isBold;
  final TextStyle? style;
  final bool? obscure;
  final String? hint;
  final String? label;
  final String? value;
  final bool? readonly;
  final Widget? suffix;
  final bool? floatLabel;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? textEditingController;
  final int? maxLines;
  final Color? fillColor;
  final TextInputAction? textInputAction;
  final InputDecoration? inputDecoration;

  // final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 5),
      child: TextFormField(
        onTap: onTap,
        onSaved: onSaved,
        onChanged: onChanged,
        // focusNode: focusNode ?? FocusNode(),
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        initialValue: value,
        maxLines: maxLines,
        //minLines: minLines,
        validator: validator,
        obscureText: obscure ?? false,
        controller: textEditingController,
        scrollPadding: const EdgeInsets.all(380),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: _pColor,
              width: 2,
            ),
          ),
          prefixIconColor: _pColor,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: _pColor,
              width: 2,
            ),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 12.0,
            // color: focusNode!.hasFocus ? _pColor : Colors.grey,
          ),
          prefixIcon: Icon(
            prefixIcon ?? Icons.verified_user,
            // color: focusNode!.hasFocus ? _pColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class AppPasswordField extends StatefulWidget {
  final IconData? icon;
  final String? hint;
  final bool? iconBool;
  final String? label;
  final BuildContext? context;
  final FormFieldValidator<String>? validator;
  final TextEditingController? textEditingController;
  final IconData? prefixIcon;

  // final FocusNode? focusNode;
  final Function(String)? onChanged;

  const AppPasswordField({
    Key? key,
    this.icon,
    this.onChanged,
    this.label,
    this.validator,
    this.prefixIcon,
    this.hint,
    this.context,
    this.iconBool,
    this.textEditingController, // this.validator,
    // this.focusNode,
  }) : super(key: key);

  @override
  _AppPasswordFieldState createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: TextFormField(
        onChanged: widget.onChanged,
        validator: widget.validator,
        obscureText: _show,
        // focusNode: widget.focusNode ?? FocusNode(),
        controller: widget.textEditingController,
        textInputAction: TextInputAction.next,
        scrollPadding: const EdgeInsets.all(380),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(
            // color: widget.focusNode!.hasFocus ? _pColor : Colors.grey ?? Colors.grey,
            fontSize: 12.0,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: _pColor,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: _pColor,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            widget.prefixIcon ?? Icons.verified_user,
            // color: widget.focusNode!.hasFocus ? _pColor : Colors.grey,
          ),
          suffixIcon: InkWell(
            onTap: () => setState(
              () => _show = !_show,
            ),
            child: Icon(
              _show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              // color: widget.focusNode!.hasFocus ? _pColor : Colors.grey,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class AppIconTextField extends StatefulWidget {
  AppIconTextField({
    Key? key,
    required this.textFieldController,
    this.labelText,
    this.isPassword = false,
    this.isRollNo = false,
    this.obscurePassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.labelStyle,
    this.isPhone = false,
    this.maxLength,
  }) : super(key: key);

  final String? Function(String?)? validator;
  final TextEditingController textFieldController;
  final String? labelText;
  final bool isPassword;
  final bool isRollNo;
  bool obscurePassword;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextStyle? labelStyle;
  final bool isPhone;
  final int? maxLength;

  @override
  State<AppIconTextField> createState() => _AppIconTextFieldState();
}

class _AppIconTextFieldState extends State<AppIconTextField> {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.maxLength.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: widget.maxLength ?? 1000,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? widget.obscurePassword : false,
        validator: widget.validator ??
            (value) => value!.isEmpty
                ? 'Please enter ' +
                    (widget.isPassword
                        ? 'password'
                        : widget.isRollNo
                            ? 'student ID'
                            : 'username')
                : null,
        // (value) => value!.isEmpty
        //     ? 'Please enter ' +
        //         (widget.isPassword
        //             ? 'password'
        //             : widget.isRollNo
        //                 ? 'student ID'
        //                 : 'username')
        //     : null,
        controller: widget.textFieldController,
        decoration: InputDecoration(
          labelText: widget.labelText ?? '',
          hintText: widget.hintText ?? '',
          labelStyle: widget.labelStyle ?? const TextStyle(fontSize: 12.0),
          border: const OutlineInputBorder(),
          counterText: '',
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: widget.obscurePassword
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  tooltip: 'Show Password',
                  onPressed: () => setState(() {
                    widget.obscurePassword = !widget.obscurePassword;
                  }),
                )
              : null,
          prefixIcon: widget.isPassword
              ? const Icon(Icons.lock)
              : widget.isPhone
                  ? const Icon(Icons.phone)
                  : (widget.isRollNo
                      ? const Icon(Icons.contact_mail)
                      : const Icon(Icons.account_circle)),
        ),
      ),
    );
  }
}

class SimpleAppTextField extends StatelessWidget {
  const SimpleAppTextField({
    Key? key,
    this.hint,
    this.onTap,
    this.label,
    this.value,
    this.obscure = false,
    this.suffix,
    this.onSaved,
    this.onChanged,
    this.readonly = false,
    this.validator,
    this.keyboardType,
    this.floatLabel = false,
    required this.textEditingController,
    this.isBold = false,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.fillColor,
    this.style,
    this.inputDecoration,
    this.maxLength,
    this.textCapitalization,
  }) : super(key: key);

  final bool? isBold;
  final TextStyle? style;
  final bool? obscure;
  final String? hint;
  final String? label;
  final String? value;
  final bool? readonly;
  final Widget? suffix;
  final bool? floatLabel;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? textEditingController;
  final int? maxLines;
  final Color? fillColor;
  final TextInputAction? textInputAction;
  final InputDecoration? inputDecoration;
  final int? maxLength;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 5),
      child: TextFormField(
        onTap: onTap,
        onSaved: onSaved,
        onChanged: onChanged,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        // focusNode: focusNode ?? FocusNode(),
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        initialValue: value,
        maxLines: maxLines,
        //minLines: minLines,
        validator: validator,
        obscureText: obscure ?? false,
        controller: textEditingController,
        scrollPadding: const EdgeInsets.all(380),
        maxLength: maxLength ?? 1000,
        decoration: InputDecoration(
          counterText: '',
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: _pColor,
              width: 2,
            ),
          ),
          prefixIconColor: _pColor,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: _pColor,
              width: 2,
            ),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xff77a500),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
