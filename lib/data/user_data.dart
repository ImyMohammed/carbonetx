import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:carbonetx/main.dart';

class UserData {
  static final UserData _userData = UserData._internal();

  @override
  factory UserData() {
    return _userData;
  }

  UserData._internal();

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  String _name;
  String get name => _name;

  String _email;
  String get email => _email;

  String _mobileNumber;
  set updateNumber(String newNumber) {
    _mobileNumber = newNumber;
  }

  String get mobNumber {
    return _mobileNumber;
  }

  String _accountType;
  String get accountType => _accountType;

  String _userId;
  String get userId => _userId;

  String _referralCode;
  String get referralCode => _referralCode;

  String _stripeId;
  String get stripeID => _stripeId;

  String sessionID;
  String password;

  bool _dataLoaded;
  bool get dataLoaded => _dataLoaded;

  List<Map<dynamic, dynamic>> _carList;
  List<Map<dynamic, dynamic>> get carList => _carList;

  void initState() {}

  Future getEmail() async {
    var retrievedEmail = await FlutterKeychain.get(key: "carbonetx_email");
    if (retrievedEmail != null) {
      _email = retrievedEmail;
      print(email);
    }

    return retrievedEmail;
  }

  Future getPassword() async {
    var retrievedPassword =
        await FlutterKeychain.get(key: "carbonetx_password");
    if (retrievedPassword != null) {
      password = retrievedPassword;
      print(password);
    }

    return retrievedPassword;
  }

  Future getSession() async {
    var userSessionID = await FlutterKeychain.get(key: "sessionID");
    if (userSessionID != null) {
      print('SessionID is $userSessionID');
      sessionID = userSessionID;
    } else {
      print('No session');
    }

    return userSessionID;
  }

  Future<String> currentUser() async {
    await _auth.currentUser().then((value) {
      print('get current user');
      String userEmail = value.email;
      _email = userEmail;
      print('value of UID is ${value.uid}');
      getData(value.uid);
    });
    return userId;
  }

  Future<bool> getData(String userId) async {
    print('get user data');
    print('got a userId $userId');
    await for (var snapshot in _firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .snapshots()) {
      for (var messages in snapshot.documents) {
        print(messages.data);
        _name = messages.data['name'];
        _mobileNumber = messages.data['mobileNumber'];
        _accountType = messages.data['accountType'];
        _userId = messages.data['userId'];
        _referralCode = messages.data['referralCode'];
        _stripeId = messages.data['stripeId'];
        _email = messages.data['email'];
        print(email);
        print(_accountType);
        print('user id is $_userId');
      }
      print('Finished');

      return true;
    }
  }

  Future<bool> loadUserProfile() async {
    _email = await getEmail();
    password = await getPassword();
    final userLoggedIn = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    //_email = userLoggedIn.user.email;
    print('User logged in: ${userLoggedIn.user.uid}');
    bool loadData = await getData(userLoggedIn.user.uid);
    print('data loaded? $loadData');

    return true;
  }

  Future addMobileNumber(String mobileNumber, String userId) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({'mobileNumber': mobileNumber}).then((value) {});
  }

  Future addReferralCode(String email, String code) async {
    await Firestore.instance
        .collection('referrals')
        .document(code)
        .setData({'email': '$email', 'uses': 1, 'referralCode': code});
  }

  Future addReferralCodeToUser(String email, String code) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({'referralCode': code});
  }

  Future addReferral(String email, String code) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('referrals')
        .document('userReferrals')
        .setData({'email': '$email', 'uses': 1, 'referralCode': code});
  }

  Future addStripeID(String stripeId) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({'stripeID': stripeId});
  }

  Future addCar(String carMake, String carModel, String regNo) async {
    await Firestore.instance
        .collection('users')
        .document(UserData().userId)
        .collection('cars')
        .add({
      'carMake': carMake,
      'carModel': carModel,
      'regNo': regNo.toUpperCase(),
      'userId': UserData().userId
    });
  }

  Future saveUserDetails(String userId, String newUserEmail,
      String newUsersName, String stripeId) async {
    print('save attempt');
    await Firestore.instance.collection('users').document(userId).setData({
      'accountType': 'customer',
      'email': newUserEmail,
      'mobileNumber': 'Enter your Mob No.',
      'name': newUsersName,
      'userId': userId,
      'stripeId': stripeId
    });
  }

  Future deleteCar(String regNo) async {
    await for (var snapshot in Firestore.instance
        .collection('users')
        .document(UserData()._userId)
        .collection('cars')
        .where('regNo', isEqualTo: regNo)
        .snapshots()) {
      for (var cars in snapshot.documents) {
        print(cars.data);
        cars.reference.delete();
      }
    }
  }

/*  static void getCars(String email) async {
    final cars = await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('cars')
        .getDocuments();

    for (var car in cars.documents) {
      print(car.data);
      print(cars.documents.length);
    }
  }*/

  Future getCars(String userId) async {
    await for (var snapshot in Firestore.instance
        .collection('users')
        .document(userId)
        .collection('cars')
        .snapshots()) {
      for (var cars in snapshot.documents) {
        carList.add(cars.data);
      }
    }
  }
}
