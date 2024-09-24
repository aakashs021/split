import 'package:flutter/material.dart';

Text floatingActionButtontext(String data,Color color,double fontsize){
  return Text(data,style: TextStyle(color: color,fontSize: fontsize),);
}

Text loginpageSubmitbutton({required String data}){
  return Text(data,style: TextStyle(color: Colors.white),);
}