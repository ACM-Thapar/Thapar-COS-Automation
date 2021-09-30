import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/Modals/Order.dart';
import 'package:user/Modals/Shop.dart';

import '../Variables.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  StreamController<Order> _controller;
  void fun() {
    // print("STATUS UPDATE");
    _controller.add(Provider.of<Order>(context, listen: false));
  }

  @override
  void initState() {
    _controller = StreamController.broadcast();
    Provider.of<Order>(context, listen: false).addListener(fun);
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
    _controller.close();
    // print("DISPOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("BUILD FULL PAGE");
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 100 * boxSizeV,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
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
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 39 / 3.6 * boxSizeH),
                  child: StreamBuilder<Order>(
                    initialData: Provider.of<Order>(context, listen: false),
                    stream: _controller.stream,
                    builder: (context, snapshot) {
                      final List<String> list =
                          snapshot.data.order.keys.toList();
                      final String shoppId = snapshot.data.shopId;
                      return ListView.builder(
                        itemCount: snapshot.data.order.length,
                        itemBuilder: (context, index) => ItemWidget(
                          order: snapshot.data,
                          item: shops
                              .firstWhere((shop) => shop.id == shoppId)
                              .menu
                              .items['all']
                              .firstWhere((item) => item.id == list[index]),
                        ),

                        // children: [
                        //   // Container(),
                        //   // for (int i = 0;
                        //   //     i <

                        //   //     i++)

                        // ],
                      );
                    },
                  ),
                ),
              ),
              InvoiceSheet(),
            ],
          ),
          // child: Stack(
          //   children: <Widget>[
        ),
      ),
    );
  }
}

class InvoiceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 15.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              0, // Move to right 10  horizontally
              -2 / 6.4 * boxSizeV, // Move to bottom 10 Vertically
            ),
          )
        ],
        color: Color(0xffFFCB00),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
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
            height: 120 / 6.4 * boxSizeV,
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
                        'Rs ${Provider.of<Order>(context, listen: true).total}',
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
                        'Rs ${Provider.of<Order>(context, listen: true).total}',
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
            margin: EdgeInsets.only(
              bottom: 18 / 6.4 * boxSizeV,
            ),
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
    );
  }
}

class ItemWidget extends StatelessWidget {
  final Order order;
  final Item item;
  ItemWidget({this.item, this.order});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF8F8F8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xffCBCBCB)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.price.toString(),
                  style: josefinSansR10.copyWith(color: Color(0xffFFCB00)),
                ),
                Text(
                  item.name,
                  style: josefinSansSB14,
                ),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 93 / 3.6 * boxSizeH,
                    height: 25 / 6.4 * boxSizeV,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                            Provider.of<Order>(context, listen: false)
                                .removeItem(item.id);
                            if (Provider.of<Order>(context, listen: false)
                                    .order
                                    .length ==
                                0) {
                              Provider.of<Order>(context, listen: false)
                                  .shopId = '';
                            }
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
                          child: Icon(Provider.of<Order>(context, listen: false)
                                      .order[item.id] ==
                                  1
                              ? Icons.delete_forever
                              : Icons.remove),
                        ),
                        Text(Provider.of<Order>(context, listen: false)
                            .order[item.id]
                            .toString()),
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
                            if (Provider.of<Order>(context, listen: false)
                                    .order
                                    .length ==
                                0) {
                              Provider.of<Order>(context, listen: false)
                                      .shopId =
                                  Provider.of<Shop>(context, listen: false).id;
                            }
                            Provider.of<Order>(context, listen: false)
                                .addItem(item.id);
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
                          child: Icon(Icons.add),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
