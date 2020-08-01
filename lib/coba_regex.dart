main() {
  String hallo = 'hallo';
  if (RegExp(r'^(?=.*?[A-Z])$').hasMatch(hallo)) {
    print('THIS IS UPPERCASE');
  } else {
    print('NOT UPPERCASE');
  }
  if (RegExp(r'^(?=.*?[a-z])$').hasMatch(hallo)) {
    print('THIS IS LOWERCASE');
  } else {
    print('NOT LOWERCASE');
  }

  if (RegExp(r'^(?=.*?[0-9])$').hasMatch(hallo)) {
    print('THIS IS NUMBER');
  } else {
    print('NOT NUMBER');
  }

//  if (RegExp(r'^(?=.*?[A-Z])$').hasMatch(hallo)) {
//    print('THIS IS UPPERCASE');
//  } else {
//    print('NOT UPPERCASE');
//  }
//
//  if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$').hasMatch(hallo)) {
//
//  }
}
