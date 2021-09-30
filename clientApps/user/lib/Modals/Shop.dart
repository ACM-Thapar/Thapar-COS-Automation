import 'package:flutter/material.dart';

import './Review.dart';

class Shop with ChangeNotifier {
  String _id;
  String _name;
  String _address;
  String _pic;
  bool _fav;
  int _capacity;
  String _category;
  double _rating = 0;
  String _status;
  String _phone;
  String _timingsF, _timingsT;
  List<Review> _reviews = [];
  Menu _menu;

  String get id => _id;
  int get capacity => _capacity;
  String get pic => _pic;
  bool get fav => _fav;
  String get category => _category;
  double get rating => _rating;
  String get phone => _phone;
  String get timingsF => _timingsF;
  String get timingsT => _timingsT;
  String get name => _name;
  String get address => _address;
  String get status => _status;
  Menu get menu => this._menu;
  List<Review> get reviews => this._reviews;

  void setMenu(List<dynamic> json) {
    this._menu = Menu.fromJson(json);
  }

  void setReviews(List<dynamic> json) {
    this._reviews = [];
    json.forEach((review) {
      this._reviews.add(Review.fromJson(review));
    });
  }

  void changeFav(bool newFav) {
    this._fav = newFav;
    notifyListeners();
  }

  Shop.fromjson(Map<String, dynamic> json)
      : _id = json['_id'],
        _name = json['name'],
        _address = json['address'],
        _pic = json['photo'],
        _fav = json['isFavourited'],
        _capacity = json['capacity'],
        _category = json['category'],
        _rating = json['averageRating'] == null
            ? 0
            : double.parse(json['averageRating'].toString()),
        _status = json['status'],
        _phone = json['phone'].toString(),
        _timingsF = json['timingsF'],
        _timingsT = json['timingsT'];

  void printShop() {
    print('name : ${this._name}');
    print('address : ${this._address}');
    print('pic : ${this._pic}');
    print('fav : ${this._fav}');
    print('capacity : ${this._capacity}');
    print('category : ${this._category}');
    print('rating : ${this._rating}');
    print('status : ${this._status}');
    print('phone : ${this._phone}');
    print('timingsF : ${this._timingsF}');
    print('Menu: ');
    menu?._items?.forEach((category, listItems) {
      print('Category: $category');
      listItems.forEach((item) {
        print('Name: ${item._name} Price: ${item._price}');
      });
    });
    print("END");
  }
}

class Menu {
  Map<String, List<Item>> _items;
  Map<String, List<Item>> get items => _items;
  Menu.fromJson(List<dynamic> json) {
    this._items = {};
    if (json != null && json.length > 0) {
      this._items = {'all': []};
      json.forEach((dynamic jsonItem) {
        String category = jsonItem['category'].toString().toLowerCase();
        Item item = Item.fromjson(jsonItem);
        if (this._items.containsKey(category))
          this._items[category].add(item);
        else
          this._items[category] = [item];
        this._items['all'].add(item);
      });
    }
  }
}

class Item {
  String _name;
  bool outOfStock;
  String _id;
  int _price;
  String _pic;

  String get name => _name;
  bool get utOfStock => outOfStock;
  String get id => _id;
  int get price => _price;
  String get pic => _pic;

  Item.fromjson(dynamic json)
      : outOfStock = json['outOfStock'],
        _name = json['name'],
        _id = json['id'],
        _pic = json['photo'],
        _price = json['price'];
}
