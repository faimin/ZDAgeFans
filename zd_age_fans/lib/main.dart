import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flukit/flukit.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'widgets/home_page.dart';
import 'package:rinf/rinf.dart';

void main() async {
  await Rinf.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'AgeFans'),
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  Map<int, Widget> pages = {
    0: const KeepAliveWrapper(child: HomePage(pageIndex: 0))
  };

  bool _isClick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.purple,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.recommend, size: 30),
          Icon(Icons.more, size: 30),
        ],
        onTap: (index) {
          if (_isClick) {
            return;
          }
          debugPrint("点击了index = $index");
          _isClick = true;
          // _pageController.animateToPage(index,
          //     duration: const Duration(milliseconds: 250),
          //     curve: Curves.linear);
          _pageController.jumpToPage(index);
          Timer(const Duration(milliseconds: 250), () {
            _isClick = false;
          });
        },
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemBuilder: (context, index) {
            Widget? view = pages[index];
            if (view == null) {
              if (index == 0 || index == 1) {
                view = KeepAliveWrapper(child: HomePage(pageIndex: index));
              } else {
                view = KeepAliveWrapper(
                  child: Container(
                    color: Colors.red,
                  ),
                );
              }
              pages[index] = view;
            }
            return view;
          },
          onPageChanged: (index) {
            if (_isClick) {
              return;
            }
            final CurvedNavigationBarState? navBarState =
                _bottomNavigationKey.currentState;
            navBarState?.setPage(index);
          },
        ),
      ),
    );
  }
}
