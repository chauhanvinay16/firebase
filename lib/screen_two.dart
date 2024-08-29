import 'package:flutter/material.dart';

class ScreenTwo extends StatelessWidget {
  final Map data;
  const ScreenTwo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Data:${data.toString()}',textScaleFactor: 2,),
      )
    );
  }
}
