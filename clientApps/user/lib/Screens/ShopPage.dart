import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user/Modals/Order.dart';
import 'package:user/Modals/Review.dart';
import 'package:user/Modals/Shop.dart';
import 'package:user/Modals/User.dart';
import 'package:user/Screens/PostReview.dart';
import 'package:user/Services/ServerRequests.dart';

import '../ErrorBox.dart';
import '../Variables.dart';
import 'Cart.dart';
import 'HomePage.dart';

class ShopPage extends StatefulWidget {
  final ServerRequests serverRequests;
  ShopPage({this.serverRequests});
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Map<String, String>> categories; //Category Name and icon
  Review userReview;
  String shopId;
  final List<String> icons = [
    'assets/allCatIcon.svg',
    'assets/burger.svg',
    'assets/hotDrinks.svg',
    'assets/drinks.svg',
    'assets/fries.svg',
  ];

  Future<bool> getShopDetails() async {
    print("GET Shop Menu");
    bool success = false;
    List<dynamic> json1;
    //Get menu
    try {
      json1 = await widget.serverRequests
          .getShop(Provider.of<Shop>(context, listen: false).id);
      success = true;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
    if (success) {
      //set Menu in provider
      Provider.of<Shop>(context, listen: false).setMenu(json1);
      categories = [];
      //Set Categories and Icons
      Provider.of<Shop>(context, listen: false)
          .menu
          .items
          .forEach((category, item) {
        categories.add({
          'name': category.toLowerCase(),
          'icon':
              icons[category.toLowerCase() == 'all' ? 0 : Random().nextInt(4)]
        });
      });
    }

    return success;
  }

  Future<bool> getReviews() async {
    print("GET Reviews");
    bool success = false;
    List<dynamic> json2;
    //Get reviews
    try {
      json2 = await widget.serverRequests
          .getShopReviews(Provider.of<Shop>(context, listen: false).id);
      success = true;
    } on PlatformException catch (e) {
      success = false;
      throw Exception(e.message);
    }
    if (success) {
      //set reviews in provider
      Provider.of<Shop>(context, listen: false).setReviews(json2);
      for (Review prevRev
          in Provider.of<Shop>(context, listen: false).reviews) {
        if (prevRev.name == Provider.of<AppUser>(context, listen: false).name)
          userReview = prevRev;
      }
    }
    return success;
  }

  ValueNotifier<int> value;
  void fun() {
    // print("STATUS UPDATE");
    value.value =
        Provider.of<Order>(context, listen: false).order.length == 0 ? 0 : 1;
  }

  @override
  void initState() {
    value = ValueNotifier(
        Provider.of<Order>(context, listen: false).order.length == 0 ? 0 : 1);
    Provider.of<Order>(context, listen: false).addListener(fun);
    shopId = Provider.of<Shop>(context, listen: false).id;
    super.initState();
  }

  @override
  void deactivate() {
    // print("DEACTIVATE");
    Provider.of<Order>(context, listen: false).removeListener(fun);
    super.deactivate();
  }

  @override
  void dispose() {
    // print("DISPOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyCart(),
                ),
              );
            },
            child: ViewCartSheet()),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              shadowColor: Colors.transparent,
              expandedHeight: 240 / 6.4 * boxSizeV,
              collapsedHeight: 135 / 6.4 * boxSizeV,
              floating: false,
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Container(
                // decoration: BoxDecoration(
                //   border: Border.all(),
                // ),
                margin: EdgeInsets.only(
                  left: 20 / 3.6 * boxSizeH,
                  right: 20 / 3.6 * boxSizeH,
                ),
                height: 35 / 6.4 * boxSizeV,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 42 / 3.6 * boxSizeH,
                        decoration: BoxDecoration(
                          color: Color(0x9CFFFFFF),
                          // border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(FontAwesomeIcons.arrowLeft,
                            color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("WORKING");
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 38 / 3.6 * boxSizeH,
                          decoration: BoxDecoration(
                              // border: Border.all(),
                              color: Color(0x9CFFFFFF),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text("XP",
                              style: josefinSansB20.copyWith(
                                  color: Colors.black))),
                    ),
                    FavIcon(),
                  ],
                ),
              ),
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: Provider.of<Shop>(context, listen: false).pic != null
                        ? Image.network(
                            Provider.of<Shop>(context, listen: false).pic,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            img[Random().nextInt(3)],
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(25))),
                      padding: EdgeInsets.symmetric(
                          horizontal: 38 / 3.6 * boxSizeH,
                          vertical: 15 / 6.4 * boxSizeV),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  Provider.of<Shop>(context, listen: false)
                                      .name,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      robotoB37.copyWith(color: Colors.black),
                                ),
                              ),
                              Provider.of<Shop>(context, listen: false)
                                          .rating !=
                                      0
                                  ? RichText(
                                      text: TextSpan(
                                          text: Provider.of<Shop>(context,
                                                  listen: false)
                                              .rating
                                              .toString(),
                                          style: openSansR14.copyWith(
                                              color: Colors.black),
                                          children: [
                                            WidgetSpan(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 2 * boxSizeH),
                                                    child: Icon(
                                                        FontAwesomeIcons.star)))
                                          ]),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          Text(
                            Provider.of<Shop>(context, listen: false)
                                .category
                                .replaceRange(
                                    0,
                                    1,
                                    Provider.of<Shop>(context, listen: false)
                                        .category[0]
                                        .toUpperCase()),
                            style: josefinSansB14,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 28 / 3.6 * boxSizeH,
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Address and Details Box
                    Container(
                      padding: EdgeInsets.symmetric(vertical: boxSizeV),
                      margin:
                          EdgeInsets.symmetric(vertical: 21 / 6.4 * boxSizeV),
                      decoration: BoxDecoration(
                          color: Color(0xffF0F0F0),
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 27 / 3.6 * boxSizeH,
                                vertical: 1 * boxSizeV),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 4 * boxSizeH),
                                      child: Icon(
                                        Icons.location_on,
                                        color: Color(0xffFFCB00),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: Provider.of<Shop>(context,
                                              listen: false)
                                          .address,
                                      style: josefinSansR14.copyWith(
                                          color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 27 / 3.6 * boxSizeH,
                                vertical: 1 * boxSizeV),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 4 * boxSizeH),
                                      child: Icon(
                                        Icons.call,
                                        color: Color(0xffFFCB00),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: Provider.of<Shop>(context,
                                              listen: false)
                                          .phone,
                                      style: josefinSansR14.copyWith(
                                          color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 27 / 3.6 * boxSizeH,
                                vertical: 1 * boxSizeV),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 4 * boxSizeH),
                                          child: Icon(
                                            FontAwesomeIcons.clock,
                                            color: Color(0xffFFCB00),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text: Provider.of<Shop>(context,
                                                      listen: false)
                                                  .timingsT ??
                                              "Timings",
                                          style: josefinSansR14.copyWith(
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 4 * boxSizeH),
                                          child: Icon(
                                            FontAwesomeIcons.clock,
                                            color: Color(0xffFFCB00),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text: Provider.of<Shop>(context,
                                                      listen: false)
                                                  .timingsT ??
                                              "Timings",
                                          style: josefinSansR14.copyWith(
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 27 / 3.6 * boxSizeH,
                                vertical: 1 * boxSizeV),
                            alignment: Alignment.center,
                            child: RichText(
                                text: TextSpan(
                                    text:
                                        'STATUS ${Provider.of<Shop>(context, listen: false).status}',
                                    style: josefinSansR14.copyWith(
                                        color: Colors.black))),
                          )
                        ],
                      ),
                    ),
                    //Categories and Reviews
                    FutureBuilder<void>(
                      future: getShopDetails(),
                      builder: (context, snapshot) {
                        // Checking if future is resolved or not
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If we got an error
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Something went wrong',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Retry',
                                      style: robotoB18.copyWith(
                                        color: Color(0xffFFCB00),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            // if we got our data
                          } else if (snapshot.hasData) {
                            // Extracting data from snapshot object
                            return Container(
                              margin:
                                  EdgeInsets.only(bottom: 4 / 6.4 * boxSizeV),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category',
                                    style: josefinSansB20,
                                  ),
                                  Container(
                                    height: 91 / 6.4 * boxSizeV,
                                    margin: EdgeInsets.only(
                                      top: 15 / 6.4 * boxSizeV,
                                      bottom: 30 / 6.4 * boxSizeV,
                                    ),
                                    child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          for (int i = 0;
                                              i < categories.length;
                                              i++)
                                            CategoryWidget(
                                                index: i,
                                                categories: categories)
                                        ]),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                        // Displaying LoadingSpinner to indicate waiting state
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    Text(
                      'Customer Reviews',
                      style: josefinSansB20,
                    ),
                    FutureBuilder<void>(
                      future: getReviews(),
                      builder: (context, snapshot) {
                        // Checking if future is resolved or not
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If we got an error
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Something went wrong',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Retry',
                                      style: robotoB18.copyWith(
                                        color: Color(0xffFFCB00),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            // if we got our data
                          } else if (snapshot.hasData) {
                            return Container(
                              margin:
                                  EdgeInsets.only(bottom: 4 / 6.4 * boxSizeV),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Provider.of<Shop>(context, listen: false)
                                              .rating !=
                                          0
                                      ? Container(
                                          margin: EdgeInsets.only(
                                            top: 10 / 6.4 * boxSizeV,
                                            bottom: 15 / 6.4 * boxSizeV,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                Provider.of<Shop>(context,
                                                        listen: false)
                                                    .rating
                                                    .toString(),
                                                style: josefinSansSB45.copyWith(
                                                    color: Colors.black),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: RatingBarIndicator(
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star_rate_rounded,
                                                    color: Color(0xffFFCB00),
                                                  ),
                                                  rating: Provider.of<Shop>(
                                                          context,
                                                          listen: false)
                                                      .rating,
                                                  unratedColor:
                                                      Color(0xffF0F0F0),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: 10,
                                        ),
                                  Provider.of<Shop>(context, listen: false)
                                              .rating !=
                                          0
                                      ? ListView.builder(
                                          primary: false,
                                          itemCount: Provider.of<Shop>(context,
                                                  listen: false)
                                              .reviews
                                              .length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 2 * boxSizeV),
                                              // decoration:
                                              //     BoxDecoration(border: Border.all()),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: boxSizeV),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 2 *
                                                                      boxSizeH),
                                                          height: 42 /
                                                              6.4 *
                                                              boxSizeV,
                                                          width: 42 /
                                                              3.6 *
                                                              boxSizeH,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .black),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                Provider.of<Shop>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .reviews[
                                                                        index]
                                                                    .name,
                                                                style:
                                                                    josefinSansB14,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        RatingBarIndicator(
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          itemCount:
                                                                              5,
                                                                          itemBuilder: (context, index) =>
                                                                              Icon(
                                                                            Icons.star_rate_rounded,
                                                                            color:
                                                                                Color(0xffFFCB00),
                                                                          ),
                                                                          itemSize:
                                                                              15,
                                                                          rating: Provider.of<Shop>(context, listen: false)
                                                                              .reviews[index]
                                                                              .rating,
                                                                          unratedColor:
                                                                              Color(0xffF0F0F0),
                                                                        ),
                                                                        Text(
                                                                          '  ${Provider.of<Shop>(context, listen: false).reviews[index].rating}',
                                                                          style:
                                                                              openSansSB9,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '1 day ago',
                                                                    style: openSansR10
                                                                        .copyWith(
                                                                      color: Color(
                                                                          0xff707070),
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    Provider.of<Shop>(context,
                                                            listen: false)
                                                        .reviews[index]
                                                        .review,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: openSansR10,
                                                  )
                                                ],
                                              ),
                                            );
                                          })
                                      : SizedBox(),
                                  ValueListenableBuilder<int>(
                                    valueListenable: value,
                                    builder: (_, value, child) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            bottom:
                                                value * 60 / 6.4 * boxSizeV),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PostReview(
                                                        shopId: shopId,
                                                        prevReview: userReview),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 18 / 6.4 * boxSizeV),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5 / 3.6 * boxSizeH),
                                            child: Text(
                                              userReview == null
                                                  ? 'Write a Review'
                                                  : 'Update Review',
                                              style: josefinSansR18.copyWith(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            );
                          }
                        }
                        // Displaying LoadingSpinner to indicate waiting state
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ViewCartSheet extends StatelessWidget {
  Widget build(BuildContext context) {
    return Provider.of<Order>(context, listen: true).order.length == 0
        ? Container(
            height: 0,
          )
        : Container(
            alignment: Alignment.center,
            // decoration: BoxDecoration(border: Border.all()),
            color: Color(0xffFFCB00),
            height: 60 / 6.4 * boxSizeV,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              // textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${Provider.of<Order>(context, listen: true).order.values.reduce((sum, quantity) => sum + quantity)} Item | Rs.${Provider.of<Order>(context, listen: true).total}',
                  style: josefinSansSB18,
                ),
                RichText(
                  text: TextSpan(
                      text: 'View Cart   ',
                      style: josefinSansSB18.copyWith(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 28,
                          ),
                        )
                      ]),
                )
              ],
            ),
          );
  }
}

class FavIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("BUILD FAV");
    return GestureDetector(
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
            success = await Provider.of<ServerRequests>(context, listen: false)
                .deleteFavouriteShop(
                    Provider.of<Shop>(context, listen: false).id);
          } on PlatformException catch (e) {
            await errorBox(context, e);
            success = false;
          }
          Navigator.pop(context);
          if (success) {
            Provider.of<Shop>(context, listen: false).changeFav(false);
          }
        } else {
          try {
            success = await Provider.of<ServerRequests>(context, listen: false)
                .favouriteShop(Provider.of<Shop>(context, listen: false).id);
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
        width: 42 / 3.6 * boxSizeH,
        decoration: BoxDecoration(
            color: Color(0x9CFFFFFF),
            // border: Border.all(),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(
          Provider.of<Shop>(context, listen: true).fav
              ? FontAwesomeIcons.solidHeart
              : FontAwesomeIcons.heart,
          color: Color(0xffFFCB00),
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final int index;
  final List<Map<String, String>> categories;
  CategoryWidget({this.index, this.categories});
  Widget build(BuildContext context) {
    // print("BUILD Horizontal Category Widget");
    final shopNotifier = Provider.of<Shop>(context, listen: false);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            context: context,
            builder: (context) => ChangeNotifierProvider.value(
                  value: shopNotifier,
                  child: BottomSheetWidget(
                    controller: PageController(initialPage: index),
                  ),
                ));
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 9 / 3.6 * boxSizeH,
        ),
        height: 91 / 6.4 * boxSizeV,
        width: 72 / 3.6 * boxSizeH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 72 / 6.4 * boxSizeV,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: 20 / 3.6 * boxSizeH,
                  vertical: 12 / 6.4 * boxSizeV),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xffF0F0F0),
              ),
              child: index != 0
                  ? SvgPicture.asset(
                      categories[index]['icon'],
                      // width: 2 * boxSizeH,
                    )
                  : null,
            ),
            Text(
                categories[index]['name'].replaceRange(
                    0, 1, categories[index]['name'][0].toUpperCase()),
                style: josefinSansSB14.copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  final PageController controller;
  BottomSheetWidget({this.controller});
  @override
  Widget build(BuildContext context) {
    // print("BUILD BOTTOMSHEET WIDGET");
    final List<String> list =
        Provider.of<Shop>(context, listen: false).menu.items.keys.toList();
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(),
        // ),
        height: 350 / 6.4 * boxSizeV,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Container(
              // decoration: BoxDecoration(
              //   border: Border.all(),
              // ),
              padding: EdgeInsets.symmetric(horizontal: 20 / 3.6 * boxSizeH),
              child: PageView.builder(
                controller: controller,
                itemCount:
                    Provider.of<Shop>(context, listen: false).menu.items.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15 / 3.6 * boxSizeH),
                    // decoration: BoxDecoration(
                    //   border: Border.all(),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: boxSizeV),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              index != 0
                                  ? IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.arrow_back_ios_rounded),
                                      onPressed: () {
                                        controller.previousPage(
                                            duration:
                                                Duration(milliseconds: 800),
                                            curve: Curves.easeInOut);
                                      })
                                  : Container(),
                              Text(
                                list[index].replaceRange(
                                    0, 1, list[index][0].toUpperCase()),
                                style: josefinSansB20,
                              ),
                              index ==
                                      Provider.of<Shop>(context, listen: false)
                                              .menu
                                              .items
                                              .length -
                                          1
                                  ? Container()
                                  : IconButton(
                                      padding: EdgeInsets.zero,
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      onPressed: () {
                                        controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 800),
                                            curve: Curves.easeInOut);
                                      })
                            ],
                          ),
                        ),
                        Flexible(
                          child: buildListView(context, list, index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )),
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCart(),
                    ),
                  );
                },
                child: ViewCartSheet())
          ],
        ),
      ),
    );
  }

  ListView buildListView(BuildContext context, List<String> list, int index) {
    // print("BUILD ListViewBuilder $index");
    return ListView.builder(
      itemCount: Provider.of<Shop>(context, listen: false)
          .menu
          .items[list[index]]
          .length,
      itemBuilder: (context, itemindex) => ItemUi(
          listItems:
              Provider.of<Shop>(context, listen: false).menu.items[list[index]],
          index: itemindex),
    );
  }
}

class ItemUi extends StatelessWidget {
  final int index;
  final List<Item> listItems;
  ItemUi({this.index, this.listItems});
  @override
  Widget build(BuildContext context) {
    // print("BUILD ITEM ${listItems[index].name}");
    return Container(
      margin: EdgeInsets.symmetric(vertical: boxSizeV),
      height: 10 * boxSizeV,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                listItems[index].name,
                style: josefinSansB14,
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(listItems[index].price.toString(),
                      style: josefinSansB14))),
          Expanded(
              flex: 1,
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      height: 50 / 6.4 * boxSizeV,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(listItems[index].pic ?? ""),
                              fit: BoxFit.cover),
                          color: Colors.black),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10 / 3.6 * boxSizeH,
                      right: 10 / 3.6 * boxSizeH,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xffF0F0F0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 5 / 6.4 * boxSizeV,
                        ),
                        child: Provider.of<Order>(context, listen: true)
                                .order
                                .containsKey(listItems[index].id)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => WillPopScope(
                                          onWillPop: () => Future.delayed(
                                              Duration(), () => false),
                                          child: Dialog(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      );
                                      Provider.of<Order>(context, listen: false)
                                          .removeItem(listItems[index].id);
                                      if (Provider.of<Order>(context,
                                                  listen: false)
                                              .order
                                              .length ==
                                          0) {
                                        Provider.of<Order>(context,
                                                listen: false)
                                            .shopId = '';
                                      }
                                      await store.setString(
                                          'order',
                                          Provider.of<Order>(context,
                                                  listen: false)
                                              .toString());
                                      await store.setString(
                                          'shopID',
                                          Provider.of<Order>(context,
                                                  listen: false)
                                              .shopId);
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Provider.of<Order>(context,
                                                    listen: true)
                                                .order[listItems[index].id] ==
                                            1
                                        ? Icons.delete_forever
                                        : Icons.remove),
                                  ),
                                  Text(Provider.of<Order>(context, listen: true)
                                      .order[listItems[index].id]
                                      .toString()),
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => WillPopScope(
                                          onWillPop: () => Future.delayed(
                                              Duration(), () => false),
                                          child: Dialog(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      );
                                      if (Provider.of<Order>(context,
                                                  listen: false)
                                              .order
                                              .length ==
                                          0) {
                                        Provider.of<Order>(context,
                                                listen: false)
                                            .shopId = Provider.of<Shop>(context,
                                                listen: false)
                                            .id;
                                      }
                                      Provider.of<Order>(context, listen: false)
                                          .addItem(listItems[index].id);
                                      await store.setString(
                                          'order',
                                          Provider.of<Order>(context,
                                                  listen: false)
                                              .toString());
                                      await store.setString(
                                          'shopID',
                                          Provider.of<Order>(context,
                                                  listen: false)
                                              .shopId);
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.add),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => WillPopScope(
                                      onWillPop: () => Future.delayed(
                                          Duration(), () => false),
                                      child: Dialog(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  );
                                  if (Provider.of<Order>(context, listen: false)
                                          .order
                                          .length ==
                                      0) {
                                    Provider.of<Order>(context, listen: false)
                                        .shopId = Provider.of<Shop>(context,
                                            listen: false)
                                        .id;
                                  } else if (Provider.of<Order>(context,
                                              listen: false)
                                          .shopId !=
                                      Provider.of<Shop>(context, listen: false)
                                          .id) {
                                    Provider.of<Order>(context, listen: false)
                                        .clearAllItems();
                                    Provider.of<Order>(context, listen: false)
                                        .shopId = Provider.of<Shop>(context,
                                            listen: false)
                                        .id;
                                  }
                                  Provider.of<Order>(context, listen: false)
                                      .addItem(listItems[index].id);
                                  await store.setString(
                                      'order',
                                      Provider.of<Order>(context, listen: false)
                                          .toString());
                                  await store.setString(
                                      'shopID',
                                      Provider.of<Order>(context, listen: false)
                                          .shopId);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Add',
                                  style: josefinSansB12,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
