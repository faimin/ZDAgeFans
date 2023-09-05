import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zd_age_fans/common/http.dart';
import 'package:zd_age_fans/models/home_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CartoonItem> itemList = [];

  Future<HomeDataSource> parseData(Map<String, dynamic> json) async {
    //final json = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return HomeDataSource.fromJson(json);
  }

  void fetchData() async {
    final response = await HttpClient.get('/v2/home-list', queryParameters: {
      "page": "1",
      "size": "50",
    });
    //debugPrint("response = $response");
    // return compute(parseData, response);

    final data = await parseData(response.data as Map<String, dynamic>);
    setState(() {
      itemList = widget.pageIndex == 0 ? data.latest : data.recommend;
    });
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
              debugPrint('点击图片了 = $index');
              //TODO: 跳转页面
            },
          );
        });
  }
}
