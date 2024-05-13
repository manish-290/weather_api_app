import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/homeScreen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>  {


@override
void initState(){
  super.initState();
  Timer(Duration(seconds: 5), () { 
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context)=>HomeScreen()));
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://www.vhv.rs/dpng/d/427-4270068_gold-retro-decorative-frame-png-free-download-transparent.png",
            scale: 1.0),fit: BoxFit.cover)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Center(
            child: Text("We show weather for you.",style:TextStyle(
              fontSize:30,fontWeight:FontWeight.bold
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:30.0),
            child: ElevatedButton(
              onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>HomeScreen())),
               child: Text("Skip")),
          ),
      
        ],),
      ),
    );
  }
}