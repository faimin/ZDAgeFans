import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartoonDetailPage extends StatefulWidget {
  const CartoonDetailPage({super.key});

  @override
  State<CartoonDetailPage> createState() => _CartoonDetailPageState();
}

class _CartoonDetailPageState extends State<CartoonDetailPage> {
  @override
  Widget build(BuildContext context) {
    const _imageHeight = 200.0;
    return Container(
        color: Colors.purple,
        child: CustomScrollView(slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 64,
            title: Text('动漫详情'),
            backgroundColor: Colors.pink,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              color: Colors.cyan,
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                CachedNetworkImage(
                  imageUrl: 'https://cdn.aqdstatic.com:966/age/20220118.jpg',
                  height: _imageHeight,
                  width: _imageHeight * 0.75,
                ),
                const SizedBox(width: 15),
                const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("游戏王",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                          maxLines: 1),
                      Text("动漫",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      Text("时间",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      Text("剧情类型",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ]),
              ]),
            );
          }, childCount: 1))
        ]));
  }
}
