import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/store_screen.dart';
import 'package:flash_chat/screens/AddItems.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/OrderScreen.dart' as Orders;
import 'package:flash_chat/screens/WishlistScreen.dart' as WishList;

final _auth = FirebaseAuth.instance;

class CustomDrawer extends StatelessWidget {
  _buildDrawerOption(Icon icon, String title, Function onTap) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.asset(
                'images/user_background.jpg',
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 20.0,
                left: 20.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: ClipOval(
                        child: Image(
                          image: NetworkImage(storeloggedUser.photoUrl == null
                              ? 'https://cdn1.iconfinder.com/data/icons/zikons/400/--06-512.png'
                              : storeloggedUser.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      storeloggedUser.displayName,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildDrawerOption(
            Icon(Icons.dashboard),
            'Home',
            () {
              Navigator.popAndPushNamed(context, StoreScreen.id);
            },
          ),
          _buildDrawerOption(
            Icon(Icons.chat),
            'Chat',
            () {
              Navigator.popAndPushNamed(context, ChatScreen.id);
            },
          ),
          _buildDrawerOption(
            Icon(Icons.dashboard),
            'WishList',
                () {
                  Navigator.popAndPushNamed(context, WishList.WishListscreen.id);
            },
          ),
          _buildDrawerOption(
            Icon(Icons.business_center),
            'Orders',
            () {
              Navigator.popAndPushNamed(context, Orders.OrderScreen.id);
            },
          ),
          _buildDrawerOption(
            Icon(Icons.add_box),
            'Add Items',
            () {
              Navigator.popAndPushNamed(context, AddItems.id);
            },
          ),
          _buildDrawerOption(Icon(Icons.location_on), 'Map', () {}),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: _buildDrawerOption(
                Icon(Icons.directions_run),
                'Logout',
                () async {
                  await _auth.signOut();
                  Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
