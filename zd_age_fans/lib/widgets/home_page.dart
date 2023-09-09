import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zd_age_fans/models/home_data.dart';
import 'package:zd_age_fans/providers/home_provider.dart';
import 'package:zd_age_fans/widgets/cartoon_detail_page.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeDataSource>(
    (ref) => HomeNotifier());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeProvider);
    final List<CartoonItem> itemList;
    if (widget.pageIndex == 0) {
      itemList = homeData.latest;
    } else {
      itemList = homeData.recommend;
    }

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
