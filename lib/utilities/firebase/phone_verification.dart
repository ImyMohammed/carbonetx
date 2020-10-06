import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerification {
  static final PhoneVerification _phoneVerification =
      PhoneVerification._internal();

  @override
  factory PhoneVerification() {
    return _phoneVerification;
  }

  PhoneVerification._internal();
}
