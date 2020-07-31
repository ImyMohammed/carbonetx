import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/utilities/book_button.dart';
import 'package:carbonetx/data/user_data.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CustomerDashboard extends StatefulWidget {
  static final CustomerDashboard _customerDashboard =
      CustomerDashboard._internal();

  static String regSelected;

  @override
  _CustomerDashboardState createState() => _CustomerDashboardState();

  factory CustomerDashboard() {
    return _customerDashboard;
  }

  CustomerDashboard._internal();
}

class _CustomerDashboardState extends State<CustomerDashboard>
    with SingleTickerProviderStateMixin {
  var _carMakeTC = TextEditingController();
  var _carModelTC = TextEditingController();
  var _carRegTC = TextEditingController();

  final _scrollController = ScrollController();

  var carRegArray = [];
  int carsNo = 0;

  var isCheckedBool = [];

  bool dataLoaded = false;

  double width;
  double height;

  String _carMake;
  String _carModel;
  String _carRegNo;

  @override
  void initState() {
    super.initState();
    //NetworkStatus().checkConnectivity(context);
    if (dataLoaded == true) {
      print("reload");
      _reloadCars();
    }
  }

  _reloadCars() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildStream();
      setState(() {});
    });
  }

  bool _checkCar(String regNo) {
    bool isSelected;
    if (CustomerDashboard.regSelected == regNo) {
      isSelected = true;
    } else {
      isSelected = false;
    }

    return isSelected;
  }

  _addCarButton() {
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
                  FontAwesomeIcons.carAlt,
                  color: Colors.white,
                ),
                backgroundColor: Colors.black54,
                splashColor: kCrimson,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  print('add car');
                  _addCar();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 7, 0, 10),
              child: Icon(
                FontAwesomeIcons.plus,
                color: Colors.white,
                size: 12,
              ),
            )
          ],
        )
      ],
    );
  }

  _buildStream() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(UserData().userId)
            .collection('cars')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No cars',
                style: kLabelStyle,
              ),
            );
          }

          var index = 0;
          final cars = snapshot.data.documents;
          carsNo = cars.length;
          print('length is $carsNo');
          List<Container> carNames = [];
          carRegArray.clear();

          dataLoaded = true;

          for (var carMake in cars) {
            final carBrand = carMake.data['carMake'];
            final carModel = carMake.data['carModel'];
            final regNo = carMake.data['regNo'];
            _carMake = carBrand;
            _carModel = carModel;
            _carRegNo = regNo;

            carRegArray.add(regNo);
            isCheckedBool.add(false);

            print(carRegArray);

            var pos = carRegArray.indexWhere((pos) => pos.startsWith('$regNo'));
            final carWidget = Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
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
                                FontAwesomeIcons.car,
                                size: 18,
                                color: _checkCar(regNo) == true
                                    ? kCrimson
                                    : Colors.grey,
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
                            '$carBrand',
                            style: TextStyle(
                                color: _checkCar(regNo) == true
                                    ? kCrimson
                                    : Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$carModel',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: _checkCar(regNo) == true
                                    ? kCrimson
                                    : Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$regNo',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: _checkCar(regNo) == true
                                    ? kCrimson
                                    : Colors.white,
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
                                  Visibility(
                                    visible: _checkCar(regNo),
                                    child: Icon(
                                      FontAwesomeIcons.check,
                                      size: 18,
                                      color: kCrimson,
                                    ),
                                  ),
                                  Visibility(
                                    visible: _checkCar(regNo) == false
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                      onTap: () {
                                        _carMake = carBrand;
                                        _carModel = carModel;
                                        _carRegNo = regNo;
                                        print('Delete');
                                        _deleteCar();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                        color: Colors.grey,
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
                    print('Car $carBrand');
                    print('Index $index');
                    print('Index pos is $pos');
                    isCheckedBool[pos] = true;
                    CustomerDashboard.regSelected = regNo;
                    print('Reg selected $regNo');
                    print(carRegArray);
                    HapticFeedback.mediumImpact();
                    Toast.show(
                      '$carBrand $carModel selected!',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                      textColor: kCrimson,
                    );
                    for (var i = 0; i < carsNo; i++) {
                      if (i != pos) {
                        isCheckedBool[i] = false;
                        HapticFeedback.lightImpact();
                      }
                    }

                    setState(() {});
                  },
                  onLongPress: () {
                    print('Long press');
                  },
                ),
              ),
            );
            carNames.add(carWidget);
            index++;
          }

          return Column(children: carNames);
        });
  }

  _addCar() {
    print('cars no is $carsNo');
    return showDialog(
        context: context,
        builder: (context) {
          print(_carModelTC.text);
          print(_carMakeTC.text);
          print(_carRegTC.text);
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Color(0xFF3A3A39),
            title: Text(
              'Add your car',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
            ),
            content: SizedBox(
              height: height * 0.25,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kAddCarFields,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextField(
                          inputFormatters: [],
                          controller: _carMakeTC,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            print(_carMakeTC.text);
                            HapticFeedback.lightImpact();
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.carAlt,
                              color: Colors.white,
                            ),
                            hintText: "Car make?",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: kAddCarFields,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextField(
                          inputFormatters: [],
                          textCapitalization: TextCapitalization.sentences,
                          controller: _carModelTC,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            print(_carModelTC.text);
                            HapticFeedback.lightImpact();
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.carSide,
                              color: Colors.white,
                            ),
                            hintText: "Car model?",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: kAddCarFields,
                        child: TextField(
                          inputFormatters: [],
                          controller: _carRegTC,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            print(_carRegTC.text);
                            HapticFeedback.lightImpact();
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.ticketAlt,
                              color: Colors.white,
                            ),
                            hintText: "Reg No?",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                height: 40,
                minWidth: 100,
                color: Color(0xFFFF0362),
                elevation: 5.0,
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                textColor: Colors.black,
                onPressed: () {
                  if (_carModelTC.text == "" ||
                      _carMakeTC.text == "" ||
                      _carRegTC.text == "") {
                    Toast.show(
                      'Complete all fields!',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                      textColor: kCrimson,
                    );
                    HapticFeedback.lightImpact();
                    print(carRegArray);
                  } else {
                    print('save car');
                    Navigator.pop(context);
                    UserData().addCar(
                        _carMakeTC.text, _carModelTC.text, _carRegTC.text);
                    for (var i = 0; i < carsNo; i++) {
                      isCheckedBool[i] = false;
                    }
                    _carModelTC.clear();
                    _carMakeTC.clear();
                    _carRegTC.clear();
                    setState(() {});
                  }
                },
              )
            ],
          );
        });
  }

  bool _checkReg(String regToAdd) {
    bool regExists = false;
    for (var reg in carRegArray) {
      if (reg == carRegArray) {
        regExists = true;
      } else {
        regExists = false;
      }
    }
    return regExists;
  }

  _deleteCar() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF3A3A39),
            title: Text(
              'Remove Car',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
            ),
            content: Text(
                '$_carMake\n'
                '$_carModel\n'
                '$_carRegNo\n',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: kCrimson,
                  fontFamily: 'OpenSans',
                )),
            actions: <Widget>[
              Center(
                child: MaterialButton(
                  minWidth: 100,
                  color: Color(0xFFFF0362),
                  elevation: 5.0,
                  child: Text(
                    'REMOVE',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  textColor: Colors.black,
                  onPressed: () {
                    print('removed');
                    Navigator.pop(context);
                    UserData().deleteCar(_carRegNo);
                    Toast.show(
                      'Removed!',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                      textColor: kCrimson,
                    );
                    HapticFeedback.lightImpact();
                    setState(() {});
                  },
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: kAppBackground,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(5, 35, 5, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
            ),
            PageTitle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            Container(
              height: height * 0.51,
              width: width,
              child: Stack(
                children: <Widget>[
                  Swiper(
                      indicatorLayout: PageIndicatorLayout.NONE,
                      containerHeight: height * 0.51,
                      containerWidth: width * 0.99,
                      itemWidth: width * 0.8,
                      itemHeight: height * 0.51,
                      layout: SwiperLayout.STACK,
                      viewportFraction: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Card(
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.fitHeight,
                              ),
                              elevation: 4,
                              clipBehavior: Clip.antiAlias,
                            ));
                      },
                      curve: Curves.easeInOut,
                      fade: 10,
                      itemCount: 4,
                      pagination: null,
                      controller: SwiperController(),
                      scrollDirection: Axis.horizontal,
                      autoplay: true,
                      duration: 300,
                      autoplayDisableOnInteraction: true,
                      autoplayDelay: 5000,
                      onIndexChanged: (int index) {
                        Provider.of<CustomerDashboardInfoData>(context,
                                listen: false)
                            .changeTitle(index);
                        Provider.of<DashboardSubtitleData>(context,
                                listen: false)
                            .changeInfo(index);
                      }),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          width * 0.14, height * 0.36, 0, 0),
                      child: CustomerDashboardInfo()),
                  Container(
                      width: 270,
                      margin: EdgeInsets.fromLTRB(
                          width * 0.14, height * 0.41, 50, 0),
                      child: DashboardSubtitle())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            BookButton(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 100, 0),
              child: Text(
                'SELECT YOUR CAR',
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
            ),
            _addCarButton(),
            _buildStream(),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 50))
          ],
        ),
      ),
    );
  }
}
