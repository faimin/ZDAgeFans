import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zd_age_fans/models/home_model.dart';
import 'package:zd_age_fans/providers/home_provider.dart';
import 'package:zd_age_fans/widgets/cartoon_detail_page.dart';
import 'package:zd_age_fans/widgets/custom_tabbar_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = homeSignal.watch(context);
    if (widget.pageIndex == 0) {
      final weekModel = homeModel.weekList;
      return CustomTabbarView(
        weekList: <List<WeekItem>>[
          weekModel.monday,
          weekModel.tuesday,
          weekModel.wednesday,
          weekModel.thursday,
          weekModel.friday,
          weekModel.saturday,
          weekModel.sunday,
        ],
        click: (cartoonId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartoonDetailPage(cartoonId: cartoonId),
              settings: const RouteSettings(name: '首页'),
            ),
          );
        },
      );
    } else {
      return _buildRecommendPage(homeModel.recommend);
    }
  }

  Widget _buildRecommendPage(List<CartoonItem> itemList) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: CachedNetworkImage(imageUrl: itemList[index].picSmall),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartoonDetailPage(cartoonId: "${itemList[index].id}"),
                  settings: const RouteSettings(name: '首页'),
                ),
              );
            },
          );
        });
  }
}
