import 'dart:ffi';

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
      textColor: kCrimson,
    );
  }

  @override
  void initState() {
    super.initState();
    //NetworkStatus().checkConnectivity(context);
    //_getCard();
    print('hello');
  }

  _delete() async {
    await for (var snapshot in Firestore.instance
        .collection('users')
        .document(UserData().userId)
        .collection('card')
        .where('userId', isEqualTo: UserData().userId)
        .snapshots()) {
      for (DocumentSnapshot data in snapshot.documents) {
        data.reference.delete();
      }
      print('deleted');
    }
  }

  _buildGenerateCode() {
    return Visibility(
      visible: true,
      child: RaisedButton(
        color: Colors.black45,
        elevation: 5,
        textColor: Colors.white,
        highlightColor: Colors.blue,
        hoverColor: Colors.blue,
        disabledColor: Colors.black45,
        disabledTextColor: Colors.black45,
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        splashColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        onPressed: () {
          print('Apply pressed');
          Toast.show("Pressed", context);
          setState(() {});
        },
        child: Text(
          'Generate Code',
          style: kBookButton,
        ),
      ),
    );
  }

  _cardsTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 100, 0),
      child: Text(
        'CARDS',
        style: TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 6.0,
                color: Colors.black45,
              ),
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 6.0,
                color: Colors.black45,
              ),
            ]),
      ),
    );
  }

  _addCardButton() {
    return Row(
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
                backgroundColor: Colors.black54,
                splashColor: kCrimson,
                onPressed: () {
                  print('add card');
                  HapticFeedback.mediumImpact();
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
    );
  }

  _webView() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StripeCardElement()));
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

  _buildStream() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(UserData().userId)
            .collection('card')
            .where('userId', isEqualTo: UserData().userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No card added',
                style: kLabelStyle,
              ),
            );
          }

          final card = snapshot.data.documents;
          print('has data ${!snapshot.hasData}');
          List<Container> cards = [];

          dataLoaded = true;

          for (var cardDetails in card) {
            final cardBrand = cardDetails.data['brand'];
            final last4 = cardDetails.data['last4'];
            final expMonth = cardDetails.data['expMonth'];

            print(cardDetails.data);

            print("Card data is loaded");

            final cardWidget = Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: RaisedButton(
                  disabledTextColor: Colors.greenAccent,
                  color: Colors.black45,
                  splashColor: kCrimson,
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
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Icon(
                                FontAwesomeIcons.ccVisa,
                                size: 18,
                                color: Colors.blue,
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
                            'XXXX XXXX XXXX $last4',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Visibility(
                                      visible:
                                          cardSelected == false ? true : false,
                                      child: Icon(
                                        FontAwesomeIcons.check,
                                        size: 18,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Visibility(
                                      visible:
                                          cardSelected == true ? true : false,
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Delete');
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.trash,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    cardSelected = !cardSelected;
                    HapticFeedback.mediumImpact();
                    Toast.show(
                      '$cardBrand $last4 selected!',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                      textColor: Colors.greenAccent,
                    );

                    setState(() {});
                  },
                  onLongPress: () {
                    _delete();
                    print('Long press');
                  },
                ),
              ),
            );
            cards.add(cardWidget);
          }

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
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                    ),
                    PageTitle(),
                    Card(
                      color: Colors.black54,
                      margin: EdgeInsets.fromLTRB(80, 30, 80, 16),
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
                    Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    _buildStream(),
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
