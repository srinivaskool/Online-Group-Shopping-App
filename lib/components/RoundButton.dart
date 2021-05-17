import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  final Color colour;
  final IconData icon;
  final String text;
  final Function onpressed;
  RoundButton({this.colour,this.icon,this.text,this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon,color: Colors.white,),
              SizedBox(width: 10.0,),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}