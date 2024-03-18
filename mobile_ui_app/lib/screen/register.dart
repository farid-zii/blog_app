import 'package:flutter/material.dart';
import 'package:mobile_ui_app/constant.dart';
import 'package:mobile_ui_app/model/api_response.dart';
import 'package:mobile_ui_app/model/user.dart';
import 'package:mobile_ui_app/screen/home.dart';
import 'package:mobile_ui_app/screen/login.dart';
import 'package:mobile_ui_app/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmationController = TextEditingController();

  void _registerUser() async {
    ApiResponse resp = await register(
        nameController.text, emailController.text, passwordController.text);
    if (resp.error == null) {
      _savedAndRedirectToHome(resp.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${resp.error}')));
    }
  }

  void _savedAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                validator: (val) => val!.isEmpty ? "Invalid Name" : null,
                decoration: kInputDecoration("Name")),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (val) =>
                    val!.isEmpty ? "Invalid Email Address" : null,
                decoration: kInputDecoration("Email")),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? "Required at least 6 chars" : null,
                decoration: kInputDecoration("Password")),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: passwordConfirmationController,
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? "Required at least 6 chars" : null,
                decoration: kInputDecoration("Password Confirmation")),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : kTextButton("Register", () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = !loading;
                        _registerUser();
                      });
                    }
                  }),
            SizedBox(
              height: 20,
            ),
            kLoginRegisterHint("Already have an account? ", "Login", () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
