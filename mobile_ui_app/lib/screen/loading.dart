import 'package:flutter/material.dart';
import 'package:mobile_ui_app/constant.dart';
import 'package:mobile_ui_app/model/api_response.dart';
import 'package:mobile_ui_app/service/user_service.dart';
import 'package:mobile_ui_app/screen/home.dart';
import 'package:mobile_ui_app/screen/login.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadingUserInfo() async {
    String token = await getToken();

    if (token == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      ApiResponse resp = await getUserDetail();
      if (resp.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else if (resp.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${resp.error}'),
        ));
      }
    }
  }

  @override
  void initState() {
    _loadingUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
