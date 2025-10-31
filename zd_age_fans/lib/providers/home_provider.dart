import 'package:signals/signals.dart';
import 'package:zd_age_fans/common/http.dart';
import 'package:zd_age_fans/models/home_model.dart';
import 'package:bot_toast/bot_toast.dart';

final homeSignal = signal<HomeModel>(
  HomeModel(
    latest: [],
    recommend: [],
    weekList: WeekList(
      monday: [],
      tuesday: [],
      wednesday: [],
      thursday: [],
      friday: [],
      saturday: [],
      sunday: [],
    ),
  ),
);

void fetchHomeData() async {
  final cancel = BotToast.showLoading();
  final response = await HttpClient.get('/v2/home-list');
  final data = HomeModel.fromJson(response.data as Map<String, dynamic>);
  homeSignal.value = data;
  cancel();
}
