import 'package:flutter/material.dart';
import 'package:zd_age_fans/models/home_model.dart';

class CustomTabbarView extends StatefulWidget {
  const CustomTabbarView({super.key, required this.weekList, this.click});

  final List<List<WeekItem>> weekList;
  final void Function(String)? click;

  @override
  State<CustomTabbarView> createState() => _CustomTabbarViewState();
}

class _CustomTabbarViewState extends State<CustomTabbarView> with SingleTickerProviderStateMixin {
  final List<String> tabs = const [
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日",
  ];

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTabBar(),
        Container(
          color: Colors.purpleAccent,
          //width: MediaQuery.of(context).size.width,
          height: 300,
          child: _buildTabBarView(),
        )
      ],
    );
  }

  Widget _buildTabBar() => TabBar(
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        isScrollable: true,
        controller: _tabController,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.yellow,
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
        indicatorColor: Colors.orangeAccent,
        onTap: (index) => debugPrint("点击的tab = $index"),
      );

  Widget _buildTabBarView() => TabBarView(controller: _tabController, children: _buildListViews());

  List<Widget> _buildListViews() {
    if (widget.weekList.isEmpty) {
      return tabs.map((e) => Text(e)).toList();
    }
    return widget.weekList
        .map(
          (e) => ListView.builder(
            itemBuilder: (_, index) => ListTile(
              title: Text(e.length > index ? e[index].name : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
              onTap: () {
                debugPrint("点击了index = $index");
                final cartoonId = e.length > index ? e[index].id.toString() : "";
                widget.click?.call(cartoonId);
              },
            ),
            itemCount: 10,
          ),
        )
        .toList();
  }
}
