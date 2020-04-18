import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

String firebaseAuthHandler(String error) {
  String errorMessage = error;

  if (errorMessage.contains('email != null') == true) {
    errorMessage = 'E-mail Address cannot be empty.';
    HapticFeedback.mediumImpact();
  } else if (errorMessage.contains('password != null')) {
    errorMessage = 'Password field cannot be empty.';
    HapticFeedback.mediumImpact();
  } else if (errorMessage.contains('ERROR_NETWORK_REQUEST_FAILED')) {
    errorMessage = 'No network connection.';
    HapticFeedback.mediumImpact();
  } else if (errorMessage.contains('ERROR_WEAK_PASSWORD')) {
    errorMessage = 'Password must be 6 characters or more.';
    HapticFeedback.mediumImpact();
  } else if (errorMessage.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
    errorMessage = 'The email address is already in use.';
    HapticFeedback.mediumImpact();
  } else if (errorMessage.contains('ERROR_INVALID_EMAIL')) {
    errorMessage = 'Use a valid e-mail example@example.com';
    HapticFeedback.mediumImpact();
  } else if (errorMessage.contains('ERROR_USER_NOT_FOUND')) {
    errorMessage = 'No account for this e-mail.';
    HapticFeedback.mediumImpact();
  } else if (errorMessage.contains('ERROR_WRONG_PASSWORD')) {
    errorMessage = 'Password is incorrect.';
    HapticFeedback.mediumImpact();
  } else {
    errorMessage = 'Sign-In failed! Check details & try again.';
  }

  print(errorMessage);

  return errorMessage;
}
