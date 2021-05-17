import 'package:flash_chat/screens/CartScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_chat/screens/Checkoutscreen.dart';

final _firestore = Firestore.instance;

class OrderItem extends StatefulWidget {
  final String name;
  final int price;
  final String email;
  final String url;
  final String doc_id;
  final String person;
  final String hno;
  final String date_time;
  final availabity;
  final ori_doc_id;

  OrderItem(
      {this.name, this.price, this.email, this.url, this.doc_id,this.hno,this.person,this.date_time,this.ori_doc_id,this.availabity});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

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
                          widget.person,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          widget.price.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          widget.hno,
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
                  icon: Icon(Icons.repeat, color: Colors.blueAccent),
                  iconSize: 30.0,
                  onPressed: () {
                    _firestore.collection('cart').add({
                      'User': widget.email,
                      'Item': widget.name,
                      'Date_Time': DateTime.now().toString(),
                      'Price': widget.price,
                      'Url': widget.url,
                      'Availability': widget.availabity,
                      'ori_item_doc_id': widget.ori_doc_id,
                    });

                    Navigator.pushNamed(context, Cartscreen.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.assignment_return, color: Colors.blueAccent),
                  iconSize: 30.0,
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: '${widget.name} will be returned',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white,
                    );
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