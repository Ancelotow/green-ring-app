import 'package:flutter/material.dart';
import 'package:green_ring/services/service_api.dart';
import 'package:green_ring/ui/homepage.dart';
import '../models/session.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      final user = await ServiceAPI().connection(emailController.text, passwordController.text);
      Navigator.pop(context);
      if(user == null) {
        wrongCredentials();
      } else {
        Session.open(user);
        Navigator.of(context).pushNamed(Homepage.routeName);
      }
    }
  }

  void wrongCredentials() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Votre identifiant et/ou votre mot de passe ont incorrects',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 200,
                  ),
                  const SizedBox(height: 75),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _textFieldValidator,
                      controller: emailController,
                      decoration:
                          const InputDecoration(labelText: "Identifiant"),
                      obscureText: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _textFieldValidator,
                      controller: passwordController,
                      decoration:
                          const InputDecoration(labelText: "Mot de passe"),
                      obscureText: true,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: signUserIn,
                    child: const Text("Connexion"),
                  ),
                  const SizedBox(height: 150),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _textFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Saisissez un texte';
    }
    return null;
  }
}
