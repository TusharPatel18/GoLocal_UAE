import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_local_vendor/models/review_model.dart';

class ReviewComponent extends StatelessWidget {
  final ReviewModel reviewModel;

  const ReviewComponent({@required this.reviewModel}) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(reviewModel.fullname),
              RatingBar(
                initialRating: double.parse(reviewModel.rating),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 15,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (val) {},
                ratingWidget: RatingWidget(
                    empty: Icon(
                      Icons.star_border,
                      color: Colors.amber,
                    ),
                    full: Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    half: Icon(
                      Icons.star_half,
                      color: Colors.amber,
                    )),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            reviewModel.review,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
