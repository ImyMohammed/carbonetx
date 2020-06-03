import 'package:carbonetx/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerDashboardInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Text(
        Provider.of<CustomerDashboardInfoData>(context, listen: true)
            .imageTitle,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
          fontSize: width * 0.06,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 7.0,
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 7.0,
              color: Colors.black,
            ),
          ],
        ));
  }
}

class CustomerDashboardInfoData extends ChangeNotifier {
  String imageTitle = dashboardTitles[0];

  void changeTitle(int index) {
    imageTitle = dashboardTitles[index];
    notifyListeners();
    print(imageTitle);
  }
}

class DashboardSubtitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Text(
        Provider.of<DashboardSubtitleData>(context, listen: true).imageInfo,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
          fontSize: height * 0.017,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 5.0,
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 5.0,
              color: Colors.black,
            ),
          ],
        ));
  }
}

class DashboardSubtitleData extends ChangeNotifier {
  String imageInfo = dashboardSubtitles[0];

  void changeInfo(int index) {
    imageInfo = dashboardSubtitles[index];
    notifyListeners();
    print(imageInfo);
  }
}
