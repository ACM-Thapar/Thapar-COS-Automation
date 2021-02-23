import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../ErrorBox.dart';
import '../Variables.dart';
import './HomePage.dart';
import '../Services/User.dart';
import '../Services/ServerRequests.dart';
import './ShopProfile.dart';
import '../Services/Shop.dart';
import '../WidgetResizing.dart';

// TODO: REDESIGN ALL TEXTFIELD HERE

class ProfileBuilder extends StatefulWidget {
  final AppUser appUser;
  ProfileBuilder({@required this.appUser});
  @override
  _ProfileBuilderState createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  String _hostel = 'A', _name;
  TextEditingController _nameController, _emailController, _phoneController;
  List<String> hostelList = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'PG',
    'FRD',
    'FRE',
    'Day Scholar',
  ];
  @override
  void initState() {
    _nameController = TextEditingController(text: widget.appUser.name);
    _emailController = TextEditingController(text: widget.appUser.email);
    _phoneController = TextEditingController(text: widget.appUser.phone);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
    return WillPopScope(
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
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
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
                      store.getBool('userType')
                          ? 'User Details'
                          : 'Shopkeeper Details',
                      style: robotoB37.copyWith(color: Colors.black),
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
                            border: Border.all(
                                color: Color(0xffFFCB00), width: 2.8),
                            borderRadius: BorderRadius.circular(20),
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
                            onChanged: (val) {
                              _name = val;
                            },
                            onSubmitted: (v) {
                              print(v);
                              if (v == '' || v == null) {
                                _nameController.text = widget.appUser.name;
                              }
                            },
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            cursorColor: Color(0xffFFCB00),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xffFFCB00),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 4),
                              labelText: 'Name',
                              hintText: widget.appUser.name,
                              labelStyle: openSansL14.copyWith(
                                color: Color(0xAB707070),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35 / 6.4 * boxSizeV,
                  ),
                  TextField(
                    controller: _emailController,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 4),
                        labelText: 'Email',
                        labelStyle:
                            openSansL14.copyWith(color: Color(0xAB707070))),
                  ),
                  SizedBox(
                    height: 35 / 6.4 * boxSizeV,
                  ),
                  TextField(
                    controller: _phoneController,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 4),
                        labelText: 'Contact No.',
                        labelStyle:
                            openSansL14.copyWith(color: Color(0xAB707070))),
                  ),
                  SizedBox(
                    height: 25 / 6.4 * boxSizeV,
                  ),
                  store.getBool('userType')
                      ? DropdownButtonFormField<String>(
                          style: openSansR14.copyWith(color: Colors.black),
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Hostel',
                            labelStyle:
                                openSansL14.copyWith(color: Color(0xAB707070)),
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          items: hostelList
                              .map((value) => DropdownMenuItem(
                                    child: Text(value.toString()),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (String value) {
                            setState(() {
                              _hostel = value;
                            });
                          },
                          value: _hostel,
                        )
                      : Container(),
                  SizedBox(
                    height: 25 / 6.4 * boxSizeV,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_name != null && _name != '') {
                        Provider.of<AppUser>(context, listen: false)
                            .setName(_name);
                      }
                      Provider.of<AppUser>(context, listen: false).hostel =
                          _hostel;
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
                      bool success;
                      try {
                        success = await Provider.of<ServerRequests>(context,
                                listen: false)
                            .updateProfile(
                                Provider.of<AppUser>(context, listen: false));
                      } on PlatformException catch (e) {
                        Navigator.pop(context); //Remove circular indicator
                        //SHOW ERROR
                        await errorBox(context, e);
                        print(e.message);
                        success = false;
                      }
                      if (success) {
                        //GET ALL SHOPS
                        if (store.getBool('userType')) {
                          final List<dynamic> list =
                              await Provider.of<ServerRequests>(context,
                                      listen: false)
                                  .getShops(store.getString('token'));
                          list.forEach((element) {
                            Shop.fromjson(element);
                            shops.add(Shop.fromjson(element));
                          });
                        }
                        Navigator.pop(context);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => store.getBool('userType')
                                  ? HomePage()
                                  : ShopProfile(),
                            ),
                            (_) => false);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 35),
                      alignment: Alignment.center,
                      width: 291 * boxSizeH / 3.6,
                      height: 58 * boxSizeV / 6.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Colors.black,
                      ),
                      child: Text(
                        'Save',
                        style: josefinSansR18.copyWith(
                          color: Colors.white,
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
