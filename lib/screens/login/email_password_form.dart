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
  final TextEditingController _passwordController = TextEditingController();

  String resultMsg = '';
  bool loginInProgress = false;

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
                text: this.loginInProgress ? 'Logging in...' : 'Come on in',
                onPressed: this.loginInProgress ? null : this._submitForm,
              ),
            ),
          ),
        ]);
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      this.setState(() => this.loginInProgress = true);
      var result = await user.loginWithEmail(
        this._emailController.text,
        this._passwordController.text,
      );
      setState(() {
        this.loginInProgress = false;
        this.resultMsg = result.message;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
