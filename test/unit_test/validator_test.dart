import 'package:flutter_test/flutter_test.dart';
import 'package:rndroma/unit_test/validator.dart';

void main() {
  group('Validasi email', (){

    test('Check validate email is empty', (){
      String email = Validator.validateEmail('');
      expect(email, 'Email is empty');
    });

    test('Check validate email with input hallo', (){
      String email = Validator.validateEmail('hallo');
      expect(email, 'Email min 6 character');
    });

    test('Check validate email with input hallo boy', (){
      String email = Validator.validateEmail('hallo boy');
      expect(email, 'Email invalid');
    });

    test('Check validate email with input 08122345667890', (){
      String email = Validator.validateEmail('08122345667890');
      expect(email, 'Email invalid');
    });

    test('Check validate email with input hallo@g.com', (){
      String email = Validator.validateEmail('hallo@g.com');
      expect(email, 'Email valid');
    });
  });

  group('Validasi password', (){

    test('Check validate password is empty', (){
      String password = Validator.validatePassword('');
      expect(password, 'Password is empty');
    });

    test('Check validate password with input hallo', (){
      String password = Validator.validatePassword('hallo');
      expect(password, 'Password min 6 character');
    });

    test('Check validate password with input hallo Boy', (){
      String password = Validator.validatePassword('hallo Boy');
      expect(password, 'Password invalid');
    });

    test('Check validate password with input hallo Boy 123', (){
      String password = Validator.validatePassword('hallo Boy 123');
      expect(password, 'Password invalid');
    });

    test('Check validate password with input hallo Boy 123 &', (){
      String password = Validator.validatePassword('hallo Boy 123 &');
      expect(password, 'Password valid');
    });
  });
}