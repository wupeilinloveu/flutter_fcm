import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:flutter_fcm/common/Mian_nav.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Fcm',
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Fcm推送
  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();

  //底部导航
  int index = 0;
  bool _clickBadge = false;
  var _countBadge = ""; //初始化未读条数
  List<BottomNavigationBarItem> items;

  //自定义badger的样式
  BottomNavigationBadge badger = new BottomNavigationBadge(
      backgroundColor: Colors.red,
      badgeShape: BottomNavigationBadgeShape.circle,
      textColor: Colors.white,
      position: BottomNavigationBadgePosition.topRight,
      textSize: 8);

  @override
  void initState() {
    super.initState();
    _fireBaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _fireBaseMessaging.getToken().then((token) {
      if (token != null) {
        _postFcm(token);
      }
    });
    _fireBaseMessaging.configure(onMessage: (Map message) {
      return _handleMessage(message);
    }, onLaunch: (Map message) {
      return _handleMessage(message);
    }, onResume: (Map message) {
      return _handleMessage(message);
    });
  }

  _handleMessage(Map message) {
    setState(() {
      var data = message["data"];
      _countBadge = data["count"]; //获取未读条数,接口的自定义字段
    });
  }

  //进入主界面，通知后台fcm的接口
  Future _postFcm(String token) async {
    String url = "/token"; //接口的URL
    var data = {"token": token};
    try {
      Response response = await Dio().post(url, data: data);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = List.generate(pages.length, (i) {
      final nav = pages[i];
      return BottomNavigationBarItem(
          icon: i == index ? nav['icon2'] : nav['icon'],
          title: i == index ? nav['title2'] : nav['title']);
    }).toList();

    setState(() {
      if (_clickBadge == false && _countBadge.length != 0) {
        //根据条件，动态添加badge
        badger.setBadge(items, _countBadge, 1);
      }
    });

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFF384F6F),
        centerTitle: true,
        title: new Text(tabTitle[index]),
        iconTheme: new IconThemeData(color: Color(0xFF384F6F)),
        actions: <Widget>[
          IconButton(
            icon: Image.asset("images/title_right_icon.png",
                width: 30.0, height: 30.0),
            padding: new EdgeInsets.all(10.0),
            onPressed: null,
          )
        ],
      ),
      body: new Text(tabTitle[index]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF384F6F),
        items: items,
        currentIndex: index,
        onTap: _change,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  _change(int i) {
    setState(() {
      index = i;
      if (i == 1) {
        //Setting
        if (_countBadge.length != 0) {
          items = badger.removeBadge(items, i); //点击相应的底部导航，移除badge
          _clickBadge = true;
        }
      }
    });
  }
}
