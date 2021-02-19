import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timelines/timelines.dart';

import '../Variables.dart';

// TODO: REFACTOR TRACKING PAGE
final _processes = [
  'Confirmed',
  'Preparing',
  'Ready',
  'Served',
];
final time = [
  '5:00 pm',
  '5:15 pm',
  '5:40 pm',
  '5:45 pm',
];
const completeColor = Color(0xffFFCB00);
const todoColor = Color(0xff828080);
// TODO :ADD THIS TO INCREASE THE STATUS
// Icon(FontAwesomeIcons.chevronRight),
//         onPressed: () {
//           setState(() {
//             _processIndex = (_processIndex + 1) % _processes.length;
//           });
//         },

class TrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xffF0F0F0),
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
                  'Tracking',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 40 / 6.4 * boxSizeV,
                  left: 15 / 3.6 * boxSizeH,
                  right: 15 / 3.6 * boxSizeH,
                ),
                height: 40 / 6.4 * boxSizeV,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 8),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Order No.',
                          style: GoogleFonts.josefinSans(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Name',
                          style: GoogleFonts.josefinSans(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Amount',
                          style: GoogleFonts.josefinSans(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20 / 6.4 * boxSizeV,
                  left: 15 / 3.6 * boxSizeH,
                  right: 15 / 3.6 * boxSizeH,
                ),
                height: 438 / 6.4 * boxSizeV,
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return Item(index: index + 1);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final int index;
  Item({this.index});
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool open = false;
  int _processIndex = 1;

  Color getColor(int index) {
    if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20 / 6.4 * boxSizeV),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                open = !open;
              });
              // print('ok');
            },
            child: Container(
              height: 40 / 6.4 * boxSizeV,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.index.toString().padLeft(2, '0'),
                        style: GoogleFonts.josefinSans(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Name',
                        style: GoogleFonts.josefinSans(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Amount',
                        style: GoogleFonts.josefinSans(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Icon(
                        open
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Color(0xFFFFCB00),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: open
                ? EdgeInsets.symmetric(vertical: 16 / 6.4 * boxSizeV)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Color(0x52CBCBCB),
              boxShadow: [
                BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: open
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 13 / 6.4 * boxSizeV),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'S No.',
                                  style: GoogleFonts.josefinSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Ordered Items',
                                  style: GoogleFonts.josefinSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Amount',
                                  style: GoogleFonts.josefinSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Price',
                                  style: GoogleFonts.josefinSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 6 / 6.4 * boxSizeV),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (index + 1).toString().padLeft(2, '0'),
                                      style: GoogleFonts.josefinSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Ordered Items',
                                      style: GoogleFonts.josefinSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Amount',
                                      style: GoogleFonts.josefinSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Price',
                                      style: GoogleFonts.josefinSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 12 * boxSizeV,
                        child: Timeline.tileBuilder(
                          theme: TimelineThemeData(
                            direction: Axis.horizontal,
                            connectorTheme: ConnectorThemeData(
                              space: 40.0,
                              thickness: 5.0,
                            ),
                          ),
                          builder: TimelineTileBuilder.connected(
                            connectionDirection: ConnectionDirection.before,
                            itemExtentBuilder: (_, __) =>
                                330 / 3.6 * boxSizeH / _processes.length,
                            oppositeContentsBuilder: (context, index) {
                              return Text(
                                time[index],
                                style: GoogleFonts.josefinSans(
                                    color: Color(0xff707070),
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              );
                            },
                            contentsBuilder: (context, index) {
                              return Text(
                                _processes[index],
                                style: GoogleFonts.josefinSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10),
                              );
                            },
                            indicatorBuilder: (_, index) {
                              var color;
                              if (index < _processIndex) {
                                color = completeColor;
                              } else {
                                color = todoColor;
                              }

                              return Stack(
                                children: [
                                  CustomPaint(
                                    size: Size(20.0, 20.0),
                                    painter: _BezierPainter(
                                      color: color,
                                      drawStart: index > 0,
                                      drawEnd: index < _processIndex,
                                    ),
                                  ),
                                  DotIndicator(
                                    size: 20.0,
                                    color: color,
                                  ),
                                ],
                              );
                            },
                            connectorBuilder: (_, index, type) {
                              if (index > 0) {
                                if (index == _processIndex) {
                                  final prevColor = getColor(index - 1);
                                  final color = getColor(index);
                                  var gradientColors;
                                  if (type == ConnectorType.start) {
                                    gradientColors = [
                                      Color.lerp(prevColor, color, 0.5),
                                      color
                                    ];
                                  } else {
                                    gradientColors = [
                                      prevColor,
                                      Color.lerp(prevColor, color, 0.5)
                                    ];
                                  }
                                  return DecoratedLineConnector(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: gradientColors,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SolidLineConnector(
                                    color: getColor(index),
                                  );
                                }
                              } else {
                                return null;
                              }
                            },
                            itemCount: _processes.length,
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    width: 330 / 3.6 * boxSizeH,
                  ),
          ),
        ],
      ),
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    @required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(
            size.width, size.height / 2, size.width + radius, radius)
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}
