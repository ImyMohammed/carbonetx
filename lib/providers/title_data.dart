import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Provider.of<TitleData>(context, listen: true).pageTitle,
          style: kPageTitle),
    );
  }
}

class TitleData extends ChangeNotifier {
  String pageTitle = "Dashboard";
  int currentPage = 0;

  void changeTitle(String newTitle) {
    pageTitle = newTitle;
    notifyListeners();
    print(pageTitle);
  }

  void changePage(int pageNumber) {
    currentPage = pageNumber;
    notifyListeners();
    print(currentPage);
  }
}
