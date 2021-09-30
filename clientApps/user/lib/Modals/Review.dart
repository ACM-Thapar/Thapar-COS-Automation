class Review {
  Review();
  String _name;
  double rating;
  // String _time;
  String review;
  String _cutomerPic;
  String id;

  String get name => _name;
  // String get time => _time;
  String get cutomerPic => _cutomerPic;

  Review.fromJson(dynamic json)
      : review = json['text'],
        id = json['_id'],
        _name = json['user']['name'],
        rating = double.parse(json['rating'].toString());
}
