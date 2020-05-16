import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/data/network/connection.dart';
import 'package:foodieapp/data/network/network_repository.dart';
import 'package:foodieapp/data/status/status.dart';
import 'package:foodieapp/data/status/status_repository.dart';
import 'package:foodieapp/models/app_state.dart';
import 'status_card.dart';

class SocialFeedScreen extends StatefulWidget {
  static const id = 'social_feed';

  @override
  _SocialFeedScreenState createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  Stream<List<Connection>> followeeStream;
  Stream<List<Status>> updateStream;

  @override
  void initState() {
    super.initState();

    _getFollowees();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<Connection>>(
          stream: this.followeeStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final followees = snapshot.data;
              // Calling this here rather than inside `initState()` will ensure
              // that following/unfollowing a user rebuilts this screen
              // with a refreshes social feed, including or excluding updates
              // from the user just followed or unfollowed.
              _getNetworkUpdates();

              return StreamBuilder<List<Status>>(
                stream: this.updateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final statuses = snapshot.data;
                    if (statuses.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Aww crap, you don\'t have any connections yet. '),
                          Text('Start following someone now.'),
                        ],
                      );
                    }
                    return _updatesList(statuses, followees);
                  }
                  return Text('Getting updates...');
                },
              );
            }
            return Text('Fetching friends...');
          }),
    );
  }

  ListView _updatesList(List<Status> data, List<Connection> followees) {
    return ListView(
      children: data.map((status) {
        final followee = followees.firstWhere((f) => f.followeeId == status.userId);
        return StatusCard(
          status: status,
          connection: followee,
        );
      }).toList(),
    );
  }

  void _getNetworkUpdates() {
    print('_getNetworkUpdates called');
    final statusRepo = Provider.of<StatusRepository>(context, listen: false);
    this.updateStream = statusRepo.getNetworkUpdates();
  }

  void _getFollowees() {
    print('_getFollowees called');
    final appState = Provider.of<AppState>(context, listen: false);
    final networkRepo = Provider.of<NetworkRepository>(context, listen: false);
    this.followeeStream = networkRepo.getFollowees(appState.currentUser.id);
  }
}
