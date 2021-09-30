import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/Screens/Builder.dart';
import 'package:user/Modals/User.dart';

import '../Variables.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                  color: Color(0xffF0F0F0),
                ),
                height: 226 / 6.4 * boxSizeV,
                width: boxSizeH * 100,
              ),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileBuilder(
                                      appUser: Provider.of<AppUser>(context,
                                          listen: false),
                                      edit: true,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.edit))
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
                        'My Account',
                        style: josefinSansB37,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 40 / 6.4 * boxSizeV,
                      ),
                      height: 170 / 6.4 * boxSizeV,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 108 / 6.4 * boxSizeV,
                                width: 108 / 6.4 * boxSizeV,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffFFCB00)),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 100,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 80 / 6.4 * boxSizeV,
                                    left: 95 / 6.4 * boxSizeV,
                                  ),
                                  height: 24 / 6.4 * boxSizeV,
                                  width: 24 / 6.4 * boxSizeV,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFFCB00)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 20 / 6.4 * boxSizeV,
                            ),
                            child: Text(
                              Provider.of<AppUser>(context, listen: false).name,
                              style: josefinSansSB20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15 / 6.4 * boxSizeV,
                        horizontal: 54 / 3.6 * boxSizeH,
                      ),
                      height: 150 / 6.4 * boxSizeV,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Color(0xffFFCB00),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                Provider.of<AppUser>(context, listen: false)
                                    .hostel,
                                style: josefinSansR14,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Color(0xffFFCB00),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                Provider.of<AppUser>(context, listen: false)
                                    .email,
                                style: josefinSansR14,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Color(0xffFFCB00),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                Provider.of<AppUser>(context, listen: false)
                                    .phone,
                                style: josefinSansR14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 50 / 6.4 * boxSizeV,
                      ),
                      child: Text(
                        'Total Orders: 40',
                        style: josefinSansR14,
                      ),
                    )
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
