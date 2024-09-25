import 'package:drivers_app/AllScreens/mainScreen.dart';
import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/AllWidgest/progressDialog.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
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
              "Login as a Rider",
              style: TextStyle(fontSize: 24.0, fontFamily: "BrandBold"),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
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
                  SizedBox(height: 10.0), // Khoảng cách giữa Email và Password
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu",
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
                      if(!emailTextEditingController.text.contains("@")){
                        displayToastMessage("Địa chỉ Email không hợp lệ.", context);
                      }
                      else if(passwordTextEditingController.text.isEmpty ){
                        displayToastMessage("Vui lòng nhập mật khẩu.", context);
                      }
                      else{
                        longinAuthenticateUser(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        "Đăng Nhập",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);
              },
              child: Text(
                "Do not have an Account? Register Here.",
                style: TextStyle(
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void longinAuthenticateUser(BuildContext context) async{
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return ProgressDialog(message: "Đang xác thực, vui lòng đợi...,",);
    }
    );


    User? firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) {
      // Save user info to database

      usersRef.child(firebaseUser.uid).get().then( (DataSnapshot snap){
        if(snap.value != null){
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Đăng nhập thành công", context);
        }
        else{
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Tài khoản bạn không tồn tại. Vui lòng tạo tài khoản mới", context);
        }
      });


    } else {
      Navigator.pop(context);
      displayToastMessage("Đã xảy ra lỗi, không thể đăng nhập !", context);
    }
  }
}