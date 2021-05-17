import 'package:flash_chat/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_chat/screens/OrderScreen.dart';
import 'package:flash_chat/components/AddressItem.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;
FirebaseUser storeloggedUser;
int total = 0;

class CheckoutScreen extends StatefulWidget {
  static String id = "checkout_sreen";
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getTotal();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Hi ' + storeloggedUser.displayName,
        'Succesfully Placed The Order.',
        notificationDetails);
  }

  Future onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      debugPrint('notification payload: ' + payLoad);
    }
    await Navigator.pushNamed(context, OrderScreen.id);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
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

  void add_data() async {
    _firestore.collection('address').add({
      'Pin_Code': int.parse(pinController.text),
      'Hno': hnoController.text,
      'Street': streetController.text,
      'City': cityController.text,
      'User': storeloggedUser.email,
      'Name': nameController.text,
    });

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
          'Person': nameController.text,
          'Hno': hnoController.text,
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

  void getTotal() async {
    int tot = 0;
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("cart").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.data['User'] == storeloggedUser.email && a.data['Availability'] > 0) {
        tot = tot + a.data['Price'];
        print(a.data['Price']);
      }
      setState(() {
        total = tot;
      });
    }
  }

  TextEditingController nameController = new TextEditingController();

  TextEditingController hnoController = new TextEditingController();

  TextEditingController streetController = new TextEditingController();

  TextEditingController cityController = new TextEditingController();

  TextEditingController pinController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    initializing();
  }

  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF757575),
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30.0),
            ),
            color: Colors.white,
          ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    decoration: kinputDecoration.copyWith(hintText: 'Enter Name'),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  TextField(
                    controller: hnoController,
                    textAlign: TextAlign.center,
                    decoration: kinputDecoration.copyWith(
                        hintText: 'Enter Flat, Houseno'),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  TextField(
                    controller: streetController,
                    textAlign: TextAlign.center,
                    decoration: kinputDecoration.copyWith(
                        hintText: 'Enter Street Details'),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  TextField(
                    controller: cityController,
                    textAlign: TextAlign.center,
                    decoration: kinputDecoration.copyWith(hintText: 'Enter City'),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration:
                        kinputDecoration.copyWith(hintText: 'Enter Pincode'),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  FlatButton(
                    color: Colors.blueAccent,
                    child: Text(
                      'PLACE ORDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    onPressed: () {
                      //openCheckout();
                      _showNotifications();
                      add_data();
                      Fluttertoast.showToast(
                        msg: "Succesfully Placed The Order",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StoreScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
    );
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
          'CHECKOUT',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Total Amount : ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    total.toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            AddressItemStream(),
            FlatButton(
                color: Colors.blueAccent,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: buildBottomSheet);
                },
                child: Text('Add new address')),
          ],
        ),
      ),
    );
  }
}

class AddressItemStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('address').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final Addressitems = snapshot.data.documents.reversed;
        List<AddressItem> listItems = [];
        for (var item in Addressitems) {
          if (storeloggedUser.email == item.data['User']) {
            final name = item.data['Name'];
            final city = item.data['City'];
            final hno = item.data['Hno'];
            final pin = item.data['Pin_Code'];
            final street = item.data['Street'];

            final singleitem = AddressItem(
              name: name,
              city: city,
              hno: hno,
              pin: pin,
              street: street,
            );
            listItems.add(singleitem);
          }
        }
        return Expanded(
          child: listItems.isEmpty
              ? Center(
                  child: Text('No stored Addresses.'),
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
