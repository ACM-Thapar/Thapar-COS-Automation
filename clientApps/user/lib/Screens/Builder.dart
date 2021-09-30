import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../ErrorBox.dart';
import '../Variables.dart';
import './HomePage.dart';
import '../Modals/User.dart';
import '../Services/ServerRequests.dart';
import '../Modals/Shop.dart';
import '../WidgetResizing.dart';

// TODO: REDESIGN ALL TEXTFIELD HERE

class ProfileBuilder extends StatefulWidget {
  final AppUser appUser;
  final bool edit;
  ProfileBuilder({@required this.appUser, @required this.edit});
  @override
  _ProfileBuilderState createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  String _hostel, _name;
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
    _hostel = widget.appUser.hostel ?? 'A';
    _nameController = TextEditingController(text: widget.appUser.name);
    _emailController = TextEditingController(text: widget.appUser.email);
    _phoneController = TextEditingController(text: widget.appUser.phone);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boxSizeH = SizeConfig.safeBlockHorizontal;
    boxSizeV = SizeConfig.safeBlockVertical;
    return OrientationBuilder(
      builder: (context, orientation) => WillPopScope(
        onWillPop: () async {
          return await Future.delayed(Duration(), () => true);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: orientation == Orientation.landscape
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 35,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'User Details',
                              style: robotoB37.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                              color: Color(0xffFFCB00),
                                              width: 2.8),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          MdiIcons.cameraEnhanceOutline,
                                          color: Color(0xffffcb00),
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      Flexible(
                                        child: Container(
                                          child: TextField(
                                            onChanged: (val) {
                                              _name = val;
                                            },
                                            onSubmitted: (v) {
                                              if (v == '' || v == null) {
                                                _nameController.text =
                                                    widget.appUser.name;
                                              }
                                            },
                                            controller: _nameController,
                                            autofocus: false,
                                            keyboardType: TextInputType.name,
                                            cursorColor: Color(0xffFFCB00),
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xffFFCB00),
                                                ),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 4),
                                              labelText: 'Name',
                                              hintText: widget.appUser.name,
                                              labelStyle: openSansL14.copyWith(
                                                color: Color(0xAB707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: _emailController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 4),
                                        labelText: 'Email',
                                        labelStyle: openSansL14.copyWith(
                                            color: Color(0xAB707070))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: TextField(
                                    controller: _phoneController,
                                    enabled: false,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 4),
                                        labelText: 'Contact No.',
                                        labelStyle: openSansL14.copyWith(
                                            color: Color(0xAB707070))),
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                  child: DropdownButtonFormField<String>(
                                    style: openSansR14.copyWith(
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Hostel',
                                      labelStyle: openSansL14.copyWith(
                                          color: Color(0xAB707070)),
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
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_name != null && _name != '') {
                                  Provider.of<AppUser>(context, listen: false)
                                      .setName(_name);
                                }
                                Provider.of<AppUser>(context, listen: false)
                                    .hostel = _hostel;
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
                                bool success = true;
                                try {
                                  success = await Provider.of<ServerRequests>(
                                          context,
                                          listen: false)
                                      .updateProfile(Provider.of<AppUser>(
                                          context,
                                          listen: false));
                                } on PlatformException catch (e) {
                                  Navigator.pop(
                                      context); //Remove circular indicator
                                  //SHOW ERROR
                                  await errorBox(context, e);
                                  print(e.message);
                                  success = false;
                                }
                                if (success) {
                                  if (widget.edit) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    //GET ALL SHOPS
                                    final List<dynamic> list =
                                        await Provider.of<ServerRequests>(
                                                context,
                                                listen: false)
                                            .getShops();
                                    list.forEach((element) {
                                      Shop.fromjson(element);
                                      shops.add(Shop.fromjson(element));
                                    });
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                        (_) => false);
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  'Save',
                                  style: josefinSansR18.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 35,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Details',
                              style: robotoB37.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
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
                                const SizedBox(width: 40),
                                Flexible(
                                  child: Container(
                                    child: TextField(
                                      onChanged: (val) {
                                        _name = val;
                                      },
                                      onSubmitted: (v) {
                                        if (v == '' || v == null) {
                                          _nameController.text =
                                              widget.appUser.name;
                                        }
                                      },
                                      controller: _nameController,
                                      autofocus: false,
                                      keyboardType: TextInputType.name,
                                      cursorColor: Color(0xffFFCB00),
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xffFFCB00),
                                          ),
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(bottom: 4),
                                        labelText: 'Name',
                                        hintText: widget.appUser.name,
                                        labelStyle: openSansL14.copyWith(
                                          color: Color(0xAB707070),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextField(
                              controller: _emailController,
                              enabled: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 4),
                                  labelText: 'Email',
                                  labelStyle: openSansL14.copyWith(
                                      color: Color(0xAB707070))),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextField(
                              controller: _phoneController,
                              enabled: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 4),
                                  labelText: 'Contact No.',
                                  labelStyle: openSansL14.copyWith(
                                      color: Color(0xAB707070))),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            DropdownButtonFormField<String>(
                              style: openSansR14.copyWith(color: Colors.black),
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Hostel',
                                labelStyle: openSansL14.copyWith(
                                    color: Color(0xAB707070)),
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
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_name != null && _name != '') {
                                  Provider.of<AppUser>(context, listen: false)
                                      .setName(_name);
                                }
                                Provider.of<AppUser>(context, listen: false)
                                    .hostel = _hostel;
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
                                bool success = true;
                                try {
                                  success = await Provider.of<ServerRequests>(
                                          context,
                                          listen: false)
                                      .updateProfile(Provider.of<AppUser>(
                                          context,
                                          listen: false));
                                } on PlatformException catch (e) {
                                  Navigator.pop(
                                      context); //Remove circular indicator
                                  //SHOW ERROR
                                  await errorBox(context, e);
                                  print(e.message);
                                  success = false;
                                }
                                if (success) {
                                  if (widget.edit) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    //GET ALL SHOPS
                                    final List<dynamic> list =
                                        await Provider.of<ServerRequests>(
                                                context,
                                                listen: false)
                                            .getShops();
                                    list.forEach((element) {
                                      Shop.fromjson(element);
                                      shops.add(Shop.fromjson(element));
                                    });
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                        (_) => false);
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 20),
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
        ),
      ),
    );
  }
}
