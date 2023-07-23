import 'package:connectcard/services/auth.dart';
import 'package:connectcard/shared/constants.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';

// This class is used to sign in the user
class SignIn extends StatefulWidget {
  final Function? toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String error = '';
  String email = '';
  String password = '';

  Color bgColor = const Color(0xffFEAA1B);

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
                    const Text('Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold)),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                            ),
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
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                            ),
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
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Could not sign in with those credentials';
                                    loading = false;
                                  });
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
                                'Don\'t have an account?',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                              TextButton(
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 2, 146, 43),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () => widget.toggleView!(),
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
