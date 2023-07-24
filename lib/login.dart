import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samdriya/InputBox.dart';
import 'package:samdriya/SplashScreen.dart';
import 'package:samdriya/constant.dart';
import 'package:samdriya/vehicleCheckIn.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var passworderror;

  var nameerror;

  void _setKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', key);
    print('set key');
  }

  Map loginData = Map();

  var _error;
  String newuserPassword = '';
  String? newusername;


  Future Login(login, password) async {
    try {
      var headers = {
        'x-access-token': '$globalusertoken',
        'Cookie': 'ci_session=f1c53e209a734c2472ebf565bb0834c8b8894dc7'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://smalljbp.loopdevelopers.in/v1/account/login'));
      request.fields.addAll({
        'username': login,
        'password': password
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print('api called');

      var data = await response.stream.bytesToString();
      loginData = jsonDecode(data);
      if (response.statusCode == 200) {
        if (loginData['status'] == 1) {
          print(loginData);
          _setKey(loginData['data']['token']);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CheckINOut(),
              ));
        } else {
          _error = loginData['message'];
        }

        print(loginData);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key:  formkey,
            child: Container(
              margin: EdgeInsets.only(top: 80, right: 40, left: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image(
                      image: AssetImage(
                        "assets/logo.png",
                      ),
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SimpleInputBox(
                      controller: userController,
                      hintText: "Enter Username",
                      textInputType: TextInputType.name, message: 'Invalid', length: 30,),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          initialValue: newusername,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              setState(() {
                                nameerror = "Name can't be empty";
                              });
                            } else if (value!.length < 3) {
                              setState(() {
                                nameerror = "Too short name";
                              });
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              nameerror = null;
                              newusername = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Name',
                          ),
                        ),
                      )),
                  if (nameerror != null)
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 3, bottom: 10.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width -
                                        100,
                                    child: Text(
                                      "$nameerror",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          initialValue: newuserPassword,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              setState(() {
                                passworderror = "Enter a valid password";
                              });
                            }
                            if (value!.length < 8) {
                              passworderror =
                              "password should be 8 character";
                            }
                          },
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              newuserPassword = value;
                              passworderror = null;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                          ),
                        ),
                      )),
                  if (passworderror != null)
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 3, bottom: 10.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width -
                                        100,
                                    child: Text(
                                      "$passworderror",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  SimpleInputBox(
                      controller: passwordController,
                      hintText: "Enter Password",
                      textInputType: TextInputType.visiblePassword, message: 'Invalid Password', length: 8,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(32),
                          backgroundColor: ThemeColorBlue,
                          padding: EdgeInsets.symmetric(vertical: 5)),
                      onPressed: () {


                      //  if (formkey.currentState!.validate()) {}
                        if (nameerror == null &&

                            passworderror == null
                             ){
                          Login(userController.text.toString(),
                              passwordController.text.toString());

                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width - 100,
                      child: _error != null
                          ? Text(
                              "$_error",
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
