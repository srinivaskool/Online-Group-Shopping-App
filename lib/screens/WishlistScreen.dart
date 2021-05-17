import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/custom_drawer.dart';
import 'package:flash_chat/components/WishListCard.dart';
import 'package:flash_chat/screens/Checkoutscreen.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;
FirebaseUser storeloggedUser;
int total = 0;

class WishListscreen extends StatefulWidget {
  static String id = 'WishList_screen';
  @override
  _WishListscreenState createState() => _WishListscreenState();
}

class _WishListscreenState extends State<WishListscreen> {
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
          'WISHLIST',
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
              WishListItemStream(),
            ],
          )),
    );
  }
}

class WishListItemStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('wishlist').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final WishListitems = snapshot.data.documents.reversed;
        List<WishListItem> listItems = [];
        for (var item in WishListitems) {
          if (storeloggedUser.email == item.data['User']) {
            final price = item.data['Price'];
            final name = item.data['Name'];
            final email = item.data['User'];
            final avail = item.data['Availability'];
            final url = item.data['Url'];
            final doc_id = item.documentID;
            final ori_item_doc_id = item.data['ori_item_doc_id'];
            final date_time = item.data['Date_Time'];
            final singleitem = WishListItem(
              name: name,
              price: price,
              email: email,
              avail: avail,
              url: url,
              doc_id: doc_id,
              ori_item_doc_id: ori_item_doc_id,
              date_time:date_time,
            );
            listItems.add(singleitem);
            listItems.sort( (a,b) => DateTime.parse(b.date_time).compareTo(DateTime.parse(a.date_time)));
          }
        }
        return Expanded(
          child: listItems.isEmpty
              ? Center(
            child: Text('No items in WishList.'),
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
