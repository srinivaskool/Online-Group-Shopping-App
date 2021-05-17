import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = Firestore.instance;

class StoreItem extends StatefulWidget {
  final int price;
  final int availbity;
  final String color;
  final String name;
  final String category;
  final String url;
  final String email;
  final String ori_item_doc_id;

  StoreItem(
      {this.name,
      this.color,
      this.availbity,
      this.price,
      this.category,
      this.url,
      this.email,
      this.ori_item_doc_id});

  @override
  _StoreItemState createState() => _StoreItemState();
}

class _StoreItemState extends State<StoreItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: 320.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          )
        ],
        border: Border.all(
          width: 1.0,
          color: Colors.grey[200],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.url,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          widget.price.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          widget.color,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  iconSize: 30.0,
                  color: Colors.red,
                  onPressed: () {
                    _firestore.collection('cart').add({
                      'User': widget.email,
                      'Item': widget.name,
                      'Date_Time': DateTime.now().toString(),
                      'Price': widget.price,
                      'Url': widget.url,
                      'Availability': widget.availbity,
                      'ori_item_doc_id': widget.ori_item_doc_id,
                    });
                    Fluttertoast.showToast(
                      msg: "${widget.name} added to Cart",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.redAccent),
                  iconSize: 30.0,
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "Item Added to your wishlist",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white,
                    );
                    _firestore.collection('wishlist').add({
                      'Name': widget.name,
                      'Price': widget.price,
                      'Availability': widget.availbity,
                      'Url': widget.url,
                      'User': widget.email,
                      'ori_item_doc_id': widget.ori_item_doc_id,
                      'Date_Time': DateTime.now().toString(),
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


