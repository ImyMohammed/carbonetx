import 'package:carbonetx/screens/customer_dashboard/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[LogOutButton()],
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
