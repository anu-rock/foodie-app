import 'package:flutter/material.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/widgets/heading_2.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget bottom;

  CustomAppBar({@required this.title, this.bottom});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      backgroundColor: kColorLightGrey,
      leading: BackButton(
        color: kColorBluegrey,
      ),
      shape: Border(bottom: BorderSide(color: Colors.black12)),
      title: Heading2(this.title),
      elevation: 0,
      brightness: Brightness.light,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
}
