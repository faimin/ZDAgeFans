import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zd_age_fans/models/home_model.dart';
import 'package:zd_age_fans/providers/home_provider.dart';
import 'package:zd_age_fans/widgets/cartoon_detail_page.dart';
import 'package:zd_age_fans/widgets/custom_tabbar_view.dart';

final homeProvider =
    StateNotifierProvider<HomeNotifier, HomeModel>((ref) => HomeNotifier());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeModel = ref.watch(homeProvider);
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
            weekModel.sunday
          ],
          click: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CartoonDetailPage(),
                    settings: const RouteSettings(name: '首页')));
          });
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
            childAspectRatio: 0.8),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: CachedNetworkImage(imageUrl: itemList[index].picSmall),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CartoonDetailPage(),
                      settings: const RouteSettings(name: '首页')));
            },
          );
        });
  }
}
