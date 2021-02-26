import 'package:flutter/material.dart';

import '../Variables.dart';
import '../WidgetResizing.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 100 * boxSizeV,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: boxSizeV * 100,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 39 / 3.6 * boxSizeH,
                        vertical: 19 / 6.4 * boxSizeV,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_back,
                          ),
                          Icon(
                            Icons.add,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20 / 6.4 * boxSizeV,
                      ),
                      // decoration: BoxDecoration(border: Border.all()),
                      width: 280 / 3.6 * boxSizeH,
                      child: Text(
                        'My Cart',
                        style: josefinSansB37,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 39 / 3.6 * boxSizeH),
                      height: 500 / 6.4 * boxSizeV,
                      child: ListView.builder(
                        itemCount: 15,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Color(0xffCBCBCB)),
                                  ),
                                  margin: EdgeInsets.only(
                                    bottom: 8 / 6.4 * boxSizeV,
                                  ),
                                  height: 105 / 6.4 * boxSizeV,
                                  width: 105 / 3.6 * boxSizeH,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 14 / 6.4 * boxSizeV,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 14 / 6.4 * boxSizeV,
                                  ),
                                  height: 79 / 6.4 * boxSizeV,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rs. 50.00',
                                        style: josefinSansR10.copyWith(
                                            color: Color(0xffFFCB00)),
                                      ),
                                      Text(
                                        'My Item',
                                        style: josefinSansSB14,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width: 93 / 3.6 * boxSizeH,
                                        height: 25 / 6.4 * boxSizeV,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 28 / 3.6 * boxSizeH,
                                              child: Icon(
                                                Icons.delete_outline_outlined,
                                                size: 20,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 34 / 3.6 * boxSizeH,
                                              color: Color(0xffF0F0F0),
                                              child: Text(
                                                '01',
                                                style: openSansR14,
                                              ),
                                            ),
                                            Container(
                                              width: 28 / 3.6 * boxSizeH,
                                              child: Icon(
                                                Icons.add,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                          ;
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: boxSizeV * (100 - (226 / 6.4))),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x80000000),
                      blurRadius: 25.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: Offset(
                        15.0, // Move to right 10  horizontally
                        15.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                  color: Color(0xffFFCB00),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                height: 226 / 6.4 * boxSizeV,
                width: boxSizeH * 100,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 47 / 3.6 * boxSizeH,
                        top: 18 / 6.4 * boxSizeV,
                        right: 47 / 3.6 * boxSizeH,
                        bottom: 18 / 6.4 * boxSizeV,
                      ),
                      width: 277 / 3.6 * boxSizeH,
                      height: 145 / 6.4 * boxSizeV,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SubTotal',
                                style: josefinSansR14.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: boxSizeH * 75 / 3.6,
                                child: Text(
                                  'Rs 180.00',
                                  style: josefinSansR14.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tax',
                                style: josefinSansR14.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: boxSizeH * 75 / 3.6,
                                child: Text(
                                  'Rs 10.00',
                                  style: josefinSansR14.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery',
                                style: josefinSansR14.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: boxSizeH * 75 / 3.6,
                                child: Text(
                                  'Free',
                                  style: josefinSansR14.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL',
                                style: josefinSansSB14.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: boxSizeH * 75 / 3.6,
                                child: Text(
                                  'Rs 160.00',
                                  style: josefinSansSB14.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Points : 50',
                                style: josefinSansR14.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 85 / 3.6 * boxSizeH,
                                height: 15 / 6.4 * boxSizeV,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Text(
                                  'Redeem Point',
                                  style: josefinSansR10.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 219 / 3.6 * boxSizeH,
                      height: 35 / 6.4 * boxSizeV,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Text(
                        'PROCEED TO BUY',
                        style: josefinSansSB14.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
