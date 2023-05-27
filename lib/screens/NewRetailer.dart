import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewRetailer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return NewRetailerState();
  }

}

class NewRetailerState extends State<NewRetailer>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("New Outlet",
              style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
      ),
      body: Column(
        children: [
          TextFormField(
                decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Name'
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Address'
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Pin Code'
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Owner'
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'mobile'
            ),
          ),
        ],
      ),

    );
  }

}