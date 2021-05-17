import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/custom_drawer.dart';
import 'package:flash_chat/screens/Checkoutscreen.dart';
import 'package:flash_chat/components/OrderCard.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;
FirebaseUser storeloggedUser;

class OrderScreen extends StatefulWidget {
  static String id = 'order_screen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
          'MY ORDERS',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OrderItemStream(),
        ],
      )),
    );
  }
}

class OrderItemStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final orderitems = snapshot.data.documents.reversed;
        List<OrderItem> listItems = [];
        for (var item in orderitems) {
          if (storeloggedUser.email == item.data['User']) {
            final price = item.data['Price'];
            final name = item.data['Name'];
            final email = item.data['User'];
            final url = item.data['Url'];
            final person = item.data['Person'];
            final hno = item.data['Hno'];
            final doc_id = item.documentID;
            final date_time = item.data['Date_Time'];
            final availabity = item.data['Availability'];
            final ori_doc_id = item.data['ori_doc_id'];
            final singleitem = OrderItem(
              name: name,
              price: price,
              email: email,
              url: url,
              doc_id: doc_id,
              person:person,
              hno:hno,
              date_time:date_time,
                availabity :availabity,
              ori_doc_id:ori_doc_id,
            );
            listItems.add(singleitem);
            listItems.sort( (a,b) => DateTime.parse(b.date_time).compareTo(DateTime.parse(a.date_time)));
          }
        }
        return Expanded(
          child: listItems.isEmpty
              ? Center(
                  child: Text('No Orders Yet.'),
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
