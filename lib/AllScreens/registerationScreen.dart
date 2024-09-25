import 'package:drivers_app/AllScreens/loginScreen.dart';
import 'package:drivers_app/AllScreens/mainScreen.dart';
import 'package:drivers_app/AllWidgest/progressDialog.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20.0), // Giảm khoảng cách từ trên cùng
            Image(
              image: AssetImage("images/logo.png"),
              width: 390.0,
              height: 250.0,
              alignment: Alignment.center,
            ),
            SizedBox(height: 20.0), // Khoảng cách giữa logo và tiêu đề
            Text(
              "Register as a Rider",
              style: TextStyle(fontSize: 24.0, fontFamily: "BrandBold"),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 10.0), // Khoảng cách giữa tiêu đề và Email
                  TextField(
                    controller: nameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Họ và tên",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),

                  SizedBox(height: 10.0), // Khoảng cách giữa tiêu đề và Email
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Roboto',
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 10.0), // Khoảng cách giữa tiêu đề và Email
                  TextField(
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Số điện thoại",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Roboto',
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),

                  SizedBox(height: 10.0), // Khoảng cách giữa Email và Password
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Mật Khẩu",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Roboto',
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 20.0), // Khoảng cách giữa Password và nút Login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if(nameTextEditingController.text.length < 3){
                        displayToastMessage("name must be atleast 3 Characters", context);
                      }
                      else if(!emailTextEditingController.text.contains("@")){
                        displayToastMessage("Email address is not Valid.", context);
                      }
                      else if(phoneTextEditingController.text.isEmpty ){
                        displayToastMessage("Phone address is not Valid.", context);
                      }
                      else if(passwordTextEditingController.text.length < 6 ){
                        displayToastMessage("Password must be atleast 6 characters.", context);
                      }
                      else{
                        registerNewUse(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "BrandBold",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              },
              child: Text(
                "Bạn đã có tài khoản? Đăng nhập.",
                style: TextStyle(
                  fontFamily: "BrandBold",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUse(BuildContext context) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Đang đăng ký, Vui lòng đợi...,",);
        }
    );
    User? firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;


    if (firebaseUser != null) {
      // Save user info to database
      usersRef.child(firebaseUser.uid);

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Xin chúc mừng, tài khoản của bạn đã được tạo", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      displayToastMessage("Tài khoản người dùng mới chưa được tạo", context);
    }

  }
}
displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}