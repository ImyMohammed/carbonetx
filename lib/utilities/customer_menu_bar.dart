import 'package:carbonetx/utilities/Gradient_Icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:carbonetx/constants/constants.dart';

class CustomerMenuBar extends StatefulWidget {
  static final CustomerMenuBar _customerMenuBar = CustomerMenuBar._internal();

  @override
  _CustomerMenuBarState createState() => _CustomerMenuBarState();

  factory CustomerMenuBar() {
    return _customerMenuBar;
  }

  CustomerMenuBar._internal();
}

class _CustomerMenuBarState extends State<CustomerMenuBar>
    with SingleTickerProviderStateMixin {
  bool warningIcon = true;

  toggleWarning() {
    Provider.of<CustomerDashboardData>(context, listen: true).profileWarning =
        !warningIcon;
    if (!mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Stack(
          children: <Widget>[
            IconButton(
              icon: GradientIcon(
                  FontAwesomeIcons.car,
                  25,
                  Provider.of<CustomerDashboardData>(context, listen: true)
                      .colors[0]),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                HapticFeedback.selectionClick();
                Provider.of<TitleData>(context, listen: false)
                    .changeTitle('Dashboard');
                Provider.of<CustomerDashboardData>(context, listen: false)
                    .changeStatus(0);
                Provider.of<TitleData>(context, listen: false).changePage(0);
                Provider.of<CustomerDashboardInfoData>(context, listen: false)
                    .changeTitle(0);
                Provider.of<DashboardSubtitleData>(context, listen: false)
                    .changeInfo(0);
              },
              iconSize: 25,
            ),
            Visibility(
              visible: false,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 3, 3, 3),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFFF41357),
                            Color(0xFFFF004D),
                          ],
                          stops: [0.5, 1],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        IconButton(
          icon: GradientIcon(
              FontAwesomeIcons.tint,
              25,
              Provider.of<CustomerDashboardData>(context, listen: true)
                  .colors[1]),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            HapticFeedback.selectionClick();
            print('Drops scheduled');
            Provider.of<TitleData>(context, listen: false)
                .changeTitle('Drops Scheduled');
            Provider.of<CustomerDashboardData>(context, listen: false)
                .changeStatus(1);
            Provider.of<TitleData>(context, listen: false).changePage(1);
          },
          iconSize: 25,
        ),
        IconButton(
          icon: GradientIcon(
              FontAwesomeIcons.userFriends,
              25,
              Provider.of<CustomerDashboardData>(context, listen: true)
                  .colors[2]),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            print('referrals pressed');
            HapticFeedback.selectionClick();
            Provider.of<TitleData>(context, listen: false)
                .changeTitle('Referrals');
            Provider.of<CustomerDashboardData>(context, listen: false)
                .changeStatus(2);
            Provider.of<TitleData>(context, listen: false).changePage(2);
          },
          iconSize: 25,
        ),
        Stack(
          children: <Widget>[
            IconButton(
              icon: GradientIcon(
                  FontAwesomeIcons.creditCard,
                  25,
                  Provider.of<CustomerDashboardData>(context, listen: true)
                      .colors[3]),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                HapticFeedback.selectionClick();
                print('card pressed');
                Provider.of<TitleData>(context, listen: false)
                    .changeTitle('Account Balance');
                Provider.of<CustomerDashboardData>(context, listen: false)
                    .changeStatus(3);
                Provider.of<TitleData>(context, listen: false).changePage(3);
              },
              iconSize: 25,
            ),
            Visibility(
              visible: Provider.of<CustomerDashboardData>(context, listen: true)
                  .cardWarning,
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 3, 3, 3),
                child: Icon(
                  FontAwesomeIcons.exclamationTriangle,
                  size: 20,
                  color: Color(0xffFFC100),
                ),
              ),
            )
          ],
        ),
        Stack(
          children: <Widget>[
            IconButton(
              icon: GradientIcon(
                  FontAwesomeIcons.userAlt,
                  25,
                  Provider.of<CustomerDashboardData>(context, listen: true)
                      .colors[4]),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                print('credit pressed');
                HapticFeedback.selectionClick();
                Provider.of<TitleData>(context, listen: false)
                    .changeTitle('My Profile');
                Provider.of<CustomerDashboardData>(context, listen: false)
                    .changeStatus(4);
                Provider.of<TitleData>(context, listen: false).changePage(4);
              },
              iconSize: 25,
            ),
            Visibility(
              visible: Provider.of<CustomerDashboardData>(context, listen: true)
                  .profileWarning,
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 3, 3, 3),
                child: Icon(
                  FontAwesomeIcons.exclamationTriangle,
                  size: 20,
                  color: Color(0xffFFC100),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
