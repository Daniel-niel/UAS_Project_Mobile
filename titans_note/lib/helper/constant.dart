import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


const TextDecos = InputDecoration(
  filled: true,
  fillColor: Color.fromRGBO(255, 255, 255, 0.3),
  focusColor: Color.fromRGBO(211, 211, 211, 1.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
);
