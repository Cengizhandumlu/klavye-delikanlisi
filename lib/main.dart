import 'package:flutter/material.dart';
import 'dart:async';
import 'package:marquee/marquee.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: MyAppHome(),
    );
  }

}

class MyAppHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }

}

class _MyAppHomeState extends State<MyAppHome>{
  String userName="";
  int typedCharlength = 0;
  String lorem = "                                      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      .toLowerCase()
      .replaceAll(',', '')
      .replaceAll('.', '');
  var shownWidget ;

  int step = 0 ;
  int score = 0 ;
  int lastTypedAt ;

  void updateLastTypedAt(){
    this.lastTypedAt =  DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value){
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if(trimmedValue.indexOf(value) != 0){
        step=2;
        }else{
        typedCharlength = value.length;
      }
    });
  }
  void onUserNameType(String value){
    setState(() {
      this.userName=value.substring(0, 3);
    });
  }
  void resetGame(){
    setState(() {
      typedCharlength = 0;
      step = 0;
    });
  }


  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });
    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      //GAME OVER
      setState(() {
        if (step == 1 && now - lastTypedAt > 4000) {
          timer.cancel();
          step++;
        }
        if(step!=1){
          timer.cancel();
        }
      });
      });
  }
  @override
  Widget build(BuildContext context) {
    if( step == 0 )
      shownWidget = <Widget>[
        Text('Oyuna Hoşgeldin, coronodan kacmaya hazir misin ?'),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            onChanged: onUserNameType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ismin nedir klavye delikanlisi ?',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('BASLA !'),
            onPressed: userName.length == 0 ? null : onStartClick,
          ),
        )
      ];

    else if(step==1)
      shownWidget = <Widget>[
        Text('$score'),
        Container(
        margin: EdgeInsets.only(left: 0),
        height: 30,
        child: Marquee(
          text: lorem,
          style: TextStyle(fontSize:20, letterSpacing: 2),
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 20.0,
          velocity: 125,
          startPadding: 0,
          accelerationDuration: Duration(seconds: 20),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
        child: TextField(
          autofocus: true,
          onChanged: onType,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Yaz da görelim',
          ),
        ),
      )
    ];
    else
      shownWidget = <Widget>[
        Text('Coronadan kacamadin, skorun: $typedCharlength'),
        RaisedButton(child: Text('Yeniden dene!'), onPressed: resetGame,)
      ];

    return Scaffold(appBar: AppBar(
      title: Text('Klavye Delikanlısı'),
    ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: shownWidget,
         ),
        )
    );
  }
}
