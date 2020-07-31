import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/screens/customer_dashboard/dropby_scheduled.dart';
import 'package:carbonetx/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:carbonetx/utilities/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_dashboard_screen.dart';
import 'package:carbonetx/screens/agent_dashboard/agent_dashboard.dart';
import 'package:carbonetx/screens/customer_dashboard/referrals.dart';
import 'package:carbonetx/screens/customer_dashboard/account_balance.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_profile.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:carbonetx/providers/loading_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:carbonetx/utilities/network_Status.dart';
import 'package:carbonetx/utilities/loading_status.dart';

class DashboardScreen extends StatefulWidget {
  static final DashboardScreen _dashboardScreen = DashboardScreen._internal();

  static const String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();

  factory DashboardScreen() {
    return _dashboardScreen;
  }

  DashboardScreen._internal();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  static final customerDashboardPage = CustomerDashboard();
  static final dropByScheduledPage = DropByScheduled();
  static final referralsPage = Referrals();
  static final accountBalance = AccountBalance();
  static final customerProfile = CustomerProfile();

  static final bottomNav = BottomNav();

  final userSession = Uuid().v4().toString();

  FirebaseUser loggedInUser;

  String pageTitle = 'Dashboard';

  var userData = UserData();

  final customerNavigationTabs = [
    customerDashboardPage,
    dropByScheduledPage,
    referralsPage,
    accountBalance,
    customerProfile,
  ];

  @override
  void initState() {
    super.initState();

    print(userSession);
    saveSession();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkMobNumber(context));
  }

  void saveSession() async {
    FlutterKeychain.put(key: "sessionID", value: userSession);
    print('Session saved');
  }

  Future checkMobNumber(BuildContext context) async {
    if (UserData().mobNumber != null) {
      Provider.of<CustomerDashboardData>(context, listen: false)
          .profileWarningOff();
    } else {
      Provider.of<CustomerDashboardData>(context, listen: false)
          .profileWarningOn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.transparent,
          body: customerNavigationTabs[
              Provider.of<TitleData>(context, listen: true).currentPage],
          bottomNavigationBar: bottomNav,
        ),
        NetworkStatus(),
        LoadingScreen(),
      ],
    );
  }
}
