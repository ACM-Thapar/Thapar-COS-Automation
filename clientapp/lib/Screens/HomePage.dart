import 'package:clientapp/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Services/User.dart';
import '../Variables.dart';
import '../WidgetResizing.dart';
import './Inventory.dart';
import '../Services/Shop.dart';
import './Tracking.dart';
import '../ErrorBox.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './UserType.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email;
  String password;
  bool eText = true, pText = true;
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
    return WillPopScope(
      //EXIT APP ERROR
      // print('EXIT APP');
      onWillPop: () async {
        bool val = await errorBox(
          context,
          PlatformException(
            code: 'Exit',
            message: 'Are you sure you want to exit?',
            details: 'double',
          ),
        );
        print(val);
        if (val) {
          // exit(0);
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Container(
            width: 250 / 3.6 * boxSizeH,
            // padding: EdgeInsets.symmetric(horizontal: 12 / 3.6 * boxSizeH),
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  // decoration: BoxDecoration(border: Border.all()),
                  // height: 160 / 6.4 * boxSizeV,
                  margin: EdgeInsets.only(bottom: 14 / 6.4 * boxSizeV),
                  padding: EdgeInsets.symmetric(
                      horizontal: 32 / 3.6 * boxSizeH,
                      vertical: 28 / 6.4 * boxSizeV),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 14 / 6.4 * boxSizeV),
                        height: 58 / 6.4 * boxSizeV,
                        width: 58 / 3.6 * boxSizeH,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      Text(
                        Provider.of<AppUser>(context, listen: false).name,
                        style: josefinSansSB28,
                      )
                    ],
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(border: Border.all()),
                  margin: EdgeInsets.symmetric(
                      horizontal: 20 / 3.6 * boxSizeH,
                      vertical: 8 / 6.4 * boxSizeV),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20 / 3.6 * boxSizeH),
                        height: 66 / 6.4 * boxSizeV,
                        width: 66 / 3.6 * boxSizeH,
                        padding: EdgeInsets.symmetric(
                            horizontal: 22 / 3.6 * boxSizeH,
                            vertical: 22 / 6.4 * boxSizeV),
                        decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(20)),
                        child: SvgPicture.asset('assets/bag.svg'),
                      ),
                      Text(
                        'Orders',
                        style: josefinSansSB18.copyWith(color: Colors.black),
                      )
                    ],
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(border: Border.all()),
                  margin: EdgeInsets.symmetric(
                      horizontal: 20 / 3.6 * boxSizeH,
                      vertical: 8 / 6.4 * boxSizeV),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20 / 3.6 * boxSizeH),
                        height: 66 / 6.4 * boxSizeV,
                        width: 66 / 3.6 * boxSizeH,
                        padding: EdgeInsets.symmetric(
                            horizontal: 22 / 3.6 * boxSizeH,
                            vertical: 22 / 6.4 * boxSizeV),
                        decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(20)),
                        child: SvgPicture.asset('assets/heart.svg'),
                      ),
                      Text(
                        'Favourites',
                        style: josefinSansSB18.copyWith(color: Colors.black),
                      )
                    ],
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(border: Border.all()),
                  margin: EdgeInsets.symmetric(
                      horizontal: 20 / 3.6 * boxSizeH,
                      vertical: 8 / 6.4 * boxSizeV),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20 / 3.6 * boxSizeH),
                        height: 66 / 6.4 * boxSizeV,
                        width: 66 / 3.6 * boxSizeH,
                        padding: EdgeInsets.symmetric(
                            horizontal: 22 / 3.6 * boxSizeH,
                            vertical: 22 / 6.4 * boxSizeV),
                        decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(20)),
                        child: SvgPicture.asset('assets/settings.svg'),
                      ),
                      Text(
                        'Settings',
                        style: josefinSansSB18.copyWith(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Container(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: 100 * boxSizeV,
                    width: 100 * boxSizeH,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 19 / 6.4 * boxSizeV,
                            left: 36 / 3.6 * boxSizeH,
                            right: 36 / 3.6 * boxSizeH,
                          ),
                          height: 43 / 6.4 * boxSizeV,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState.openDrawer();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8 / 3.6 * boxSizeH,
                                      vertical: 13 / 6.4 * boxSizeV),
                                  width: 43 / 3.6 * boxSizeH,
                                  decoration: BoxDecoration(
                                    // color: Colors.black,
                                    // border: Border.all(),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SvgPicture.asset('assets/menu.svg'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool val = await errorBox(
                                    context,
                                    PlatformException(
                                      code: 'Logout',
                                      message:
                                          'Are you sure you want to logout?',
                                      details: 'double',
                                    ),
                                  );
                                  print(val);
                                  if (val) {
                                    // exit(0);
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .logOut();
                                    await store.clear();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserType(),
                                        ),
                                        (route) => false);
                                  }
                                  return false;
                                },
                                child: Container(
                                  width: 43 / 3.6 * boxSizeH,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 16 / 6.4 * boxSizeV,
                            left: 36 / 3.6 * boxSizeH,
                          ),
                          child: Text(
                            'Shops',
                            style: robotoB37.copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 5 / 6.4 * boxSizeV,
                            left: 36 / 3.6 * boxSizeH,
                          ),
                          child: Text(
                            'Let\'s find out what you need',
                            style:
                                josefinSansSB14.copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          // height: 58 / 6.4 * boxSizeV,
                          width: 291 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 10 / 6.4 * boxSizeV,
                            left: 35 / 3.6 * boxSizeH,
                          ),
                          // decoration: BoxDecoration(
                          //   // borderRadius: BorderRadius.circular(10),
                          //   border: Border.all(color: Color(0xffCBCBCB)),
                          //   // color: Color(0xffF8F8F8),
                          // ),
                          child: TextField(
                            style: openSansR14.copyWith(color: Colors.black),
                            cursorColor: Color(0xffFFCB00),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              fillColor: Color(0x80F8F8F8),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xffCBCBCB),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffFFCB00),
                                ),
                              ),
                              hintText: 'Search a Category',
                              hintStyle: openSansL14.copyWith(
                                color: Color(0xAB707070),
                              ),
                            ),
                            onChanged: (value) {
                              //TODO :SEARCH
                            },
                          ),
                        ),
                        Container(
                          height: 85 / 6.4 * boxSizeV,
                          width: 320 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            top: 20 / 6.4 * boxSizeV,
                            left: 20 / 3.6 * boxSizeH,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 9 / 3.6 * boxSizeH,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 23 / 6.4 * boxSizeV),
                                    height: 86 / 6.4 * boxSizeV,
                                    width: 86 / 3.6 * boxSizeH,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border:
                                          Border.all(color: Color(0xffCBCBCB)),
                                      color: Color(0xfff8f8f8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('All',
                                            style: josefinSansSB25.copyWith(
                                                color: Colors.black)),
                                        Icon(
                                          Icons.trip_origin,
                                          color: Color(0xffFFCB00),
                                          size: 12,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 9 / 3.6 * boxSizeH,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 13 / 6.4 * boxSizeV),
                                    height: 86 / 6.4 * boxSizeV,
                                    width: 86 / 3.6 * boxSizeH,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border:
                                          Border.all(color: Color(0xffCBCBCB)),
                                      color: Color(0xfff8f8f8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/eatries.svg',
                                          width: 48 / 3.6 * boxSizeH,
                                        ),
                                        Text(
                                          'Eatries',
                                          style: josefinSansSB14.copyWith(
                                              color: Color(0x8f707070)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 9 / 3.6 * boxSizeH,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 13 / 6.4 * boxSizeV),
                                    height: 86 / 6.4 * boxSizeV,
                                    width: 86 / 3.6 * boxSizeH,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border:
                                          Border.all(color: Color(0xffCBCBCB)),
                                      color: Color(0xfff8f8f8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/stationary.svg',
                                          width: 48 / 3.6 * boxSizeH,
                                        ),
                                        Text(
                                          'Stationery',
                                          style: josefinSansSB14.copyWith(
                                              color: Color(0x8f707070)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 13 / 6.4 * boxSizeV),
                                    margin: EdgeInsets.only(
                                      right: 9 / 3.6 * boxSizeH,
                                    ),
                                    height: 86 / 6.4 * boxSizeV,
                                    width: 86 / 3.6 * boxSizeH,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border:
                                          Border.all(color: Color(0xffCBCBCB)),
                                      color: Color(0xfff8f8f8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/laundary.svg',
                                          width: 48 / 3.6 * boxSizeH,
                                        ),
                                        Text(
                                          'Laundry',
                                          style: josefinSansSB14.copyWith(
                                              color: Color(0x8f707070)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20 / 6.4 * boxSizeV,
                            left: 33.5 / 3.6 * boxSizeH,
                          ),
                          height: 316 / 6.4 * boxSizeV,
                          width: 291 / 3.6 * boxSizeH,
                          child: ListView.builder(
                            itemCount: shops.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  // //TODO: REMOVE THIS SIGNOUT
                                  // await store.remove('token');
                                  // await FirebaseAuth.instance.signOut();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Inventory(),
                                    ),
                                  );
                                },
                                child: ShopItem(
                                  index: index,
                                  shop: shops[index],
                                ),
                              );
                            },
                          ),
                        )
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
                      await Future.delayed(
                        Duration(seconds: 20),
                        () {
                          print('done');
                          Navigator.of(context).pop();
                        },
                      );
                      // print('tap');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 559 / 6.4 * boxSizeV,
                          left: 148 / 3.6 * boxSizeH),
                      height: 64 / 6.4 * boxSizeV,
                      width: 64 / 3.6 * boxSizeH,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                          ),
                        ],
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Icon(
                        Icons.swap_vert,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
  final Shop shop;
  final int index;
  ShopItem({this.shop, this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: Color(0xffCBCBCB)),
      ),
      margin: EdgeInsets.only(
        bottom: 8 / 6.4 * boxSizeV,
      ),
      height: 160 / 6.4 * boxSizeV,
      width: 291 / 3.6 * boxSizeH,
      child: Container(
        margin: EdgeInsets.only(
          left: 14 / 6.4 * boxSizeV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(img[index % 3]), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(
                top: 14 / 6.4 * boxSizeV,
              ),
              height: 85 / 6.4 * boxSizeV,
              width: 260 / 3.6 * boxSizeH,
              child: Container(
                margin: EdgeInsets.only(
                  top: 6 / 6.4 * boxSizeV,
                  right: 10 / 3.6 * boxSizeH,
                ),
                alignment: Alignment.topRight,
                child: Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Color(0xffFFCB00),
                ),
              ),
            ),
            SizedBox(
              height: 8 / 6.4 * boxSizeV,
            ),
            Text(
              shop.name,
              style: robotoBK18.copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 5 / 6.4 * boxSizeV,
            ),
            Text(
              shop.address,
              style: josefinSansSB14.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> img = ['assets/1.jpeg', 'assets/2.jpeg', 'assets/3.jpeg'];
