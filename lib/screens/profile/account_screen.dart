import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/widgets/custom_app_bar.dart';
import 'package:foodieapp/widgets/heading_3.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/widgets/page_action_button.dart';

class AccountScreen extends StatefulWidget {
  static const id = 'account';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String displayName;
  String photoUrl;
  bool savingInProgress = false;

  @override
  void initState() {
    super.initState();

    final appState = Provider.of<AppState>(context, listen: false);
    this.setState(() {
      this.displayName = appState.currentUser.displayName;
      this.photoUrl = appState.currentUser.photoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController(
      text: this.displayName,
    );

    return Scaffold(
      appBar: CustomAppBar(title: 'Account'),
      body: Container(
        padding: kPaddingAll,
        child: ListView(
          children: <Widget>[
            _nameSection(_nameController),
            SizedBox(height: 20.0),
            _photoSection(),
            SizedBox(height: 20.0),
            PageActionButton(
              text: this.savingInProgress ? 'Saving...' : 'Save',
              onPressed: this.savingInProgress ? null : _onSavePressed,
            )
          ],
        ),
      ),
    );
  }

  Column _photoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Heading3('Photo'),
        SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          padding: kPaddingAllSm,
          color: kColorLightGrey,
          child: RichText(
            softWrap: true,
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'Your photo is managed via a free online service called Gravatar. '),
                TextSpan(text: 'Head over to '),
                TextSpan(
                  text: 'gravatar.com',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = 'https://gravatar.com/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                ),
                TextSpan(text: ' to create or change your photo.'),
                TextSpan(text: '\n\nAlternatively, you can '),
                TextSpan(
                  text: 'remove your gravatar',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      this.photoUrl = null;
                      _showSnackBar('Photo will be removed. Tap Save to continue.');
                    },
                ),
                TextSpan(text: ' to default to a randomly assigned photo.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _nameSection(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Heading3('Name'),
        SizedBox(height: 10.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: kColorLightGrey,
              ),
            ),
          ),
          onChanged: (value) => this.displayName = value,
        ),
      ],
    );
  }

  Future<void> _onSavePressed() async {
    this.setState(() => this.savingInProgress = true);
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    await userRepo.updateProfile(displayName: this.displayName);

    _showSnackBar(
      'Profile updated. Log out and sign back in for changes to reflect.',
    );

    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
