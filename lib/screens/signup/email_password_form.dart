import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/user/firebase_user_repository.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/widgets/page_action_button.dart';

final UserRepository user = FirebaseUserRepository();

class EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmailPasswordFormState();
}

class EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String resultMsg = '';
  bool signupInProgress = false;

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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Full name cannot be blank';
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
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Confirm Password cannot be blank';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      this.resultMsg,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
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
                text: this.signupInProgress ? 'Creating...' : 'Submit',
                onPressed: this.signupInProgress ? null : this._submitForm,
              ),
            ),
          ),
        ]);
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      this.setState(() => this.signupInProgress = true);
      var result = await user.signupWithEmail(
        this._emailController.text,
        this._nameController.text,
        this._passwordController.text,
        this._confirmPasswordController.text,
      );

      setState(() {
        this.signupInProgress = false;
        this.resultMsg = result.message;
      });

      if (result.isSuccessful) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 7),
            content: const Text('Sign up successful. Now let\'s log you in.'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
