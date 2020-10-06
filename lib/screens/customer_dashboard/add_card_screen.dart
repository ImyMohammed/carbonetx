import 'dart:convert';
import 'package:carbonetx/components/raised_gradient_button.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/data/user_data.dart';
import 'package:carbonetx/screens/customer_dashboard/add_card/expiry_date_picker.dart';
import 'package:carbonetx/screens/customer_dashboard/add_card/submit_card_button.dart';
import 'package:carbonetx/utilities/Gradient_Icon.dart';
import 'package:carbonetx/utilities/expiry_date-formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:flip_card/flip_card.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:carbonetx/icons/cvc_icon.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class AddCardScreen extends StatefulWidget {
  static final AddCardScreen _addCardScreen = AddCardScreen._internal();

  @override
  _AddCardScreenState createState() => _AddCardScreenState();

  factory AddCardScreen() {
    return _addCardScreen;
  }

  AddCardScreen._internal();
}

class _AddCardScreenState extends State<AddCardScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusScopeNode _node = FocusScopeNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final now = new DateTime.now();

  int currentYear;
  int currentMonth;

  double width;
  double height;

  static String _cardNumber = "XXXX XXXX XXXX XXXX";
  String get cardNumber => _cardNumber;

  static String _cardHolder = "CARD HOLDER";
  String get cardHolder => _cardHolder;

  static String _cvcNumber = "XXX";
  String get cvcNumber => _cvcNumber;

  static String _expData = "MM/YY";
  String get expData => _expData;

  var currDt = DateTime.now();
  var monthValid = false;
  var yearValid = false;

  //int month;
  //int year;

  FocusNode cardNumberFocusNode;
  FocusNode cardHolderNameFocusNode;
  FocusNode cvcFocusNode;
  FocusNode expDataNode;

  bool cvcFocus = false;

  Color expDateColour = Colors.grey;

  TextEditingController nameController;
  TextEditingController expDateController = TextEditingController();

  Icon cardIcon = Icon(
    FontAwesomeIcons.creditCard,
    color: Colors.grey,
  );

  Icon userIcon = Icon(
    FontAwesomeIcons.user,
    color: Colors.grey,
  );

  Icon cvcIcon = Icon(
    CvcIcon.cvcIcon,
    color: Colors.grey,
  );

  Icon expDataIcon = Icon(
    FontAwesomeIcons.calendarAlt,
    color: Colors.grey,
  );

  @override
  void initState() {
    super.initState();
    cardNumberFocusNode = FocusNode();
    cardHolderNameFocusNode = FocusNode();
    cvcFocusNode = FocusNode();
    expDataNode = FocusNode();

    cardNumberFocusNode.addListener(checkCardNumberFocus);
    cardHolderNameFocusNode.addListener(checkCardHolderFocus);
    cvcFocusNode.addListener(checkcvcFocus);
    expDataNode.addListener(checkexpDateFocus);

    currentMonth = currDt.month;
    currentYear = currDt.year;
  }

  checkCardNumberFocus() {
    if (cardNumberFocusNode.hasFocus) {
      setState(() {
        cardIcon = Icon(
          FontAwesomeIcons.creditCard,
          color: Colors.purpleAccent,
        );
      });
      if (cvcFocus) {
        cardKey.currentState.toggleCard();
        cvcFocus = false;
      }
    } else {
      setState(() {
        cardIcon = Icon(
          FontAwesomeIcons.creditCard,
          color: Colors.grey,
        );
      });
    }
  }

  checkCardHolderFocus() {
    if (cardHolderNameFocusNode.hasFocus) {
      setState(() {
        userIcon = Icon(
          FontAwesomeIcons.user,
          color: Colors.purpleAccent,
        );
      });
      if (cvcFocus) {
        cardKey.currentState.toggleCard();
        cvcFocus = false;
      }
    } else {
      setState(() {
        userIcon = Icon(
          FontAwesomeIcons.user,
          color: Colors.grey,
        );
      });
    }
  }

  checkcvcFocus() {
    if (cvcFocusNode.hasFocus) {
      setState(() {
        cvcIcon = Icon(
          CvcIcon.cvcIcon,
          color: Colors.purpleAccent,
          size: width * 0.085,
        );
      });
    } else {
      if (cvcFocus == false) {
        setState(() {
          cvcIcon = Icon(
            CvcIcon.cvcIcon,
            color: Colors.grey,
            size: width * 0.085,
          );
        });
      }
    }
  }

  checkexpDateFocus() {
    if (expDataNode.hasFocus) {
      setState(() {
        expDataIcon = Icon(
          FontAwesomeIcons.calendarAlt,
          color: Colors.purpleAccent,
        );
        if (cvcFocus) {
          cardKey.currentState.toggleCard();
          cvcFocus = false;
        }
      });
    } else {
      setState(() {
        expDataIcon = Icon(
          FontAwesomeIcons.calendarAlt,
          color: Colors.grey,
        );
      });
    }
  }

  _datePicker() {
    var _dateTime = DateTime.now();
    var minExpDate = DateTime(_dateTime.year,
        _dateTime.month < 12 ? _dateTime.month + 1 : 0, 0, 0, 0, 0, 0, 0);
    var maxExpDate = DateTime(_dateTime.year + 50, 12, 0, 0, 0, 0, 0, 0);
    return showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, height * 0.15, 0, height * 0.15),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white70,
              title: Text(
                'Card Expiry Date',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
              content: SizedBox(
                width: width,
                height: height * 0.5,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DatePickerWidget(
                      initialDateTime: _dateTime,
                      minDateTime: minExpDate,
                      maxDateTime: maxExpDate,
                      dateFormat: 'MM-yyyy',
                      onMonthChangeStartWithFirstDate: true,
                      onChange: (date, time) {
                        print(date);
                        print(time);
                        HapticFeedback.selectionClick();
                        setState(() {
                          _expData =
                              '${date.month}/${date.year.toString().substring(2, 4)}';
                          expDateColour = Colors.black;
                        });
                      },
                      pickerTheme: DateTimePickerTheme(
                          backgroundColor: Colors.transparent,
                          itemTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                          cancelTextStyle: TextStyle(),
                          confirm: Text(''),
                          cancel: Text('')),
                      onCancel: () {},
                      onConfirm: (date, time) {
                        print(date);
                        print(time);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.black,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  var cardNumberMaskFormatter = new MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

  var cardHolderMaskFormatter =
      new MaskTextInputFormatter(filter: {"#": RegExp(r'[0-9]')});

  var cvcMaskFormatter =
      new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

  var expDataMonthFormatter = new MaskTextInputFormatter(
      mask: '#m/y#',
      filter: {
        "#": RegExp(r'[0-1]'),
        "m": RegExp(r'[2-9]|1[0-2]?'),
        "y": RegExp(r'[2-7]')
      });

//  var expDateFormatter = new ExpiryDataFormatter(mask: 'mm/##', separator: '/');

  int clear = 0;

  Future<bool> clearExpDate() async {
    if (clear == 0) {
      expDateController.value = TextEditingValue.empty;
      expDateController.text = '';
      expDateController.clear();
      expDateController.clearComposing();
      expDateController.value = TextEditingValue(text: '');
      clear++;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    cardIcon = Icon(
      FontAwesomeIcons.creditCard,
      size: width * 0.055,
    );
    userIcon = Icon(
      FontAwesomeIcons.user,
      size: width * 0.055,
    );
    cvcIcon = Icon(
      CvcIcon.cvcIcon,
      color: Colors.purpleAccent,
      size: width * 0.085,
    );
    expDataIcon = Icon(
      FontAwesomeIcons.calendar,
      color: Colors.grey,
      size: width * 0.055,
    );
    checkCardNumberFocus();
    checkCardHolderFocus();
    checkcvcFocus();
    checkexpDateFocus();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: GradientIcon(
            FontAwesomeIcons.arrowLeft,
            30,
            gradientTheme,
          ),
          onPressed: () async {
            Navigator.pop(context);
            HapticFeedback.selectionClick();
            _cardNumber = "XXXX XXXX XXXX XXXX";
            _cardHolder = "CARD HOLDER";
            _cvcNumber = "XXX";
            _expData = "MM/YY";
            setState(() {});
          },
        ),
        title: Text(
          'Add your card',
          style: TextStyle(
              foreground: Paint()..shader = linearGradient,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kAppBackground,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (cvcFocus) {
              cardKey.currentState.toggleCard();
              cvcFocus = false;
            }
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                ),
                Center(child: Text('Account', style: kPageTitle)),
                SizedBox(height: height * 0.02),
                FlipCard(
                  key: cardKey,
                  flipOnTouch: false,
                  front: Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: width * 1, minHeight: height * 0.32),
                      child: Container(
                        child: GradientCard(
                          gradient: gradientTheme,
                          elevation: 7.0,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 20, 0),
                                    child: Image.asset(
                                      'images/visa.png',
                                      width: width * 0.2,
                                      height: height * 0.06,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                                child: Image.asset(
                                  'images/chip.png',
                                  width: width * 0.18,
                                  height: height * 0.07,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    18, 10, width * 0.08, 0),
                                child: Text(
                                  _cardNumber,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Credit Card',
                                      fontSize: width * 0.05,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2.0,
                                          color: Colors.black,
                                        ),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18.0, 10, 18, 0),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Text(
                                    _cardHolder,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Credit Card',
                                        fontSize: width * 0.056,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 2.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 2.0,
                                            color: Colors.black,
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18.0, 10, 18, 0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      _expData,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Credit Card',
                                          fontSize: width * 0.045,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 2.0,
                                              color: Colors.black,
                                            ),
                                            Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 2.0,
                                              color: Colors.black,
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  back: Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: width * 1, minHeight: height * 0.32),
                      child: Container(
                        child: GradientCard(
                          gradient: gradientTheme,
                          elevation: 7.0,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, height * 0.05, 0, 0),
                                child: SizedBox(
                                    height: height * 0.07,
                                    child: Container(color: Colors.black87)),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                        height: height * 0.05,
                                        child: Container(
                                          color: Colors.white,
                                        )),
                                    SizedBox(
                                        height: height * 0.07,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, width * 0.2, 0),
                                          child: Container(
                                            color: Colors.blueGrey,
                                          ),
                                        )),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, width * 0.04, 0),
                                          child: Text(
                                            _cvcNumber,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Credit Card',
                                              fontSize: width * 0.046,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: FocusScope(
                    node: _node,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin:
                              const EdgeInsets.only(left: 0, top: 0, right: 0),
                          color: Colors.transparent,
                          child: Card(
                            color: Colors.white,
                            elevation: 7.0,
                            shadowColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardAppearance: Brightness.dark,
                                autofocus: true,
                                focusNode: cardNumberFocusNode,
                                autocorrect: false,
                                cursorColor: Colors.black,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  checkCardNumberFocus();
                                },
                                onChanged: (value) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _cardNumber = value;
                                    if (cardNumber == "") {
                                      _cardNumber = 'XXXX XXXX XXXX XXXX';
                                    }
                                    print(cardNumber.length);
                                  });
                                  if (cardNumber.length >= 19) {
                                    _node.nextFocus();
                                  }
                                },
                                inputFormatters: [cardNumberMaskFormatter],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Open Sans',
                                    fontSize: width * 0.04),
                                decoration: new InputDecoration(
                                    prefixIcon: cardIcon,
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 2.0)),
                                    labelText: 'Card Number',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Open Sans',
                                      fontSize: width * 0.05,
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Credit Card',
                                        fontSize: width * 0.04),
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                    alignLabelWithHint: true),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin:
                              const EdgeInsets.only(left: 0, top: 0, right: 0),
                          color: Colors.transparent,
                          child: Card(
                            color: Colors.white,
                            elevation: 7.0,
                            shadowColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextFormField(
                                  autocorrect: false,
                                  focusNode: cardHolderNameFocusNode,
                                  keyboardAppearance: Brightness.dark,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  enableInteractiveSelection: true,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    checkCardHolderFocus();
                                  },
                                  onChanged: (value) {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      _cardHolder = value.toUpperCase();
                                      if (cardHolder == "") {
                                        _cardHolder = "CARD HOLDER";
                                      }
                                    });
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[A-z]+|\s")),
                                  ],
                                  controller: nameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Open Sans',
                                      fontSize: width * 0.05),
                                  decoration: new InputDecoration(
                                      prefixIcon: userIcon,
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: const BorderSide(
                                            color: Colors.black12, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color: Colors.purpleAccent,
                                              width: 2.0)),
                                      labelText: 'Card Holder Name',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Open Sans',
                                        fontSize: width * 0.05,
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Open Sans',
                                          fontSize: width * 0.04),
                                      hintText: 'Full Name',
                                      alignLabelWithHint: true),
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {
                                    cvcFocus = true;
                                    HapticFeedback.selectionClick();
                                    cardKey.currentState.toggleCard();
                                    _node.nextFocus();
                                    setState(() {});
                                  }),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin:
                              const EdgeInsets.only(left: 0, top: 0, right: 0),
                          color: Colors.transparent,
                          child: Card(
                            color: Colors.white,
                            elevation: 7.0,
                            shadowColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autocorrect: false,
                                cursorColor: Colors.black,
                                keyboardAppearance: Brightness.dark,
                                textCapitalization: TextCapitalization.words,
                                onEditingComplete: () {
                                  print('Done');
                                },
                                enableInteractiveSelection: true,
                                onTap: () {
                                  if (!cvcFocus) {
                                    cardKey.currentState.toggleCard();
                                    cvcFocus = true;
                                    HapticFeedback.selectionClick();
                                  }
                                },
                                onChanged: (value) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _cvcNumber = value;
                                    if (_cvcNumber.length == 3) {
                                      cvcFocus = false;
                                      FocusScope.of(context).unfocus();
                                      checkexpDateFocus();
                                      cardKey.currentState.toggleCard();
                                    }
                                    if (_cvcNumber == "" ||
                                        _cvcNumber == null) {
                                      _cvcNumber = 'XXX';
                                    }
                                  });
                                },
                                inputFormatters: [cvcMaskFormatter],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Open Sans',
                                    fontSize: width * 0.05),
                                decoration: new InputDecoration(
                                    prefixIcon: cvcIcon,
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors.purpleAccent,
                                            width: 2.0)),
                                    labelText: 'CVC Number',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Open Sans',
                                      fontSize: width * 0.05,
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Open Sans',
                                        fontSize: width * 0.04),
                                    hintText: 'Enter your CVC No.',
                                    alignLabelWithHint: true),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            margin: const EdgeInsets.only(
                                left: 0, top: 0, right: 0),
                            child: Card(
                              color: Colors.white,
                              elevation: 7.0,
                              shadowColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  autocorrect: false,
                                  cursorColor: Colors.black,
                                  keyboardAppearance: Brightness.dark,
                                  onEditingComplete: () {},
                                  focusNode: expDataNode,
                                  controller: expDateController,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    _datePicker();
                                  },
                                  onChanged: (value) {},
                                  inputFormatters: [expDataMonthFormatter],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Open Sans',
                                      fontSize: width * 0.05),
                                  decoration: new InputDecoration(
                                      prefixIcon: expDataIcon,
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: const BorderSide(
                                            color: Colors.black12, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                              color: Colors.purpleAccent,
                                              width: 2.0)),
                                      labelText: 'Expiry Data',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Open Sans',
                                        fontSize: width * 0.05,
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Open Sans',
                                          fontSize: width * 0.04),
                                      hintText: 'MM/YY',
                                      alignLabelWithHint: true),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          margin:
                              const EdgeInsets.only(left: 0, top: 0, right: 0),
                          child: Card(
                            color: Colors.white,
                            elevation: 8,
                            clipBehavior: Clip.antiAlias,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                _datePicker();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
                                    border: Border.all(
                                      color: Color(
                                          0xffd9d9d9), //                   <--- border color
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  width * 0.025, 16, 12, 16),
                                              child: Icon(
                                                FontAwesomeIcons.calendarAlt,
                                                size: width * 0.06,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            expData,
                                            style: TextStyle(
                                              color: expDateColour,
                                              fontFamily: 'Open Sans',
                                              fontSize: width * 0.045,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: null,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        submitCardButton(context),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
