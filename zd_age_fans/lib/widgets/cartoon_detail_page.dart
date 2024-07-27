import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zd_age_fans/common/mock_data.dart';
import 'package:zd_age_fans/models/detail_model.dart';
import 'package:zd_age_fans/providers/detail_provider.dart';
import 'package:zd_age_fans/widgets/custom_tabbar_view.dart';
import 'package:zd_age_fans/widgets/video_player_page.dart';

final detailProvider = StateNotifierProvider<DetailNotifier, DetailModel>(
    (ref) => DetailNotifier());

class CartoonDetailPage extends ConsumerStatefulWidget {
  const CartoonDetailPage({super.key, required this.cartoonId});

  final String cartoonId;

  @override
  ConsumerState<CartoonDetailPage> createState() => _CartoonDetailPageState();
}

class _CartoonDetailPageState extends ConsumerState<CartoonDetailPage> {
  static final m3u8URL = m3u8List.last;

  @override
  void initState() {
    super.initState();
    ref.read(detailProvider.notifier).fetchData(widget.cartoonId);
  }

  @override
  Widget build(BuildContext context) {
    final detailModel = ref.watch(detailProvider);

    return Container(
      color: Colors.purple,
      child: CustomScrollView(slivers: [
        const SliverAppBar(
          pinned: true,
          expandedHeight: 64,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            '动漫详情',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pink,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return _buildTopWidget(detailModel.video);
            } else {
              return Material(
                color: Colors.red,
                child: CustomTabbarView(
                  weekList: const [],
                  click: (String cartoonId) {
                    debugPrint('跳转到视频播放页 => cartoon_id: $cartoonId');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerPage(videoUrl: m3u8URL),
                        settings: const RouteSettings(name: '视频播放页'),
                      ),
                    );
                  },
                ),
              );
            }
          }, childCount: 2),
        )
      ]),
    );
  }

  static const imageHeight = 200.0;
  Widget _buildTopWidget(Video? videoModel) => Container(
        color: Colors.cyan,
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl:
                  videoModel?.cover ?? 'https://www.baidu.com/img/bd_logo1.png',
              height: imageHeight,
              width: imageHeight * 0.75,
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  videoModel?.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
                Text(
                  videoModel?.writer ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  videoModel?.uptodate ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  videoModel?.plot ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      );
}
