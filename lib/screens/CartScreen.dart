import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/custom_drawer.dart';
import 'package:flash_chat/components/CartCard.dart';
import 'package:flash_chat/screens/Checkoutscreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;
FirebaseUser storeloggedUser;
int total = 0;
List<CartItem> listItems;

class Cartscreen extends StatefulWidget {
  static String id = 'cart_screen';
  @override
  _CartscreenState createState() => _CartscreenState();
}

class _CartscreenState extends State<Cartscreen> {
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        storeloggedUser = user;
        print(storeloggedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          'CART',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.card_membership,
                  color: Colors.blue,
                  size: 20.0,
                ),
                Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            onPressed: () {
              if (listItems.isEmpty) {
                Fluttertoast.showToast(
                  msg: "Add items to Checkout",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.white,
                );
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: CheckoutScreen()));
                // Navigator.pushNamed(context, CheckoutScreen.id);
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CartItemStream(),
        ],
      )),
    );
  }
}

class CartItemStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('cart').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final cartitems = snapshot.data.documents.reversed;
        listItems = [];
        for (var item in cartitems) {
          if (storeloggedUser.email == item.data['User']) {
            final price = item.data['Price'];
            final name = item.data['Item'];
            final email = item.data['User'];
            final avail = item.data['Availability'];
            final url = item.data['Url'];
            final doc_id = item.documentID;
            final ori_item_doc_id = item.data['ori_item_doc_id'];
            final date_time = item.data['Date_Time'];
            final singleitem = CartItem(
              name: name,
              price: price,
              email: email,
              avail: avail,
              url: url,
              doc_id: doc_id,
              ori_item_doc_id: ori_item_doc_id,
              date_time: date_time,
            );
            listItems.add(singleitem);
            listItems.sort((a, b) => DateTime.parse(b.date_time)
                .compareTo(DateTime.parse(a.date_time)));
          }
        }
        return Expanded(
          child: listItems.isEmpty
              ? Center(
                  child: Text('No items in Cart.'),
                )
              : ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  children: listItems,
                ),
        );
      },
    );
  }
}
