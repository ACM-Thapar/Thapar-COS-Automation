import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/Modals/Order.dart';
import 'package:user/Screens/Cart.dart';
import 'package:user/Screens/SettingsPage.dart';
import 'package:user/Services/ServerRequests.dart';

import '../Modals/User.dart';
import '../Variables.dart';
import '../WidgetResizing.dart';
import '../Modals/Shop.dart';
import '../ErrorBox.dart';
import 'ShopPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Shop>> _streamController;
  StreamController<int>
      _categoryController; //0:All,1:Eateries,2:Stationary,3:departmental
  TextEditingController _controller;
  String _search = '';
  List<Shop> _categoryList = [];
  final FocusNode _focusNode = FocusNode();

  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _streamController = StreamController.broadcast();
    _categoryController = StreamController.broadcast();
    _controller = TextEditingController(text: '');
    _categoryList = shops;
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Reloading');
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
    final double width = MediaQuery.of(context).size.width;
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
            width: 0.8 * width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  // decoration: BoxDecoration(border: Border.all()),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      Text(
                        Provider.of<AppUser>(context, listen: false).name,
                        style: josefinSansSB28,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          List<dynamic> json;
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
                          try {
                            json = await Provider.of<ServerRequests>(context,
                                    listen: false)
                                .getAllOrders();
                          } on PlatformException catch (e) {
                            errorBox(context, e);
                            // Navigator.pop(context);
                          }
                          if (json != null) {
                            json.forEach((order) {
                              List<dynamic> items = order['items'];
                              Order.fromJson(
                                      items, order['shop']['_id'].toString())
                                  .printOrder();
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(25),
                                decoration: const BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: SvgPicture.asset('assets/bag.svg'),
                              ),
                              Text(
                                'Orders',
                                style: josefinSansSB18.copyWith(
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Works");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(25),
                                decoration: const BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: SvgPicture.asset('assets/heart.svg'),
                              ),
                              Text(
                                'Favourites',
                                style: josefinSansSB18.copyWith(
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(25),
                                decoration: const BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: SvgPicture.asset('assets/settings.svg'),
                              ),
                              Text(
                                'Settings',
                                style: josefinSansSB18.copyWith(
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                primary: true,
                floating: false,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // FocusScope.of(context).requestFocus(_focusNode);
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            _scaffoldKey.currentState.openDrawer();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              // border: Border.all(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: SvgPicture.asset(
                              'assets/menu.svg',
                              height: 10,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyCart(),
                              ),
                            );
                          },
                          child: CartIcon(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Heading Text
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 30,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'Shops\n',
                      style: robotoB37.copyWith(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Let\'s find out what you need',
                          style: josefinSansSB14.copyWith(
                              color: Colors.black, height: 1.4),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //Search Field
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
                  child: TextField(
                    controller: _controller,
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
                      if (_search != _controller.text) {
                        _search = _controller.text;

                        List<Shop> _searchResults = [];
                        if (value != null && value != '') {
                          _categoryList.forEach((shop) {
                            if (shop.name
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              _searchResults.add(shop);
                            }
                          });
                        } else
                          _searchResults = _categoryList;
                        _streamController.add(_searchResults);
                      }
                    },
                  ),
                ),
              ),
              //Category Selection Horizontal List
              SliverAppBar(
                toolbarHeight: 105 / 6.4 * boxSizeV,
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                pinned: true,
                title: Container(
                  height: 85 / 6.4 * boxSizeV,
                  width: 320 / 3.6 * boxSizeH,
                  margin: EdgeInsets.only(
                    top: 20 / 6.4 * boxSizeV,
                    left: 20 / 3.6 * boxSizeH,
                    bottom: 20 / 6.4 * boxSizeV,
                  ),
                  child: StreamBuilder<int>(
                    stream: _categoryController.stream,
                    initialData: 0,
                    builder: (context, category) {
                      // print("BUILD ITEMS AGAIN");
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (category.data != 0) {
                                _categoryList = [];
                                _categoryList = shops;
                                _categoryController.add(0);
                                _streamController.add(_categoryList);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 9 / 3.6 * boxSizeH,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 23 / 6.4 * boxSizeV),
                              height: 86 / 6.4 * boxSizeV,
                              width: 86 / 3.6 * boxSizeH,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: category.data == 0
                                        ? Color(0xffFFCB00)
                                        : Color(0xffCBCBCB)),
                                color: Color(0xfff8f8f8),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('All',
                                      style: josefinSansSB25.copyWith(
                                          color: category.data == 0
                                              ? Color(0xffffcb00)
                                              : Color(0x8f707070))),
                                  Icon(
                                    Icons.trip_origin,
                                    color: Color(0xffFFCB00),
                                    size: 12,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (category.data != 1) {
                                _categoryList = [];
                                shops.forEach((shop) {
                                  if (shop.category == 'eateries')
                                    _categoryList.add(shop);
                                });
                                _categoryController.add(1);
                                _streamController.add(_categoryList);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 9 / 3.6 * boxSizeH,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 13 / 6.4 * boxSizeV),
                              height: 86 / 6.4 * boxSizeV,
                              width: 86 / 3.6 * boxSizeH,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: category.data == 1
                                        ? Color(0xffFFCB00)
                                        : Color(0xffCBCBCB)),
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
                                        color: category.data == 1
                                            ? Color(0xffffcb00)
                                            : Color(0x8f707070)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (category.data != 2) {
                                _categoryList = [];
                                shops.forEach((shop) {
                                  if (shop.category == 'stationary')
                                    _categoryList.add(shop);
                                });
                                _categoryController.add(2);
                                _streamController.add(_categoryList);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 9 / 3.6 * boxSizeH,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 13 / 6.4 * boxSizeV),
                              height: 86 / 6.4 * boxSizeV,
                              width: 86 / 3.6 * boxSizeH,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: category.data == 2
                                        ? Color(0xffFFCB00)
                                        : Color(0xffCBCBCB)),
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
                                        color: category.data == 2
                                            ? Color(0xffffcb00)
                                            : Color(0x8f707070)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (category.data != 3) {
                                _categoryList = [];
                                shops.forEach((shop) {
                                  if (shop.category == 'departmental')
                                    _categoryList.add(shop);
                                });
                                _categoryController.add(3);
                                _streamController.add(_categoryList);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13 / 6.4 * boxSizeV),
                              height: 86 / 6.4 * boxSizeV,
                              width: 86 / 3.6 * boxSizeH,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: category.data == 3
                                        ? Color(0xffFFCB00)
                                        : Color(0xffCBCBCB)),
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
                                    'Departmental',
                                    style: josefinSansSB14.copyWith(
                                        color: category.data == 3
                                            ? Color(0xffffcb00)
                                            : Color(0x8f707070)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              // All Shops Vertical List
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(bottom: 2 * boxSizeV),
                  child: StreamBuilder<List<Shop>>(
                    initialData: shops,
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => Center(
                          child: GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                    value: snapshot.data[i],
                                    child: ShopPage(
                                      serverRequests:
                                          Provider.of<ServerRequests>(context,
                                              listen: false),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ChangeNotifierProvider.value(
                                value: snapshot.data[i], child: ShopItem()),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("BUILD CART ICON");
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        // color: Colors.black,
        // border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Stack(
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.black,
            size: 30,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Provider.of<Order>(context, listen: true).order.length != 0
                ? Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Provider.of<Order>(context, listen: true)
                            .order
                            .length
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
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
                    image: Provider.of<Shop>(context, listen: false).pic != null
                        ? NetworkImage(
                            Provider.of<Shop>(context, listen: false).pic,
                          )
                        : AssetImage(img[Random().nextInt(3)]),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(
                top: 14 / 6.4 * boxSizeV,
              ),
              height: 85 / 6.4 * boxSizeV,
              width: 260 / 3.6 * boxSizeH,
              child: GestureDetector(
                onTap: () async {
                  bool success;
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => WillPopScope(
                      onWillPop: () => Future.delayed(Duration(), () => false),
                      child: Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  );
                  if (Provider.of<Shop>(context, listen: false).fav) {
                    try {
                      success = await Provider.of<ServerRequests>(context,
                              listen: false)
                          .deleteFavouriteShop(
                              Provider.of<Shop>(context, listen: false).id);
                    } on PlatformException catch (e) {
                      await errorBox(context, e);
                      success = false;
                    }
                    Navigator.pop(context);
                    if (success) {
                      Provider.of<Shop>(context, listen: false)
                          .changeFav(false);
                    }
                  } else {
                    try {
                      success = await Provider.of<ServerRequests>(context,
                              listen: false)
                          .favouriteShop(
                              Provider.of<Shop>(context, listen: false).id);
                    } on PlatformException catch (e) {
                      await errorBox(context, e);
                      success = false;
                    }
                    Navigator.pop(context);
                    if (success) {
                      Provider.of<Shop>(context, listen: false).changeFav(true);
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: 6 / 6.4 * boxSizeV,
                    right: 10 / 3.6 * boxSizeH,
                  ),
                  alignment: Alignment.topRight,
                  child: Icon(
                    Provider.of<Shop>(context, listen: true).fav
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Color(0xffFFCB00),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8 / 6.4 * boxSizeV,
            ),
            Text(
              Provider.of<Shop>(context, listen: false).name,
              style: robotoB18.copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 5 / 6.4 * boxSizeV,
            ),
            Text(
              Provider.of<Shop>(context, listen: false).address,
              style: josefinSansSB14.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> img = ['assets/1.jpeg', 'assets/2.jpeg', 'assets/3.jpeg'];
