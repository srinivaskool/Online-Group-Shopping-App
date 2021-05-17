import 'package:flash_chat/screens/CartScreen.dart';
import 'package:flash_chat/screens/Checkoutscreen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'screens/store_screen.dart';
import 'screens/AddItems.dart';
import 'screens/OrderScreen.dart';
import 'components/local_notification.dart';
import 'screens/WishlistScreen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: StoreScreen.id,
      title: 'Online Store',
      debugShowCheckedModeBanner: false,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        StoreScreen.id : (context) => StoreScreen(),
        AddItems.id : (context) => AddItems(),
        Cartscreen.id : (context) => Cartscreen(),
        CheckoutScreen.id : (context) => CheckoutScreen(),
        OrderScreen.id : (context) => OrderScreen(),
        LocalNotifications.id : (context) => LocalNotifications(),
        WishListscreen.id : (context) => WishListscreen(),
      },
    );
  }
}
