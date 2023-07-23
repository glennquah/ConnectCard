// import 'package:connectcard/screens/authenticate/sign_in.dart';
// import 'package:flutter_test/flutter_test.dart';

// class EmailFieldValidator {
//   static String? validate(String value) {
//     if (value.isEmpty || !value.contains('@')) {
//       return 'Email can\'t be empty and must include @';
//     }
//     // Add more email validation logic if needed
//     return null;
//   }
// }

// class PasswordFieldValidator {
//   static String? validate(String value) {
//     if (value.isEmpty || value.length < 6) {
//       return 'Password can\'t be empty and must be more than 6 characters';
//     }
//     // Add more password validation logic if needed
//     return null;
//   }
// }

// void main() {
//   testWidgets('Empty / wrong Email Test', (WidgetTester tester) async {
//     await tester.pumpWidget(SignIn(
//       toggleView: null, // Pass a valid toggleView function here
//     ));

//     var result = EmailFieldValidator.validate('');
//     expect(result, 'Email can\'t be empty and must include @');
//   });

//   testWidgets('Non-empty Email Test', (WidgetTester tester) async {
//     await tester.pumpWidget(SignIn(
//       toggleView: null, // Pass a valid toggleView function here
//     ));

//     var result = EmailFieldValidator.validate('valid@email.com');
//     expect(result, null);
//   });

//   testWidgets('Empty / short Password Test', (WidgetTester tester) async {
//     await tester.pumpWidget(SignIn(
//       toggleView: null, // Pass a valid toggleView function here
//     ));

//     var result = PasswordFieldValidator.validate('');
//     expect(
//         result, 'Password can\'t be empty and must be more than 6 characters');
//   });

//   testWidgets('Non-empty Password Test', (WidgetTester tester) async {
//     await tester.pumpWidget(SignIn(
//       toggleView: null, // Pass a valid toggleView function here
//     ));

//     var result = PasswordFieldValidator.validate('password');
//     expect(result, null);
//   });
// }
