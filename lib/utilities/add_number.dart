import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_profile.dart';

class AddNumber {
  static String mobileNumber = 'Enter your Mob No.';

  createAddNumberAlert(BuildContext context, TextEditingController controller) {
    String mobileNumber;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF3A3A39),
            title: Text(
              'Add your Mobile No.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
            ),
            content: TextField(
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: controller,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                mobileNumber = value;
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
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: "Enter your Mob No.",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0362)),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: MaterialButton(
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
                    print('reset');
                    Navigator.pop(context);
                    print(mobileNumber);
                  },
                ),
              )
            ],
          );
        });
  }
}
