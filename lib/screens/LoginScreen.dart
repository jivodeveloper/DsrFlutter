import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/logindetails.dart';
import 'package:promoterapp/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LoginScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen>{

  TextEditingController usercontroller = new TextEditingController();
  TextEditingController passcontroller = new TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child:Scaffold(
          body: ProgressHUD(
              child:Builder(
                builder: (context) => Scaffold(
                    body:Container(
                      color: Colors.white,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                    'assets/Images/logo.png', height: 150)
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child:Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Proceed with your", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF063A06),
                                        fontSize: 20,
                                      ),
                                      )
                                  ),
                                ),

                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "LOGIN", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF063A06),
                                      fontSize: 30,
                                    ),
                                    )
                                )
                              ],
                            ),

                          ),

                          Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                    margin:EdgeInsets.fromLTRB(10,20,10,10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFEFE4E4))
                                    ),
                                    child: TextFormField(
                                      controller: usercontroller,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock,
                                            color: Color(0xFF063A06),),
                                          hintText:'username'
                                      ),
                                    ),
                                  ),

                                  Container(

                                    margin:EdgeInsets.fromLTRB(10,10,10,10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFEFE4E4))
                                    ),
                                    child: TextFormField(
                                      controller: passcontroller,
                                      obscureText:_obscureText,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.password,
                                          color: Color(0xFF063A06),),
                                        hintText: 'password',
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          child: Icon(
                                            _obscureText ? Icons.visibility : Icons.visibility_off,
                                            semanticLabel:
                                            _obscureText ? 'show password' : 'hide password',
                                            color:Color(0xFF063A06),
                                          ),
                                        ),
                                      ),

                                    ),
                                  )

                                ],
                              )
                          ),

                          GestureDetector(

                            onTap: (){
                              final progress  = ProgressHUD.of(context);
                              progress?.show();

                              login(progress);
                              //
                              // progress?.dismiss();
                            },

                            child: Container(
                              margin: EdgeInsets.only(left:10,top:40,right:10,bottom: 10),
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Color(0xFF063A06),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),

                              child: Center(
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                          )

                        ],

                      ),
                    )
                ),
              )
          ),
        ),
        onWillPop: () async{
          return false;
        }
    );
  }

  void logout() async{
    return showDialog(
        context: context,
        builder:(BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure?'),
            actions: <Widget>[

              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('No'),
              ),

              TextButton(
                onPressed: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()));
                },
                child: const Text('Yes'),
              ),

            ],
          );
        }
    );
  }

  Future<logindetails> login(progress) async{

    logindetails details;
    SharedPreferences prefs= await SharedPreferences.getInstance();
    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse('${Common.IP_URL}LoginSalesPerson?user=${usercontroller.text}&password=${passcontroller.text}'), headers: headers);
    details = logindetails.fromJson(json.decode(response.body));

    try {

      if (response.statusCode == 200) {

        details = logindetails.fromJson(json.decode(response.body));

        if(details.personId!=0){

          try{

            prefs.setInt(Common.USER_ID, details.personId);
            prefs.setString(Common.PERSON_TYPE, details.personType);
            prefs.setString(Common.PERSON_NAME, details.personName);
            prefs.setString(Common.GROUP, details.group);

          }catch (e){

            print("distanceallowed$e");

          }

          Fluttertoast.showToast(msg: "Successfully login ${details.personName}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(personName: details.personName)));

        }else{

          Fluttertoast.showToast(msg: "Please check your userid and password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);

        }

      }else{

        Fluttertoast.showToast(msg: "Please check your credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      }

    } catch (e) {

      Fluttertoast.showToast(msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    Fluttertoast.showToast(msg: "valueofdata",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    progress?.dismiss();

    return details;
  }



}