import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:provider/provider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:foodieapp/widgets/custom_app_bar.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/screens/profile_user/user_profile_screen.dart';

class ContactListScreen extends StatefulWidget {
  final ContactListType type;

  ContactListScreen({
    @required this.type,
  });

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  Future<List<FAContact>> contactsFuture;
  List<FAContact> contacts;

  @override
  void initState() {
    super.initState();

    _getContacts();
  }

  void _getContacts() async {
    print('_getContacts called');

    switch (this.widget.type) {
      case ContactListType.phonebook:
        this.contactsFuture = _getPhonebookContacts();
        break;
      case ContactListType.facebook:
        break;
    }
  }

  Future<List<FAContact>> _getPhonebookContacts() async {
    List<FAContact> contacts = [];

    final userRepo = Provider.of<UserRepository>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);

    if (await Permission.contacts.request().isGranted) {
      final phoneContacts = await ContactsService.getContacts(withThumbnails: false);

      for (final c in phoneContacts) {
        final email = c.emails.first.value;

        if (email == appState.currentUser.email) {
          continue;
        }

        final user = await userRepo.getUserByEmail(email).first;

        contacts.add(FAContact(
          displayName: c.displayName,
          email: c.emails.first.value,
          userId: user != null ? user.id : null,
        ));
      }
    }

    return contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<FAContact>>(
        future: this.contactsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          }

          this.contacts = snapshot.data;

          return Scaffold(
            appBar: CustomAppBar(title: _getScreenTitle()),
            body: (this.contacts.isEmpty)
                ? _placeholder()
                : ListView.separated(
                    itemCount: this.contacts.length,
                    separatorBuilder: (context, index) => Divider(height: 1.0),
                    itemBuilder: (context, index) {
                      final contact = this.contacts[index];
                      return _contactTile(contact);
                    },
                  ),
          );
        },
      ),
    );
  }

  ListTile _contactTile(FAContact contact) {
    return ListTile(
      title: Text(contact.displayName),
      subtitle: Text(contact.email),
      trailing: contact.userId != null
          ? Icon(Icons.arrow_right)
          : FlatButton(
              color: Colors.blue,
              child: Text(
                'Invite',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _inviteContact,
            ),
      onTap: contact.userId == null ? null : () => _openUserProfile(contact.userId),
    );
  }

  String _getScreenTitle() {
    String title = '';

    switch (this.widget.type) {
      case ContactListType.phonebook:
        title = 'Phonebook Contacts';
        break;
      case ContactListType.facebook:
        title = 'Facebook Contacts';
        break;
    }
    return title;
  }

  Center _placeholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.speaker_notes_off,
            size: 60.0,
          ),
          Heading2('Nada. Nothing.'),
        ],
      ),
    );
  }

  void _openUserProfile(String userId) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UserProfileScreen(
          userId: userId,
        ),
      ),
    );
  }

  void _inviteContact() {
    Share.share(
      'Hey, I am a chef at home, thanks for Foodie App.'
      'Check it out.',
    );
  }
}

enum ContactListType {
  phonebook,
  facebook,
}

class FAContact {
  final String displayName;
  final String email;
  final String userId;

  FAContact({this.displayName, this.email, this.userId});
}
