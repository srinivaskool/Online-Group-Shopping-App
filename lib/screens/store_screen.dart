import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/custom_drawer.dart';
import 'package:flash_chat/components/following_users.dart';
import 'package:flash_chat/data/data.dart';
import 'package:flash_chat/components/offers_carousel.dart';
import 'CartScreen.dart';
import 'package:flash_chat/components/StoreCard.dart';
import 'welcome_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;
FirebaseUser storeloggedUser;
int _currentIndex = 0;

class StoreScreen extends StatefulWidget {
  static const String id = 'store_screen';
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setState(() {
      _currentIndex = 0;
    });
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    _tabController.addListener(_handleTabSelection);
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        storeloggedUser = user;
        print(storeloggedUser.email);
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        print('going back');
      }
    } catch (e) {
      print(e);
    }
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
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
          'ONLINE STORE',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                //Navigator.pushNamed(context, Cartscreen.id);
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: Cartscreen()));
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.blue,
                    size: 20.0,
                  ),
                  Text(
                    'Cart',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              )),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3.0,
          labelColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 18.0,
          ),
          tabs: <Widget>[
            Tab(text: 'Deals'),
            Tab(text: 'Men'),
            Tab(text: 'Women'),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GenderSelecter(),
        ],
      )),
    );
  }

  GenderSelecter() {
    if (_currentIndex == 0) {
      return Container(
        child: Column(
          children: <Widget>[
            FollowingUsers(),
            OffersCarousel(
              pageController: _pageController,
              title: 'Offers',
              offers: offers,
            ),
          ],
        ),
      );
    }
    if (_currentIndex == 1) {
      return StoreItemStream('Men');
    } else {
      return StoreItemStream('Women');
    }
  }
}

class StoreItemStream extends StatefulWidget {
  String gender;
  StoreItemStream(String gen) {
    gender = gen;
  }

  @override
  _StoreItemStreamState createState() => _StoreItemStreamState();
}

class _StoreItemStreamState extends State<StoreItemStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final allitems = snapshot.data.documents.reversed;
        List<StoreItem> listItems = [];
        for (var item in allitems) {
          if (widget.gender == item.data['Category'] ||
              item.data['Category'] == 'All') {
            final price = item.data['Price'];
            final availbity = item.data['Available'];
            final color = item.data['Color'];
            final name = item.data['Name'];
            final url = item.data['Url'];
            final category = item.data['Category'];
            final ori_item_doc_id = item.documentID;
            final singleitem = StoreItem(
                name: name,
                price: price,
                color: color,
                availbity: availbity,
                url: url,
                category: category,
                email: storeloggedUser.email,
                ori_item_doc_id: ori_item_doc_id);
            listItems.add(singleitem);
          }
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: listItems,
          ),
        );
      },
    );
  }
}
