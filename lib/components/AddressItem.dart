import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_chat/screens/store_screen.dart';

final _firestore = Firestore.instance;

class AddressItem extends StatefulWidget {
  final String city;
  final String hno;
  final String name;
  final String street;
  final int pin;

  AddressItem({
    this.name,
    this.city,
    this.hno,
    this.pin,
    this.street,
  });

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  void add_data() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("cart").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.data['User'] == storeloggedUser.email && a.data['Availability'] > 0) {
        String ori_doc_id = a.data['ori_item_doc_id'];
        int new_avail = a.data['Availability'] - 1;

        _firestore.collection('orders').add({
          'Url': a.data['Url'],
          'Name': a.data['Item'],
          'Price': a.data['Price'],
          'Date_Time': DateTime.now().toString(),
          'User': storeloggedUser.email,
          'Person': widget.name,
          'Hno': widget.hno,
          'Availability': a.data['Availability'],
          'ori_doc_id': ori_doc_id,
        });

        _firestore.collection('cart').document(a.documentID).delete();

        _firestore
            .collection('store')
            .document(ori_doc_id)
            .updateData({'Available': new_avail});
      }
    }
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
                        SizedBox(height: 6.0),
                        Text(
                          widget.city,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          widget.pin.toString(),
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
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  widget.hno,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.0),
                Text(
                  widget.street,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
//              width: 70.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: FlatButton(
                color: Colors.blueAccent,
                child: Text(
                  'Place Order',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                onPressed: () {
                  add_data();
                  Fluttertoast.showToast(
                    msg: "Succesfully Placed The Order",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white,
                  );
                  Navigator.pushReplacementNamed(context, StoreScreen.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
