import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udemy_app/shared/components/components.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isPassword = true;
    var emailcontroller = TextEditingController();
    var passwordcontroller = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  defaultTextFormField(
                    onSubmit: (value) {
                      setState(() {
                        print(value);
                      });
                    },
                    controller: emailcontroller,
                    label: 'email',
                    prefix: Icons.email_outlined,
                    type: TextInputType.emailAddress,
                    validate: (String value) {
                      if (value.isNotEmpty) {
                        return 'email must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  defaultTextFormField(
                    suffixPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    sufix: isPassword ? Icons.visibility : Icons.visibility_off,
                    isPassword: isPassword,
                    controller: passwordcontroller,
                    label: 'password',
                    prefix: Icons.lock,
                    type: TextInputType.visiblePassword,
                    validate: (String value) {
                      if (value.isNotEmpty) {
                        return 'password must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  defaultButton(
                      radius: 10.0,
                      isUppercase: true,
                      text: 'login',
                      function: () {
                        if (formKey.currentState.validate()) {
                          print(emailcontroller.text);
                          print(passwordcontroller.text);
                        }
                      }),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  defaultButton(
                      text: 'register',
                      function: () {
                        if (formKey.currentState.validate()) {
                          print(emailcontroller.text);
                          print(passwordcontroller.text);
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {},
                        child: Text('Register Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
