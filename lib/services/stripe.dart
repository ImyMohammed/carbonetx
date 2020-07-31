import 'package:toast/toast.dart';
import 'package:carbonetx/screens/customer_dashboard/account_balance.dart';

import 'package:carbonetx/data/user_data.dart';
import 'package:dio/dio.dart';

class StripeServices {
  // API Keys

  static const pub_key = 'pk_test_WLmHAmiHtLPQLG3cqPlGAJl300Oig3PRep';
  static const secret_key = 'sk_test_ckiE86rh5l3FCYc7Byk4y1m500PwNiq3Yx';

  // Stripe API URL's

  static const paymentMethodUrl = "https://api.stripe.com/v1/payment_methods";
  static const customersUrl = "https://api.stripe.com/v1/customers";
  static const chargeUrl = "https://api.stripe.com/v1/charges";

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
      print('Error adding Stripe Customer: ${err.toString()}');
      return null;
    }
    print(stripeId);
    return stripeId;
  }
}
