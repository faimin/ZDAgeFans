import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zd_age_fans/common/http.dart';
import 'package:zd_age_fans/models/home_model.dart';

class HomeNotifier extends StateNotifier<HomeModel> {
  HomeNotifier()
      : super(
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

  void fetchData() async {
    final response = await HttpClient.get('/v2/home-list');
    final data = HomeModel.fromJson(response.data as Map<String, dynamic>);

    state = data;
  }
}
