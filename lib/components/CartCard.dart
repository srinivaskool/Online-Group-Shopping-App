import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = Firestore.instance;

class CartItem extends StatefulWidget {
  final String name;
  final int price;
  final String email;
  final int avail;
  final String url;
  final String doc_id;
  final String ori_item_doc_id;
  final String date_time;

  CartItem(
      {this.name, this.price, this.email, this.url, this.avail, this.doc_id,this.ori_item_doc_id,this.date_time});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  String txt_avail;
  Color txt_color;
  void checkAvailability()
  {
    txt_avail = (widget.avail > 0) ? 'Available : '+ widget.avail.toString():'Sorry out of Stock';
    txt_color = (widget.avail > 0) ? Colors.black:Colors.black38;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAvailability();
  }

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
                  child: Image(
                    height: 100.0,
                    width: 100.0,
                    image: NetworkImage(widget.url),
                    fit: BoxFit.cover,
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
                            color: txt_color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          widget.price.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: txt_color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          txt_avail,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: txt_color,
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
                      'Availability': widget.avail,
                      'Url': widget.url,
                      'User': widget.email,
                      'ori_item_doc_id': widget.ori_item_doc_id,
                      'Date_Time': DateTime.now().toString(),
                    });
                    _firestore.collection('cart').document(widget.doc_id).delete();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.redAccent),
                  iconSize: 30.0,
                  onPressed: () {
                    _firestore.collection('cart').document(widget.doc_id).delete();
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