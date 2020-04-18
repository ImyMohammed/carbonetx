import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  static final UserData _singleton = UserData._internal();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  static dynamic name;
  static dynamic email;
  static dynamic emailVerified;
  static dynamic mobileNumber;
  static dynamic mobileVerified;
  static dynamic accountType;

  static dynamic userData;

  static dynamic referralCode;

  static dynamic stripeID;

  static bool dataLoaded = false;

  static List<Map<dynamic, dynamic>> carList;

  void initState() {}

  Future currentUser() async {
    return _auth.currentUser().then((value) {
      print('get current user');
      String userEmail = value.email;
      email = userEmail;
      getData(value.email);
      getCars(value.email);
      print(email);
    });
  }

  Future getData(String userEmail) async {
    print('get user data');
    await for (var snapshot in _firestore
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .snapshots()) {
      for (var messages in snapshot.documents) {
        // print(messages.data);
        name = messages.data['name'];
        userData = messages.data;
        emailVerified = messages.data['emailVerified'];
        mobileNumber = messages.data['mobileNumber'];
        accountType = messages.data['accountType'];
        referralCode = messages.data['referralCode'];
        stripeID = messages.data['stripeID'];
        print(accountType);
      }
    }
  }

  static Future addMobileNumber(String mobileNumber, String userEmail) async {
    await Firestore.instance
        .collection('users')
        .document(userEmail)
        .updateData({'mobileNumber': mobileNumber}).then((value) {});
  }

  static Future addReferralCode(String email, String code) async {
    await Firestore.instance
        .collection('referrals')
        .document(code)
        .setData({'email': '$email', 'uses': 1, 'referralCode': code});
  }

  static Future addReferralCodeToUser(String email, String code) async {
    await Firestore.instance
        .collection('users')
        .document(email)
        .updateData({'referralCode': code});
  }

  static Future addReferral(String email, String code) async {
    await Firestore.instance
        .collection('users')
        .document(email)
        .collection('referrals')
        .document('userReferrals')
        .setData({'email': '$email', 'uses': 1, 'referralCode': code});
  }

  static Future addStripeID(String stripeId) async {
    await Firestore.instance
        .collection('users')
        .document(email)
        .updateData({'stripeID': stripeId});
  }

  static Future addCar(
      String email, String carMake, String carModel, String regNo) async {
    await Firestore.instance
        .collection('users')
        .document(email)
        .collection('cars')
        .add({
      'carMake': carMake,
      'carModel': carModel,
      'regNo': regNo.toUpperCase()
    });
  }

  static Future deleteCar(String email, String regNo) async {
    await for (var snapshot in Firestore.instance
        .collection('users')
        .document(email)
        .collection('cars')
        .where('regNo', isEqualTo: regNo)
        .snapshots()) {
      for (var cars in snapshot.documents) {
        // print(cars.data);
        cars.reference.delete();
      }
    }
  }

/*  static void getCars(String email) async {
    final cars = await Firestore.instance
        .collection('users')
        .document(email)
        .collection('cars')
        .getDocuments();

    for (var car in cars.documents) {
      print(car.data);
      print(cars.documents.length);
    }
  }*/

  Future getCars(String email) async {
    await for (var snapshot in Firestore.instance
        .collection('users')
        .document(email)
        .collection('cars')
        .snapshots()) {
      for (var cars in snapshot.documents) {
        // print(cars.data);
        carList.add(cars.data);
      }
    }
  }

  factory UserData() {
    return _singleton;
  }

  UserData._internal();
}
