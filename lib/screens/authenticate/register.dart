import 'package:connectcard/screens/authenticate/onboarding.dart';
import 'package:connectcard/services/auth.dart';
import 'package:connectcard/shared/constants.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This class is used to register a user
class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool instructionsShown = false;

  String email = '';
  String password = '';
  String phoneNum = '';
  String error = '';

  Color bgColor = const Color(0xffFEAA1B);

  Future<void> _showOnboarding(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomOnboarding();
      },
    );
    // Onboarding completed, mark instructions as shown
    setState(() {
      instructionsShown = true;
    });
  }

  bool isEmailValid(String email) {
    String emailRegex =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Regular expression for email format
    return RegExp(emailRegex).hasMatch(email);
  }

  // Check if the email is already registered with Firebase
  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      return false; // Return false on error (email is not registered)
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: bgColor,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    Container(
                      width: 200.0,
                      height: 200.0,
                      child: const Image(
                        image: AssetImage('assets/logo/ConnectCardLogo.jpg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Phone Number',
                              prefixIcon: const Icon(Icons.phone),
                            ),
                            // phone number must be integers
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Enter a phone number';
                              }
                              // Regular expression pattern to match the allowed format (+ and integers only)
                              RegExp regex = RegExp(r'^\+?[0-9]+$');
                              if (!regex.hasMatch(val)) {
                                return 'Invalid phone number';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() => phoneNum = val);
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.email)),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Enter an email';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (val) {
                              if (val == null || val.length < 6) {
                                return 'Enter a password 6+ chars long';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Check if the email is valid
                                if (!isEmailValid(email)) {
                                  setState(() {
                                    error = 'Invalid email, please try again';
                                  });
                                  return;
                                }

                                // Check if the email is already registered
                                bool isRegistered =
                                    await isEmailAlreadyRegistered(email);
                                if (isRegistered) {
                                  setState(() {
                                    error = 'Email is already registered';
                                  });
                                  return;
                                }

                                // Show the onboarding only if the email is valid and not registered
                                await _showOnboarding(context);

                                // Check if the user completed the onboarding
                                if (!instructionsShown) {
                                  // User didn't complete the onboarding, return early
                                  return;
                                }

                                setState(() {
                                  loading = true;
                                });

                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        phoneNum, email, password);

                                setState(() {
                                  loading = false;
                                });

                                if (result == null) {
                                  setState(() {
                                    error = 'Please supply a valid email';
                                  });
                                } else {
                                  widget
                                      .toggleView(); // Navigate to the login page
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                              TextButton(
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 2, 146, 43),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () => widget.toggleView(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
