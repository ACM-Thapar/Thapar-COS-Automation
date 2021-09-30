import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:user/Modals/Review.dart';
import 'package:user/Services/ServerRequests.dart';

import '../ErrorBox.dart';
import '../Variables.dart';

class PostReview extends StatefulWidget {
  final Review prevReview;
  final String shopId;

  const PostReview({this.prevReview, this.shopId});
  @override
  _PostReviewState createState() => _PostReviewState();
}

class _PostReviewState extends State<PostReview> {
  TextEditingController _controller;
  Review _rev;
  @override
  void initState() {
    _rev = widget.prevReview != null
        ? Review.fromJson({
            'id': widget.prevReview.id,
            'text': widget.prevReview.review,
            'user': {'name': widget.prevReview.name},
            'rating': widget.prevReview.rating
          })
        : Review();
    _controller = TextEditingController(
        text: widget.prevReview != null ? widget.prevReview.review : null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.prevReview == null ? 'Write a Review' : 'Update Review',
                style: josefinSansB28,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: RatingBar.builder(
                  initialRating: widget.prevReview != null ? _rev.rating : 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 45,
                  unratedColor: Color(0xffF0F0F0),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rev.rating = rating;
                  },
                ),
              ),
              TextField(
                onChanged: (v) {
                  _rev.review = v;
                },
                controller: _controller,
                maxLines: 6,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffF0F0F0),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(color: Colors.transparent)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(color: Colors.transparent)),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: GestureDetector(
                  onTap: () async {
                    if (widget.prevReview?.review != _rev.review ||
                        widget.prevReview?.rating != _rev.rating) {
                      bool success;
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
                      try {
                        success = widget.prevReview == null
                            ? await Provider.of<ServerRequests>(context,
                                    listen: false)
                                .postReview(_rev, widget.shopId)
                            : await Provider.of<ServerRequests>(context,
                                    listen: false)
                                .updateReview(_rev);
                      } on PlatformException catch (e) {
                        print(e.code);
                        //TODO ASK WHAT AGAIN SIGN OR what
                        //CRASH APP ERROR
                        await errorBox(context, e);
                        success = false;
                      }
                      Navigator.pop(context);
                      if (success) Navigator.pop(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(vertical: 18 / 6.4 * boxSizeV),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25)),
                    margin:
                        EdgeInsets.symmetric(horizontal: 5 / 3.6 * boxSizeH),
                    child: Text(
                      widget.prevReview == null
                          ? 'Post Review'
                          : 'Update Review',
                      style: josefinSansR18.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
