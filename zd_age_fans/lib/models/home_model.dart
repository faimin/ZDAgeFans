class HomeModel {
  HomeModel(
      {required this.latest, required this.recommend, required this.weekList});

  List<CartoonItem> latest;
  List<CartoonItem> recommend;
  WeekList weekList;

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      latest: List<CartoonItem>.from((json["latest"] as List).map(
        (x) => CartoonItem.fromJson(x),
      )),
      recommend: List<CartoonItem>.from((json["recommend"] as List).map(
        (x) => CartoonItem.fromJson(x),
      )),
      weekList: WeekList.fromJson(json["week_list"]),
    );
  }
}

class CartoonItem {
  CartoonItem(
      {required this.aID,
      required this.href,
      required this.newTitle,
      required this.picSmall,
      required this.title});

  int aID;
  String href;
  String newTitle;
  String picSmall;
  String title;

  factory CartoonItem.fromJson(Map<String, dynamic> json) {
    return CartoonItem(
      aID: json["AID"],
      href: json["Href"],
      newTitle: json["NewTitle"],
      picSmall: json["PicSmall"],
      title: json["Title"],
    );
  }
}

class WeekItem {
  WeekItem(
      {required this.isnew,
      required this.id,
      required this.wd,
      required this.name,
      required this.mtime,
      required this.namefornew});

  int isnew;
  int id;
  int wd;
  String name;
  String mtime;
  String namefornew;

  factory WeekItem.fromJson(Map<String, dynamic> json) {
    return WeekItem(
        isnew: json["isnew"],
        id: json["id"],
        wd: json["wd"],
        name: json["name"],
        mtime: json["mtime"],
        namefornew: json["namefornew"]);
  }
}

class WeekList {
  WeekList(
      {required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday});

  final List<WeekItem> monday;
  final List<WeekItem> tuesday;
  final List<WeekItem> wednesday;
  final List<WeekItem> thursday;
  final List<WeekItem> friday;
  final List<WeekItem> saturday;
  final List<WeekItem> sunday;

  factory WeekList.fromJson(Map<String, dynamic> json) {
    return WeekList(
        monday: List<WeekItem>.from(
            (json["1"] as List).map((x) => WeekItem.fromJson(x))),
        tuesday: List<WeekItem>.from(
            (json["2"] as List).map((x) => WeekItem.fromJson(x))),
        wednesday: List<WeekItem>.from(
            (json["3"] as List).map((x) => WeekItem.fromJson(x))),
        thursday: List<WeekItem>.from(
            (json["4"] as List).map((x) => WeekItem.fromJson(x))),
        friday: List<WeekItem>.from(
            (json["5"] as List).map((x) => WeekItem.fromJson(x))),
        saturday: List<WeekItem>.from(
            (json["6"] as List).map((x) => WeekItem.fromJson(x))),
        sunday: List<WeekItem>.from(
            (json["0"] as List).map((x) => WeekItem.fromJson(x))));
  }
}
