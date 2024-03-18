// -----------STR----------

import 'package:flutter/material.dart';

const String baseURL = "http://192.168.0.123:8000/api";
const String loginURL = baseURL + "/login";
const registerURL = baseURL + "/register";
const logoutURL = baseURL + "/logout";
const userURL = baseURL + "/user";
const postURL = baseURL + "/post";
const commentsURL = baseURL + "/comments";

// ---------- ERROR --------

const serveError = "Server Error";
const unauthorized = "Unauthorized";
const somethingWentWrong = "Something Went wrong, try Again";

// ----- Input Decoration ----

InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10))),
  );
}

//Login Register Hint

Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () => onTap(),
      )
    ],
  );
}
