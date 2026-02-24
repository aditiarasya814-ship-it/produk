import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 99, 177, 176),
          title: Text('Projek Sawit'),
        ),
        body: Center(child: Text("Halo Saya Bos Sawit"))),
    )
  );
}