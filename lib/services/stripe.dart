import 'package:toast/toast.dart';
import 'package:carbonetx/screens/customer_dashboard/account_balance.dart';

import 'package:carbonetx/utilities/firebase/user_data.dart';
import 'package:dio/dio.dart';

class StripeServices {
  // API Keys

  static const pub_key = 'pk_test_WLmHAmiHtLPQLG3cqPlGAJl300Oig3PRep';
  static const secret_key = 'sk_test_ckiE86rh5l3FCYc7Byk4y1m500PwNiq3Yx';

  // Stripe API URL's

  static const paymentMethodUrl = "https://api.stripe.com/v1/payment_methods";
  static const customersUrl = "https://api.stripe.com/v1/customers/";
  static const chargeUrl = "https://api.stripe.com/v1/charges";

  Map<String, String> headers = {
    'Authorization': "Bearer  $secret_key",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<String> createStripeCustomer(
      {String email, String name, String description}) async {
    Map<String, String> body = {
      'email': email,
      'name': name,
      'description': description,
    };

    dynamic stripeId = Null;
    try {
      Dio dio = Dio();
      stripeId = await dio
          .post(customersUrl,
              data: body,
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        stripeId = response.data["id"];
        print(response.data);
        UserData.stripeID = stripeId;
        print(stripeId);
        UserData.addStripeID(stripeId);
      });
    } catch (err) {
      print('Error adding Stripe Customer: ${err.toString()}');
    }
    return stripeId;
  }

  Future<void> addCard(
      {int cardNumber,
      int month,
      int year,
      int cvc,
      String stripeId,
      String userId,
      String cardHolderName,
      String email}) async {
    Map body = {
      "type": "card",
      "card[number]": cardNumber,
      "card[exp_month]": month,
      "card[exp_year]": year,
      "card[cvc]": cvc,
      "billing_details[name]": cardHolderName,
      "billing_details[email]": email
    };
    dynamic stripeResponse;
    try {
      print('Successfully added payment method id $paymentMethodUrl');
      Dio dio = Dio();
      await dio
          .post(paymentMethodUrl,
              data: body,
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        print(response.data);
        stripeResponse = response;
        String paymentId = response.data['id'];
        Map stripeCustomer = {"customer": UserData.stripeID};
        try {
          dio
              .post('$paymentMethodUrl/$paymentId/attach',
                  data: stripeCustomer,
                  options: Options(
                      contentType: Headers.formUrlEncodedContentType,
                      headers: headers))
              .then((response) {
            print(response.data);
            print('Attached successfully');
          });
        } on DioError catch (e) {
          print(
              'Error attaching card to customer: ${e.response.data['error']['message']}');
        }
      });
    } on DioError catch (e) {
      print(stripeResponse);
      print('Error adding card: ${e.toString()}');
      print(e.response.data);
      print(e.response.data['error']['message']);
      /*  print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      print(e.message);*/

    }
  }
}
