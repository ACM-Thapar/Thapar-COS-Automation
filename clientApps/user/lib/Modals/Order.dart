import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user/Variables.dart';

import 'Shop.dart';

class Order with ChangeNotifier {
  Order() {
    _order = {};
    _total = 0;
  }
  String shopId;
  int _total;
  Map<String, int> _order;

  Map<String, int> get order => _order;
  int get total => _total;

  @override
  String toString() => jsonEncode(this._order);

  void addItem(String id) {
    _total += shops
        .firstWhere((shop) => shop.id == this.shopId)
        .menu
        .items['all']
        .firstWhere((item) => item.id == id)
        .price;
    if (this._order.containsKey(id)) {
      _order[id]++;
    } else {
      _order[id] = 1;
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _total -= shops
        .firstWhere((shop) => shop.id == this.shopId)
        .menu
        .items['all']
        .firstWhere((item) => item.id == id)
        .price;
    if (this._order[id] > 1) {
      this._order[id]--;
    } else {
      this._order.remove(id);
    }
    notifyListeners();
  }

  void clearAllItems() {
    _total = 0;
    shopId = null;
    _order = {};
    notifyListeners();
  }

  Order.fromJson(List<dynamic> list, String shopId) {
    this.shopId = shopId;
    this._order = {};
    list.forEach((id) {
      if (this._order.containsKey(id.toString()))
        this._order[id.toString()]++;
      else
        this._order[id.toString()] = 1;
    });
  }

  void fromMap(Map<String, int> json, String shopId) {
    this._order = json;
    this.shopId = shopId;
    Menu menu = shops.firstWhere((shop) => shop.id == shopId).menu;
    this._total = 0;
    json.forEach((itemId, quantity) {
      this._total +=
          (menu.items['all'].firstWhere((item) => item.id == itemId).price *
              quantity);
    });
  }

  printOrder() {
    Shop shop = shops.firstWhere((shop) => shop.id == this.shopId);
    print("SHOP ID: ${this.shopId}  Shop name: ${shop.name}");
    this._order.forEach((id, quantity) {
      print(
          '${shop.menu.items['all'].firstWhere((item) => item.id == id).name} : $quantity');
    });
  }
}
