import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Services/ServerRequests.dart';
import './HomePage.dart';
import '../Variables.dart';
import '../WidgetResizing.dart';
import '../Services/Shop.dart';

class ShopProfile extends StatefulWidget {
  @override
  _ShopProfileState createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  String email;
  String password;
  bool eText = true, pText = true;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: 290 / 3.6 * boxSizeH,
            margin: EdgeInsets.only(
              top: 27 / 6.4 * boxSizeV,
              left: 35 / 3.6 * boxSizeH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Shop Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 41,
                    ),
                  ),
                ),
                Container(
                  width: 290 / 3.6 * boxSizeH,
                  margin: EdgeInsets.only(
                    top: 32 / 6.4 * boxSizeV,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 4),
                      labelText: 'Name',
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 290 / 3.6 * boxSizeH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90.5 / 3.6 * boxSizeH,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Shop No.',
                          ),
                        ),
                      ),
                      Container(
                        width: 158.5 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Category',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 4),
                    labelText: 'Address',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 4),
                    labelText: 'Contact No.',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 290 / 3.6 * boxSizeH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90.5 / 3.6 * boxSizeH,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Capacity',
                          ),
                        ),
                      ),
                      Container(
                        width: 158.5 / 3.6 * boxSizeH,
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 4),
                            labelText: 'Timing',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => WillPopScope(
                        onWillPop: () =>
                            Future.delayed(Duration(), () => false),
                        child: Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    );
                    //GET ALL SHOPS
                    // final List<dynamic> list =
                    //     await Provider.of<ServerRequests>(context,
                    //             listen: false)
                    //         .getShops(store.getString('token'));
                    // list.forEach((element) {
                    //   Shop.fromjson(element);
                    //   shops.add(Shop.fromjson(element));
                    // });
                    // print(shops.length);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50, left: 95 / 3.6 * boxSizeH),
                    child: Row(
                      children: [
                        Text(
                          'View Shops',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
