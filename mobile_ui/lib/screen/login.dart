import 'package:flutter/material.dart';
import 'package:mobile_ui/constant.dart';
import 'package:mobile_ui/models/api_response.dart';
import 'package:mobile_ui/models/user.dart';
import 'package:mobile_ui/screen/home.dart';
import 'package:mobile_ui/screen/register.dart';
import 'package:mobile_ui/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final  formkey = GlobalKey<FormState>();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser()async{
    ApiResponse resp = await login(txtemail.text, txtPassword.text);

    if(resp.error == null){
      _savedAndRedirectToHome(resp.data as User);
    }
    else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${resp.error}'),
      ));
    }
  }

  void _savedAndRedirectToHome(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token??'');
    await pref.setInt('userId', user.id??0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding:EdgeInsets.all(32),
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: txtemail,
              // validator:(val)=>val!.isEmpty ? "Invalid email Address":null,
              decoration: kInputDecoration("Email")
            ),

            SizedBox(height: 10,),

            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: txtPassword,
              obscureText: true,
              // validator:(val)=>val!.isEmpty ? "Invalid email Address":null,
              decoration: kInputDecoration("Password")
            ),

            SizedBox(height: 10,),

            kTextButton('Login', (){
              if(formkey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    _loginUser();
                    });
                  }
            }),

            SizedBox(height: 10,),

            kLoginRegisterHint('Dont have an account?','Register',(){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Register()), (route) => false);
            }),    
          ],
        ),
      ),
    );
  }
}