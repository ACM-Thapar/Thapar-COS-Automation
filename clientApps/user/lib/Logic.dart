import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Variables.dart';

class Logic extends StatefulWidget {
  @override
  _LogicState createState() => _LogicState();
}

class _LogicState extends State<Logic> {
  final List<Person> list = [
    for (int i = 0; i < 5; i++)
      Person(age: i, name: "${i % 2 == 0 ? 'kd' : 'jgt'}ame $i")
  ];
  StreamController<List<Person>> _streamController;
  TextEditingController _controller;

  void initState() {
    print(list);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _streamController = StreamController.broadcast();
    // _streamController.
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text("PAGE 1"),
          ),
          Container(
            // height: 58 / 6.4 * boxSizeV,
            // width: 291 / 3.6 * boxSizeH,
            // margin: EdgeInsets.only(
            //   top: 10 / 6.4 * boxSizeV,
            //   left: 35 / 3.6 * boxSizeH,
            //   right: 36 / 3.6 * boxSizeH,
            // ),
            // decoration: BoxDecoration(
            //   // borderRadius: BorderRadius.circular(10),
            //   border: Border.all(color: Color(0xffCBCBCB)),
            //   // color: Color(0xffF8F8F8),
            // ),
            child: TextField(
              controller: _controller,
              style: openSansR14.copyWith(color: Colors.black),
              cursorColor: Color(0xffFFCB00),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                fillColor: Color(0x80F8F8F8),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 0.5,
                    color: Color(0xffCBCBCB),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2,
                    color: Color(0xffFFCB00),
                  ),
                ),
                hintText: 'Search a Category',
                hintStyle: openSansL14.copyWith(
                  color: Color(0xAB707070),
                ),
              ),
              onChanged: (value) {
                List<Person> _searchResults = [];
                if (value != null && value != '') {
                  list.forEach((person) {
                    if (person.name
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      print(person.name);
                      _searchResults.add(person);
                    }
                  });
                } else
                  setState(() {
                    _searchResults = list;
                  });

                _streamController.add(_searchResults);
              },
            ),
          ),
          Flexible(
            child: StreamBuilder<List<Person>>(
              initialData: list,
              stream: _streamController.stream,
              builder: (context, snapshot) => ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) => ChangeNotifierProvider.value(
                        value: snapshot.data[i],
                        builder: (context, child) => GestureDetector(
                          onTap: () {
                            final person =
                                Provider.of<Person>(context, listen: false);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                          value: person, child: Page2()),
                                ));
                          },
                          child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                        child: FloatingActionButton(
                                            heroTag: null,
                                            child: Icon(Icons.add),
                                            onPressed: () {
                                              Provider.of<Person>(context,
                                                      listen: false)
                                                  .incAge(Provider.of<Person>(
                                                              context,
                                                              listen: false)
                                                          .age +
                                                      2);
                                            }))
                                  ],
                                  text:
                                      "Name: ${Provider.of<Person>(context, listen: false).name}  Age: ${Provider.of<Person>(context, listen: true).age}")),
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}

class Person with ChangeNotifier {
  Person({this.age, this.name});
  int age;
  String name;
  void incAge(int age) {
    this.age = age;
    notifyListeners();
  }

  Person.copyWith(int age, String name)
      : age = age,
        name = name;
  // @override
  // void addListener(listener) {
  //   if (!_dispose) super.addListener(listener);
  // }

  // @override
  // void removeListener(listener) {
  //   if (!_dispose) super.removeListener(listener);
  // }

  // @override
  // void notifyListeners() {
  //   if (!_dispose) super.notifyListeners();
  // }

  // @override
  // void dispose() {
  //   if (!_dispose) {
  //     _dispose = true;
  //     super.dispose();
  //   }
  // }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: RichText(
            text: TextSpan(children: [
          WidgetSpan(
              child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Provider.of<Person>(context, listen: false).incAge(
                        Provider.of<Person>(context, listen: false).age + 2);
                  }))
        ], text: "Name: ${Provider.of<Person>(context, listen: false).name}  Age: ${Provider.of<Person>(context, listen: true).age}")),
      ),
    );
  }
}
