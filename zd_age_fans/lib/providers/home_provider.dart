import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zd_age_fans/common/http.dart';
import 'package:zd_age_fans/models/home_data.dart';

class HomeNotifier extends StateNotifier<HomeDataSource> {
  HomeNotifier()
      : super(HomeDataSource(
            latest: [],
            recommend: [],
            weekList: WeekList(
                monday: [],
                tuesday: [],
                wednesday: [],
                thursday: [],
                friday: [],
                saturday: [],
                sunday: []))) {
    fetchData();
  }

  void fetchData() async {
    final response = await HttpClient.get('/v2/home-list');
    final data = HomeDataSource.fromJson(response.data as Map<String, dynamic>);

    state = data;
  }
}
