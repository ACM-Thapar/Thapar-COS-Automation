import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import '../Variables.dart';
import './HomePage.dart';
import './ShopProfile.dart';
import '../Services/User.dart';
import '../Services/ServerRequests.dart';

// TODO: REDESIGN ALL TEXTFIELD HERE

class ProfileBuilder extends StatefulWidget {
  ProfileBuilder({this.type});
  final bool type;
  @override
  _ProfileBuilderState createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.delayed(
        Duration(),
        () => true,
      ),
      child: SafeArea(
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
                      widget.type ? 'Shopkeeper Details' : 'User Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 41,
                      ),
                    ),
                  ),
                  Container(
                    height: 89 / 6.4 * boxSizeV,
                    width: 290 / 3.6 * boxSizeH,
                    margin: EdgeInsets.only(
                      top: 32 / 6.4 * boxSizeV,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 89 / 6.4 * boxSizeV,
                          width: 89 / 3.6 * boxSizeH,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            MdiIcons.cameraEnhanceOutline,
                            color: Color(0xffffcb00),
                            size: 30,
                          ),
                        ),
                        Container(
                          width: 145 / 3.6 * boxSizeH,
                          margin: EdgeInsets.only(
                            right: 20 / 3.6 * boxSizeH,
                          ),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                              hintText: 'Name',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.5 / 6.4 * boxSizeV,
                  ),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                      hintText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                      hintText: 'Contact No.',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    //TODO: MAKE THIS A DROPODOWN
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                      hintText: 'Hostel',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     contentPadding:
                  //         EdgeInsets.only(bottom: 35 / 6.4 * boxSizeV),
                  //     hintText: 'Joined On',
                  //   ),
                  // ),
                  Container(
                    //TODO: CHANGE THIS TO REQUIRED ONLY WHEN NOT GOOGLESIGNED IN (APPUSER HAS A BOOL GSIGN)
                    margin: EdgeInsets.only(top: 32),
                    child: Text(
                      'Change Password ?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              widget.type ? ShopProfile() : HomePage(),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () async {
                        Provider.of<AppUser>(context, listen: false).hostel =
                            'H'; //TODO REMOVE THIS AND PLACE AT CORRECT POSITION
                        // Provider.of<AppUser>(context, listen: false)
                        //     .printUser();
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

                        if (await Provider.of<ServerRequests>(context,
                                listen: false)
                            .registerGoogle(
                                Provider.of<AppUser>(context, listen: false))) {
                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (_) => false);
                        } else {
                          Navigator.pop(context);
                          print('error from server');
                          // TODO: SHOW ERROR
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        alignment: Alignment.center,
                        width: 291 * boxSizeH / 3.6,
                        height: 58 * boxSizeV / 6.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.black,
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.josefinSans(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
