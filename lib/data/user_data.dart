import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

class UserData {
  static final UserData _userData = UserData._internal();

  @override
  factory UserData() {
    return _userData;
  }

  UserData._internal();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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

  String _status;
  String get status => _status;

  String _userId;
  String get userId => _userId;

  String _referralCode;
  String get referralCode => _referralCode;
  set setReferralCode(String code) {
    _referralCode = code;
  }

  String _stripeId;
  String get stripeID => _stripeId;

  String _accountId;
  String get accountId => _accountId;

  String sessionID;
  String password;

  bool _dataLoaded;
  bool get dataLoaded => _dataLoaded;

  bool _cardAdded = false;
  bool get cardAdded => _cardAdded;
  set addCard(bool addCard) {
    _cardAdded = addCard;
  }

  List<Map<dynamic, dynamic>> _carList;
  List<Map<dynamic, dynamic>> get carList => _carList;

  String _cardBrand;
  String get cardBrand => _cardBrand;

  String _last4;
  String get last4 => _last4;

  String _expMonth;
  String get expMonth => _expMonth;

  String _expYear;
  String get expYear => _expYear;

  String _paymentMethod;
  String get paymentMethod => _paymentMethod;

  bool _isValidCard = false;
  bool get isValidCard => _isValidCard;
  set isCardValid(bool validity) {
    _isValidCard = validity;
  }

  bool _isIdVerified = false;
  bool get isIdVerified => _isIdVerified;
  set isVerified(bool validity) {
    _isIdVerified = validity;
  }

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  String _cardId;
  String get cardId => _cardId;
  set setCardId(String cardId) {
    _cardId = cardId;
  }

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

  Future<bool> getData(String userId) async {
    print('get user data');
    print('got a userId $userId');
    _firestore.clearPersistence();
    await for (var snapshot in _firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .snapshots()) {
      for (var messages in snapshot.docs) {
        _name = messages.data()['name'];
        _mobileNumber = messages.data()['mobileNumber'];
        _accountType = messages.data()['accountType'];
        _userId = messages.data()['userId'];
        _referralCode = messages.data()['referralCode'];
        _stripeId = messages.data()['stripeId'];
        _email = messages.data()['email'];
        _accountId = messages.data()['accountId'];
        print(_referralCode);
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
    await getData(userLoggedIn.user.uid);
    bool gotCard = await checkIfDocExists(userLoggedIn.user.uid);

    if (gotCard) {
      print('we got a card');
      await getCard(userLoggedIn.user.uid);
    } else {
      print('we got no card');
    }
    //await getCard(userLoggedIn.user.uid);
    print('data loaded? yes');

    return true;
  }

  Future addMobileNumber(String mobileNumber, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'mobileNumber': mobileNumber}).then((value) {});
  }

  Future addReferralCode(String code) async {
    await _firestore.collection('referralCodes').doc(code).set({
      'email': email,
      'uses': 3,
      'referralCode': code,
      'userId': userId,
      'stripeId': stripeID,
      'accountId': accountId,
    });
  }

  Future addReferralCodeToUser(String refCode) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'referralCode': refCode, 'accountBalance': 0});
  }

  Future addStripeID(String stripeId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'stripeID': stripeId});
  }

  Future addCar(String carMake, String carModel, String regNo) async {
    await _firestore
        .collection('users')
        .doc(UserData().userId)
        .collection('cars')
        .add({
      'carMake': carMake,
      'carModel': carModel,
      'regNo': regNo.toUpperCase(),
      'userId': UserData().userId
    });
  }

  Future saveUserDetails(String userId, String newUserEmail,
      String newUsersName, String stripeId, String accountId) async {
    print('save attempt');
    await _firestore.collection('users').doc(userId).set({
      'accountType': 'customer',
      'email': newUserEmail,
      'mobileNumber': 'Enter your Mob No.',
      'name': newUsersName,
      'userId': userId,
      'stripeId': stripeId,
      'accountId': accountId
    });
  }

  Future deleteCar(String regNo) async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection('users')
        .doc(UserData()._userId)
        .collection('cars')
        .where('regNo', isEqualTo: regNo)
        .snapshots()) {
      for (var cars in snapshot.docs) {
        print(cars.data);
        cars.reference.delete();
      }
    }
  }

  Future<bool> deleteCard() async {
    await for (var snapshot in _firestore
        .collection('users')
        .doc(UserData().userId)
        .collection('card')
        .where('userId', isEqualTo: UserData().userId)
        .snapshots()) {
      for (DocumentSnapshot data in snapshot.docs) {
        data.reference.delete();
        print('deleted');
        _cardAdded = false;
        _cardId = null;
        _expMonth = null;
        _expYear = null;
        _cardBrand = null;
        _last4 = null;
      }
      return true;
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
    await for (var snapshot in FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cars')
        .snapshots()) {
      for (var cars in snapshot.docs) {
        carList.add(cars.data());
      }
    }
  }

  Future<bool> checkIfDocExists(String userId) async {
    bool gotCard;
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('card')
          .where('userId', isEqualTo: userId)
          .get();

      if (snapShot.docs.length < 1) {
        // Document with id == docId doesn't exist.
        print('Nope sorry');
        gotCard = false;
      } else {
        print('Yes it exists');
        gotCard = true;
        _cardAdded = true;
      }
    } catch (e) {
      print('Sorry unable to find card $e');
    }

    return gotCard;
  }

  Future getCard(String userId) async {
    print('getting card data');
    await for (var snapshot in _firestore
        .collection('users')
        .doc(userId)
        .collection('card')
        .where('userId', isEqualTo: userId)
        .snapshots()) {
      for (var cardDetails in snapshot.docs) {
        _cardBrand = cardDetails.data()['brand'];
        _last4 = cardDetails.data()['last4'];
        _expMonth = cardDetails.data()['expMonth'].toString();
        _expYear = cardDetails.data()['expYear'].toString();
        _paymentMethod = cardDetails.data()['paymentMethod'];
        _cardId = cardDetails.data()['cardId'];
        _cardAdded = true;
        print(cardDetails.data());
      }
      return _cardAdded;
    }
  }

  String getCardBrand(String issuer) {
    switch (issuer) {
      case "Visa":
        {
          return "images/visa.png";
        }
        break;

      case "MasterCard":
        {
          return "images/mastercard.png";
        }
        break;

      case "American Express":
        {
          return "images/amex.png";
        }
        break;

      default:
        {
          return "images/generic.png";
        }
        break;
    }
  }
}
