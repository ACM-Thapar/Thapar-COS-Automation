import 'package:flutter/material.dart';

import '../PageResizing/Variables.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              height: 100 * boxSizeV,
              width: 100 * boxSizeH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 19 / 6.4 * boxSizeV,
                      left: 39 / 3.6 * boxSizeH,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 27 / 6.4 * boxSizeV,
                      left: 36 / 3.6 * boxSizeH,
                    ),
                    child: Text(
                      'Inventory',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ),
                  Container(
                    height: 58 / 6.4 * boxSizeV,
                    width: 291 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 28 / 6.4 * boxSizeV,
                      left: 35 / 3.6 * boxSizeH,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffF8F8F8),
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 3.8 * boxSizeV,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Search an item',
                        hintStyle: TextStyle(fontSize: 22),
                        focusColor: Colors.blue[800],
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    height: 58 / 6.4 * boxSizeV,
                    width: 291 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 28 / 6.4 * boxSizeV,
                      left: 35 / 3.6 * boxSizeH,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Use Google lens',
                          style: TextStyle(fontSize: 21),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 5 / 3.6 * boxSizeH,
                          ),
                          child: Icon(
                            Icons.add_circle,
                            size: 50,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 15 / 6.4 * boxSizeV,
                      left: 35 / 3.6 * boxSizeH,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Add Item',
                          style: TextStyle(fontSize: 21),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 5 / 3.6 * boxSizeH,
                          ),
                          child: Icon(
                            Icons.add_circle,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20 / 6.4 * boxSizeV,
                      left: 35 / 3.6 * boxSizeH,
                    ),
                    height: 302 / 6.4 * boxSizeV,
                    width: 291 / 3.6 * boxSizeH,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
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
                                        'Item:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Price:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Units left:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 10 / 6.4 * boxSizeV,
                            ),
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
                                        'Item:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Price:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Units left:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 10 / 6.4 * boxSizeV,
                            ),
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
                                        'Item:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Price:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Units left:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
