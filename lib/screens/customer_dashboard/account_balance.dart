import 'package:carbonetx/components/raised_gradient_button.dart';
import 'package:carbonetx/providers/loading_bar.dart';
import 'package:carbonetx/screens/customer_dashboard/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carbonetx/data/user_data.dart';
import 'package:carbonetx/services/stripe.dart';
import 'package:carbonetx/screens/customer_dashboard/add_card/card_webview_screen.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:core';
import 'package:carbonetx/utilities/local_push_notifications.dart';

class AccountBalance extends StatefulWidget {
  static final AccountBalance _accountBalance = AccountBalance._internal();

  @override
  _AccountBalanceState createState() => _AccountBalanceState();

  factory AccountBalance() {
    return _accountBalance;
  }

  AccountBalance._internal();
}

class _AccountBalanceState extends State<AccountBalance>
    with SingleTickerProviderStateMixin {
  double width;
  double height;

  bool dataLoaded = false;

  bool cardSelected = false;

  void toast(String message) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.TOP,
      textColor: kMagenta,
    );
  }

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
    print('disposed');
  }

  @override
  void initState() {
    super.initState();
    //NetworkStatus().checkConnectivity(context);
    //_getCard();
    _checkCard();

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  _checkCard() async {
    if (UserData().cardAdded == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<CustomerDashboardData>(context, listen: false)
            .cardWarningOff();
        // Add Your Code here.
        if (mounted) {
          setState(() {});
        }

        print('card valid ${UserData().cardAdded}');
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<CustomerDashboardData>(context, listen: false)
            .cardWarningOn();

        // Add Your Code here.
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Future<bool> refreshCardData() async {
    var removed;
    if (Provider.of<CustomerDashboardData>(context, listen: true).cardChange ==
        true) {
      _checkCard();
      Provider.of<CustomerDashboardData>(context, listen: false).cardChange =
          false;
      removed = true;
    } else {
      refreshCardData();
      removed = false;
    }
    print('card is removed');
    return removed;
  }

  void refreshState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  _deleteCardAlert() {
    BuildContext dialogContext;
    return showDialog(
      context: context,
      builder: (context) {
        String contentText = 'Remove card ending in ${UserData().last4}?';
        return StatefulBuilder(builder: (context, setState) {
          return ScaleTransition(
            scale: scaleAnimation,
            child: AlertDialog(
              backgroundColor: Color(0xffe6e6e6),
              title: Text(
                'Remove Card',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05,
                  color: Colors.black87,
                  fontFamily: 'OpenSans',
                ),
              ),
              content: Container(
                height: height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(contentText,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            fontFamily: 'OpenSans',
                            fontSize: width * 0.045)),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedGradientButton(
                  width: width * 0.35,
                  height: height * 0.1,
                  gradient: gradientTheme,
                  child: Text(
                    'REMOVE',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    Toast.show(
                      'Card removed!',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                      textColor: kMagenta,
                    );
                    print(UserData().cardAdded);
                    setState(() {
                      contentText = "Removing...";
                      print(contentText);
                    });

                    try {
                      await StripeServices()
                          .removeCard(UserData().stripeID, UserData().cardId);
                    } catch (e) {
                      print('Card removed on stripe $e');
                    }
                    await UserData().deleteCard();
                    setState(() {
                      contentText = "Removed!";
                      print(contentText);
                    });
                    Navigator.pop(context);

                    dataLoaded = false;
                    Provider.of<CustomerDashboardData>(context, listen: false)
                        .cardWarningOn();
                    Provider.of<CustomerDashboardData>(context, listen: false)
                        .cardChanged();
                    await refreshCardData();
                  },
                )
              ],
            ),
          );
        });
      },
    );
  }

  _withdrawButton() {
    return Visibility(
      visible: true,
      child: RaisedButton(
        color: Colors.black87,
        elevation: 15,
        textColor: Colors.black,
        highlightColor: Colors.black,
        hoverColor: Colors.black,
        disabledColor: Colors.black45,
        disabledTextColor: Colors.black45,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        splashColor: Colors.black,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          print('Withdraw pressed');
          Toast.show("Pressed", context);
          HapticFeedback.lightImpact();
          print(UserData().last4);
          print(UserData().expYear);
          await UserData().getCard(UserData().userId);
          await LocalPushNotifications().createState().showNotification();
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                'Withdraw',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(10, 0, 0, 0)),
            Icon(
              FontAwesomeIcons.lock,
              size: 18,
              color: kMagenta,
            )
          ],
        ),
      ),
    );
  }

  _cardsTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 100, 0),
      child: Text(
        'CARD',
        style: TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 1.0,
                color: Colors.black45,
              ),
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 1.0,
                color: Colors.black45,
              ),
            ]),
      ),
    );
  }

  _addCardButton() {
    return Visibility(
      visible: UserData().cardAdded == true ? false : true,
      child: Row(
        children: <Widget>[
          Spacer(),
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: FloatingActionButton(
                  elevation: 3,
                  child: Icon(
                    FontAwesomeIcons.creditCard,
                    color: Colors.white,
                    size: 23,
                  ),
                  backgroundColor: Colors.black87,
                  splashColor: kMagenta,
                  hoverColor: kMagenta,
                  onPressed: () {
                    print('Withdraw');
                    HapticFeedback.selectionClick();
                    //cardFormVisible = !cardFormVisible;
                    _webView();
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 5, 0, 10),
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 10,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _webView() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCardScreen()));
    HapticFeedback.lightImpact();
  }

/*  Future<Map> getCard(String userId) async {
    Map card = Map<String, String>();
    print('get card data');
    print('userId of card holder is $userId');
    await for (var snapshot in Firestore.instance
        .collection('users')
        .document(UserData().userId)
        .collection('card')
        .where('userId', isEqualTo: UserData().userId)
        .snapshots()) {
      for (var messages in snapshot.documents) {
        print(messages.data);
        print(messages.data['brand']);
        card = {'brand': messages.data['brand']};
        card = {'userId': messages.data['userId']};
        card = {'last4': messages.data['last4']};
        card = {'expiryDate': messages.data['expiryDate']};
        print(card['brand']);
      }
      print('Finished');

      return card;
    }
  }*/

  _buildCard() {
    return UserData().cardAdded
        ? Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: RaisedButton(
                disabledTextColor: Colors.greenAccent,
                color: Colors.black87,
                splashColor: kMagenta,
                elevation: 8,
                clipBehavior: Clip.antiAlias,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(1, 16, 16, 16),
                            child: Image.asset(
                              UserData().getCardBrand(UserData().cardBrand),
                              fit: BoxFit.fill,
                              width: width * 0.17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '**** **** **** ${UserData().last4}',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Credit Card',
                              fontSize: 13),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Expires: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 13),
                            ),
                            Text(
                              '${UserData().expMonth}/${UserData().expYear.substring(2)}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Credit Card',
                                  fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: UserData().cardAdded == true
                                      ? Icon(
                                          FontAwesomeIcons.check,
                                          size: 18,
                                          color: Colors.greenAccent,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Toast.show(
                                              'Card is invalid!',
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.TOP,
                                              textColor: Colors.amber,
                                            );
                                          },
                                          child: Icon(
                                            FontAwesomeIcons
                                                .exclamationTriangle,
                                            size: 18,
                                            color: Colors.amber,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();

                  Toast.show(
                    'Current card! Hold to remove.',
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.TOP,
                    textColor: Colors.greenAccent,
                  );
                },
                onLongPress: () {
                  print('long press');
                  _deleteCardAlert();
                },
              ),
            ),
          )
        : Center(child: Text('No card', style: kLabelStyle));
  }

  _buildStream() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(UserData().userId)
            .collection('card')
            .where('userId', isEqualTo: UserData().userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          }

          if (Provider.of<CustomerDashboardData>(context, listen: true)
                  .cardChange ==
              true) {
            _checkCard();
            Provider.of<CustomerDashboardData>(context, listen: false)
                .cardChange = false;
          } else {}

          final card = snapshot.data.docs;
          List<Container> cards = [];
          for (var cardDetails in card) {
            final cardBrand = cardDetails.data()['brand'];
            final last4 = cardDetails.data()['last4'].toString();
            final expMonth = cardDetails.data()['expMonth'].toString();
            final expYear = cardDetails.data()['expYear'].toString();

            double width = MediaQuery.of(context).size.width;

            final cardWidget = Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: RaisedButton(
                  disabledTextColor: Colors.greenAccent,
                  color: Colors.black87,
                  splashColor: kMagenta,
                  elevation: 8,
                  clipBehavior: Clip.antiAlias,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(1, 16, width * 0.02, 16),
                              child: Image.asset(
                                UserData().getCardBrand(cardBrand),
                                fit: BoxFit.fill,
                                width: width * 0.17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '**** **** **** $last4',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Credit Card',
                                fontSize: width * 0.035),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Expires: ',
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: width * 0.035),
                              ),
                              Text(
                                '$expMonth/${expYear.substring(2)}',
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Credit Card',
                                    fontSize: width * 0.03),
                              )
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: UserData().cardAdded == true
                                  ? Icon(
                                      FontAwesomeIcons.check,
                                      size: 18,
                                      color: Colors.greenAccent,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Toast.show(
                                          'Card is invalid!',
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.TOP,
                                          textColor: Colors.amber,
                                        );
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.exclamationTriangle,
                                        size: 18,
                                        color: Colors.amber,
                                      ),
                                    ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();

                    Toast.show(
                      'Current card! Hold to remove.',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                      textColor: Colors.greenAccent,
                    );
                  },
                  onLongPress: () {
                    print('long press');
                    _deleteCardAlert();
                  },
                ),
              ),
            );
            cards.add(cardWidget);
          }
          if (dataLoaded == false) {
            print('refresh');
            refreshState();
          }
          dataLoaded = true;
          return Column(children: cards);
        });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kAppBackground,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20, 35, 20, 20),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    ),
                    Center(child: Text('Account', style: kPageTitle)),
                    Card(
                      color: Colors.black87,
                      margin: EdgeInsets.fromLTRB(
                          width * 0.18, 30, width * 0.18, 16),
                      elevation: 8,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 16, 0, 16),
                            child: Icon(
                              FontAwesomeIcons.wallet,
                              size: 20,
                              color: Colors.greenAccent,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: AutoSizeText(
                                '£0.00',
                                maxLines: 1,
                                minFontSize: 18,
                                maxFontSize: 20,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _cardsTitle(),
                    _addCardButton(),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 30, 0, 0)),
                    _buildStream(),
                    Padding(padding: const EdgeInsets.fromLTRB(0, 30, 0, 0)),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                        children: [Spacer(), _withdrawButton(), Spacer()],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
