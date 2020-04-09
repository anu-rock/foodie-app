import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/widgets/page_action_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmailPasswordFormState();
}

class EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            padding: kPaddingAll,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: kContBorderRadiusSm,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Email cannot be blank';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Password cannot be blank';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      this._errorMsg,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -25.0,
            child: Container(
              width: MediaQuery.of(context).size.width - kPaddingUnits * 2,
              padding: EdgeInsets.symmetric(horizontal: kPaddingUnits),
              child: PageActionButton(
                text: 'Come on in',
                onPressed: this._submitForm,
              ),
            ),
          ),
        ]);
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: this._emailController.text,
          password: this._passwordController.text,
        );
      } on PlatformException catch (e) {
        setState(() {
          this._errorMsg = e.message;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
