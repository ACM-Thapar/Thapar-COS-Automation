import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './Variables.dart';

Future<bool> errorBox(BuildContext context, PlatformException e) async {
  bool val = false;
  final Map<String, Map<String, List<Widget>>> errorMap = {
    'double': {
      'actions': [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6 * boxSizeH / 3.6),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xffFFCB00),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Text(
              "Yes",
              style: josefinSansR10.copyWith(color: Colors.white),
            ),
            onPressed: () {
              val = true;
              Navigator.of(context).pop();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6 * boxSizeH / 3.6),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xffFFCB00),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child:
                Text("No", style: josefinSansR10.copyWith(color: Colors.white)),
            onPressed: () {
              val = false;
              Navigator.of(context).pop();
            },
          ),
        ),
      ]
    },
    'single': {
      'actions': [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6 * boxSizeH / 3.6),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xffFFCB00),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Text(
              "OK",
              style: josefinSansR10.copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ]
    },
  };

  await showDialog(
    barrierColor: Colors.black12,
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        elevation: 48,
        insetPadding: EdgeInsets.symmetric(
          horizontal: 18 * boxSizeH / 3.6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        children: [
          Container(
            alignment: Alignment.center,
            // padding: EdgeInsets.symmetric(
            //   vertical: 4 * boxSizeV,
            //   horizontal: 30 * boxSizeH / 3.6,
            // ),
            // width: 334 * boxSizeH / 3.6,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 5 * boxSizeV),
                  // decoration: BoxDecoration(border: Border.all()),
                  height: 130 * boxSizeV / 6.4,
                  width: 180 * boxSizeH / 3.6,
                  child: Image(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      e.code == 'Exit' || e.code == 'Logout & Exit'
                          ? 'assets/quit1.png'
                          : e.code == 'Logout'
                              ? 'assets/quit1.png'
                              : 'assets/error.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 2 * boxSizeV,
                ),
                Text(
                  e.code,
                  style: josefinSansSB18.copyWith(
                    color: Color(0xff0D2C34),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 2 * boxSizeV,
                ),
                Text(
                  e.message,
                  style: josefinSansSB10.copyWith(
                    color: Color(0xff707070),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 2 * boxSizeV,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: errorMap[e.details]['actions'],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
  print('val : $val');
  return val;
}
