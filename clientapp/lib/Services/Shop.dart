import './Review.dart';

class Shop {
  String _name;
  String _address;
  String _pic;
  // String _fav;
  // String _shopNum;
  String _category;
  String _rating;
  String _phone;
  String _timingsF, _timingsT;
  // List<Review> _reviews;
  //MENU

  String get pic => _pic;
  // String get fav => _fav;
  // String get shopNum => _shopNum;
  String get category => _category;
  String get rating => _rating;
  String get phone => _phone;
  String get timingsF => _timingsF;
  String get timingsT => _timingsT;
  String get name => _name;
  String get address => _address;

  Shop.fromjson(Map<String, dynamic> json)
      : _name = json['name'],
        _address = json['address'];
  void printShop() {
    print(this._name);
    print(this._address);
  }
}
