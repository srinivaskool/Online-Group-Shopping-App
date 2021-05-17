import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flash_chat/components/curve_clipper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'store_screen.dart';
import 'package:flash_chat/constants.dart';

final _firestore = Firestore.instance;

class AddItems extends StatefulWidget {
  static String id = 'add_screen';
  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  File sampleImage;
  String url;
  String category='All';

  final formKey = new GlobalKey<FormState>();

  TextEditingController priceController = new TextEditingController();

  TextEditingController availController = new TextEditingController();

  TextEditingController colorController = new TextEditingController();

  TextEditingController nameController = new TextEditingController();



  Future getImage() async {
    var tempimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempimage;
      print(sampleImage);
    });
  }

  void uploadimage() async {
    final StorageReference postImageRef =
        FirebaseStorage.instance.ref().child("Store Images");
    var timeKey = new DateTime.now();
    final StorageUploadTask uploadTask =
        postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
    var imgurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = imgurl.toString();

    _firestore.collection('store').add({
      'Available': int.parse(availController.text),
      'Color': colorController.text,
      'Name': nameController.text,
      'Price': int.parse(priceController.text),
      'Category': category,
      'Url': url,
    });

    Fluttertoast.showToast(
      msg: "Successfully Submitted The Product",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
    );

    Navigator.pushReplacementNamed(context, StoreScreen.id);
  }

  List<String> categories = ['All','Men', 'Women'];
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String cat in categories) {
      var newItem = DropdownMenuItem(
        child: Text(cat),
        value: cat,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: category,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          category = value;
        });
      },
    );
  }

  Widget enableUpload() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Store'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            child: new Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.file(sampleImage, height: 200.0, width: 250.0),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: nameController,
                      textAlign: TextAlign.center,
                      decoration: kinputDecoration.copyWith(hintText: 'Enter Name'),
                    ),
                    SizedBox(height: 8.0,),
                    TextField(
                      controller: colorController,
                      textAlign: TextAlign.center,
                      decoration: kinputDecoration.copyWith(hintText: 'Enter color'),
                    ),
                    SizedBox(height: 8.0,),
                    TextField(
                      controller: priceController,
                      textAlign: TextAlign.center,
                      decoration: kinputDecoration.copyWith(hintText: 'Enter price'),
                    ),
                    SizedBox(height: 8.0,),
                    TextField(
                      controller: availController,
                      textAlign: TextAlign.center,
                      decoration:
                          kinputDecoration.copyWith(hintText: 'Enter availability'),
                    ),
                    SizedBox(height: 8.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Select Category'),
                        SizedBox(width: 6.0,),
                        androidDropdown(),
                      ],
                    ),
                    FlatButton(
                      color: Colors.blueAccent,
                      child: Text('Submit',style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        uploadimage();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget beforeUpload() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Online Store'),
        ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              ClipPath(
                clipper: CurveClipper(),
                child: Image(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2.5,
                  width: double.infinity,
                  image: AssetImage('images/login_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                    'A text editor is a type of computer program that edits plain text. Such programs are sometimes known as software, following the naming of Microsoft Notepad.Text editors are provided',
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w300)),
              ),
              SizedBox(height: 10.0),
              FlatButton(
                color: Colors.blueAccent,
                child: Text(
                  'Add Product', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  getImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return sampleImage == null ? beforeUpload() : enableUpload();
  }
}
