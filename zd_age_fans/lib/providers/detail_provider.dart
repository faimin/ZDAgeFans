import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:zd_age_fans/common/http.dart';
import '../models/detail_model.dart';

final detailSignal = signal<DetailModel>(
  DetailModel(
    video: null,
    series: [],
    similar: [],
    playerLabelArr: null,
    playerVip: '',
    playerJx: PlayerJx(vip: "", zj: ""),
  ),
);

void fetchDetailData(String cartoonId) async {
  final cancel = BotToast.showLoading();
  if (cartoonId.isEmpty) {
    debugPrint('cartoonId is null');
    cancel();
    return;
  }
  final response = await HttpClient.get('/v2/detail/$cartoonId');
  try {
    final data = DetailModel.fromJson(response.data as Map<String, dynamic>);
    detailSignal.value = data;
  } catch (e) {
    debugPrint('error: $e');
  } finally {
    cancel();
  }
}
