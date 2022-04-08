String? emailValidator(String? value) {
  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value!)) {
    return 'Please provide a valid email';
  }
  return null;
}

String? passwordValidator(String? value) => value!.isEmpty
    ? 'Enter Password'
    : value.length < 8
        ? 'Password is too short'
        : null;
