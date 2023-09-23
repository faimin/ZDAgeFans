import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:zd_age_fans/common/http.dart';

import '../models/detail_model.dart';

class DetailNotifier extends StateNotifier<DetailModel> {
  DetailNotifier()
      : super(DetailModel(
            video: null,
            series: [],
            similar: [],
            playerLabelArr: null,
            playerVip: '',
            playerJx: PlayerJx(vip: "", zj: "")));

  void fetchData(String cartoonId) async {
    final cancel = BotToast.showLoading();
    if (cartoonId.isEmpty) {
      debugPrint('cartoonId is null');
      return;
    }
    final response = await HttpClient.get('/v2/detail/$cartoonId');
    final data = DetailModel.fromJson(response.data as Map<String, dynamic>);
    state = data;
    cancel();
  }
}
