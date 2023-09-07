import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zd_age_fans/common/http.dart';
import 'package:zd_age_fans/models/home_data.dart';
import 'package:zd_age_fans/widgets/cartoon_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<CartoonItem> itemList = [];

  bool _disposed = false;

  Future<HomeDataSource> parseData(Map<String, dynamic> json) async {
    return HomeDataSource.fromJson(json);
  }

  void fetchData() async {
    final response = await HttpClient.get('/v2/home-list', queryParameters: {
      "page": "1",
      "size": "50",
    });
    // return compute(parseData, response);

    final data = await parseData(response.data as Map<String, dynamic>);
    if (!_disposed) {
      setState(() {
        itemList = widget.pageIndex == 0 ? data.latest : data.recommend;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
