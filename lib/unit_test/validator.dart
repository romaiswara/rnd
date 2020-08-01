class Validator {
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is empty';
    }
    if (value.length < 6) {
      return 'Email min 6 character';
    }
    if (RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return 'Email valid';
    }
    return 'Email invalid';
  }

  static String validatePassword(String value) {
    bool upperCase = RegExp(r'^(?=.*?[A-Z])$').hasMatch(value);
    bool lowerCase = RegExp(r'^(?=.*?[a-z])$').hasMatch(value);
    bool number = RegExp(r'^(?=.*?[0-9])$').hasMatch(value);
    bool special_character = RegExp(r'^(?=.*?[#?!@$%^&*-])$').hasMatch(value);
    if (value.isEmpty) {
      return 'Password is empty';
    }
    if (value.length < 6) {
      return 'Password min 6 character';
    }
    if (!upperCase) {
      return 'Password harus mengandung uppercase';
    }
    if (!lowerCase) {
      return 'Password harus mengandung lowerCase';
    }
    if (!upperCase) {
      return 'Password harus mengandung upperCase';
    }
    if (!number) {
      return 'Password harus mengandung number';
    }
    if (!special_character) {
      return 'Password harus mengandung special_character';
    }
    if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$').hasMatch(value)) {
      return 'Password valid';
    }
    return 'Password invalid';
  }
}
