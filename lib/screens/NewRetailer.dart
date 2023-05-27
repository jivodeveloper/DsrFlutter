import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewRetailer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return NewRetailerState();
  }

}

class NewRetailerState extends State<NewRetailer>{

  List<String> shoptype= ["Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];
  String dropdownValue ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("New Outlet",
              style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color:Color(0xFF063A06)),
      ),
      body: Column(
        children: [

        Container(
           width:double.infinity,
           height: 50,
           padding:EdgeInsets.all(7),
           decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Color(0xFFD2C7C7))
           ),
           child:DropdownButton<String>(
              value: shoptype.first,

              elevation: 16,
              style: const TextStyle(color: Color(0xFF063A06)),
                underline: Container(
                height: 2,
                color: Color(0xFF063A06),
              ),
              onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
            dropdownValue = value!;
            });
          },
              items: shoptype.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
            );
           }).toList(),
             ),
            ),

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