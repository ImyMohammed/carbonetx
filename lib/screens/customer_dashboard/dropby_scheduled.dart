import 'package:flutter/material.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_dashboard_screen.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/utilities//book_button.dart';
import 'package:carbonetx/utilities/network_Status.dart';

class DropByScheduled extends StatefulWidget {
  static final DropByScheduled _dropByScheduled = DropByScheduled._internal();

  @override
  _DropByScheduledState createState() => _DropByScheduledState();

  factory DropByScheduled() {
    return _dropByScheduled;
  }
  DropByScheduled._internal();
}

class _DropByScheduledState extends State<DropByScheduled>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    //NetworkStatus().checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: kAppBackground,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[LogOutButton()],
            ),
            PageTitle(),
          ],
        ),
      ),
    );
  }
}
