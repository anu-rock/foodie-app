import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/data/network/connection.dart';
import 'package:foodieapp/data/network/network_repository.dart';
import 'package:foodieapp/screens/profile_user/user_profile_screen.dart';
import 'package:foodieapp/widgets/custom_app_bar.dart';
import 'package:foodieapp/widgets/heading_2.dart';

class ConnectionListScreen extends StatefulWidget {
  final ConnectionListType type;
  final String userId;

  ConnectionListScreen({
    @required this.type,
    @required this.userId,
  });

  @override
  _ConnectionListScreenState createState() => _ConnectionListScreenState();
}

class _ConnectionListScreenState extends State<ConnectionListScreen> {
  Stream<List<Connection>> connectionsStream;

  @override
  void initState() {
    super.initState();

    _getConnections();
  }

  void _getConnections() {
    print('_getConnections called');
    final networkRepo = Provider.of<NetworkRepository>(context, listen: false);

    switch (this.widget.type) {
      case ConnectionListType.followers:
        this.connectionsStream = networkRepo.getFollowers(this.widget.userId);
        break;
      case ConnectionListType.following:
        this.connectionsStream = networkRepo.getFollowees(this.widget.userId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<Connection>>(
        stream: this.connectionsStream,
        builder: (context, snapshot) {
          final connections = snapshot.data;

          return Scaffold(
            appBar: CustomAppBar(title: _getScreenTitle()),
            body: (!snapshot.hasData || connections.isEmpty)
                ? _placeholder()
                : ListView.separated(
                    itemCount: connections.length,
                    separatorBuilder: (context, index) => Divider(height: 1.0),
                    itemBuilder: (context, index) {
                      final connection = connections[index];
                      ListTile tile;

                      switch (this.widget.type) {
                        case ConnectionListType.followers:
                          tile = _followerTile(connection);
                          break;
                        case ConnectionListType.following:
                          tile = _followeeTile(connection);
                          break;
                      }

                      return tile;
                    },
                  ),
          );
        },
      ),
    );
  }

  ListTile _followerTile(Connection connection) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(connection.followerPhotoUrl),
      ),
      title: Text(connection.followerName),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => UserProfileScreen(
              userId: connection.followerId,
            ),
          ),
        );
      },
    );
  }

  ListTile _followeeTile(Connection connection) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(connection.followeePhotoUrl),
      ),
      title: Text(connection.followeeName),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => UserProfileScreen(
              userId: connection.followeeId,
            ),
          ),
        );
      },
    );
  }

  String _getScreenTitle() {
    String title = '';

    switch (this.widget.type) {
      case ConnectionListType.followers:
        title = 'Followers';
        break;
      case ConnectionListType.following:
        title = 'Following';
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
}

enum ConnectionListType {
  followers,
  following,
}
