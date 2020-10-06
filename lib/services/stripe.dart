import 'package:dio/dio.dart';

class StripeServices {
  // API Keys

  static const pub_key = 'pk_test_WLmHAmiHtLPQLG3cqPlGAJl300Oig3PRep';
  static const secret_key = 'sk_test_ckiE86rh5l3FCYc7Byk4y1m500PwNiq3Yx';

  // Stripe API URL's

  static const customersUrl = "https://api.stripe.com/v1/customers";
  static const chargeUrl = "https://api.stripe.com/v1/charges";

  static const createAccountUrl = "https://api.stripe.com/v1/accounts";

  static const removePaymentMethodUrl =
      "https://api.stripe.com/v1/payment_methods/";

  static const getCardUrl = "https://api.stripe.com/v1/customers/";

  Map<String, String> headers = {
    'Authorization': "Bearer $secret_key",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<String> createStripeCustomer(
      {String email, String name, String description}) async {
    Map<String, String> body = {
      'email': email,
      'name': name,
      'description': description,
    };

    String stripeId;
    dynamic request;
    try {
      Dio dio = Dio();
      request = await dio
          .post(customersUrl,
              data: body,
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        stripeId = response.data["id"];
        print(response.data);
      });
    } catch (err) {
      print('Error creating Stripe Customer: ${err.toString()}');
      return null;
    }
    print(stripeId);
    return stripeId;
  }

  Future<String> createStripeAccount(
      {String email, String firstName, String lastName}) async {
    dynamic body = {
      'type': 'custom',
      'country': 'GB',
      'email': email,
      "business_type": "individual",
      "business_profile": {
        "mcc": 7542,
        "name": "$firstName $lastName",
        "url": "https://www.facebook.com/carbonetx",
      },
      'individual': {
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      },
      "capabilities[card_payments][requested]": true,
      "capabilities[transfers][requested]": true
    };

    String accountId;
    dynamic request;
    try {
      Dio dio = Dio();
      request = await dio
          .post(createAccountUrl,
              data: body,
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        accountId = response.data["id"];
        print(response.data);
      });
    } catch (err) {
      print('Error creating Stripe Account: ${err.toString()}');
      return null;
    }
    print(accountId);
    return accountId;
  }

  Future<dynamic> removeCard(String stripeId, String cardId) async {
    print('$getCardUrl$stripeId/sources/$cardId');
    bool removedCard;
    dynamic request;
    try {
      Dio dio = Dio();
      request = await dio
          .delete('$getCardUrl$stripeId/sources/$cardId',
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        removedCard = true;
        print('Response data ${response.data}');
        print('Card removed');
      });
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio data ${e.response.data}');
        print('Dio response headers ${e.response.headers}');
        print('Dio response request ${e.response.request}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
      return e;
    }
    return removedCard;
  }

  Future<dynamic> getCard(String customerId, String cardId) async {
    print('$getCardUrl$customerId/sources/$cardId');
    dynamic request;
    dynamic cardData;
    try {
      Dio dio = Dio();
      request = await dio
          .get('$getCardUrl$customerId/sources/$cardId',
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        print('Payment method is valid ${response.data}');
        cardData = response.data;
        return response.data;
      });
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio data ${e.response.data}');
        print('Dio response headers ${e.response.headers}');
        print('Dio response request ${e.response.request}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
      return e;
    }
    return cardData;
  }

  Future<dynamic> addDebitToAccount() async {
    print(
        'https://api.stripe.com/v1/accounts/acct_1HEa3vAu3hKogMHf/external_accounts');
    dynamic request;
    dynamic cardData;
    dynamic body = {
      "individual": {
        "dob": {'day': 06, 'month': 12, 'year': 1960}
      }
    };
    print(body);
    try {
      Dio dio = Dio();
      request = await dio
          .post(
              'https://api.stripe.com/v1/accounts/acct_1HEa3vAu3hKogMHf/external_accounts',
              data: body,
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        print('Added card successfully ${response.data}');
        cardData = response.data;
      });
    } catch (err) {
      print('Unable to add card to account: ${err.toString()}');
      //return err;
    }
    return cardData;
  }
}
