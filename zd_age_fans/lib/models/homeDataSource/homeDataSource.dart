import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class HomeDataSource {
  HomeDataSource({
    required this.latest, 
    required this.recommend, 
    required this.weekList
  });

  @JsonKey(name: "latest", defaultValue: [])
  List<FilmItem> latest;

  @JsonKey(name: "recommend", defaultValue: [])
  List<FilmItem> recommend;

  @JsonKey(name: "week_list")
  WeekList weekList;

  factory HomeDataSource.fromJson(Map<String, dynamic> json) {
    return HomeDataSource(
      latest: List<FilmItem>.from((json["latest"] as List).map(
        (x) => FilmItem.fromJson(x),
      )),
      recommend: List<FilmItem>.from((json["recommend"] as List).map(
        (x) => FilmItem.fromJson(x),
      )),
      weekList: WeekList.fromJson(json["week_list"]),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class FilmItem {
  FilmItem(
      {required this.aID,
      required this.href,
      required this.newTitle,
      required this.picSmall,
      required this.title});

  @JsonKey(name: "AID", defaultValue: 0)
  int aID;

  @JsonKey(name: "Href", defaultValue: "")
  String href;

  @JsonKey(name: "NewTitle", defaultValue: "")
  String newTitle;

  @JsonKey(name: "PicSmall", defaultValue: "")
  String picSmall;

  @JsonKey(name: "Title", defaultValue: "")
  String title;

  factory FilmItem.fromJson(Map<String, dynamic> json) {
    return FilmItem(
      aID: json["AID"],
      href: json["Href"],
      newTitle: json["NewTitle"],
      picSmall: json["PicSmall"],
      title: json["Title"],
    );
  }

  // Map<String, dynamic> toJson() => _$LatestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WeekItem {
  WeekItem(
      {required this.isnew,
      required this.id,
      required this.wd,
      required this.name,
      required this.mtime,
      required this.namefornew});

  @JsonKey(name: "isnew", defaultValue: 0)
  int isnew;

  @JsonKey(name: "id", defaultValue: 0)
  int id;

  @JsonKey(name: "wd", defaultValue: 0)
  int wd;

  @JsonKey(name: "name", defaultValue: "")
  String name;

  @JsonKey(name: "mtime", defaultValue: "")
  String mtime;

  @JsonKey(name: "namefornew", defaultValue: "")
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

@JsonSerializable(explicitToJson: true)
class WeekList {
  WeekList({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday
  });

  @JsonKey(name: "monday", defaultValue: [])
  final List<WeekItem> monday;

  @JsonKey(name: "tuesday", defaultValue: [])
  final List<WeekItem> tuesday;

  @JsonKey(name: "wednesday", defaultValue: [])
  final List<WeekItem> wednesday;

  @JsonKey(name: "thursday", defaultValue: [])
  final List<WeekItem> thursday;

  @JsonKey(name: "friday", defaultValue: [])
  final List<WeekItem> friday;

  @JsonKey(name: "saturday", defaultValue: [])
  final List<WeekItem> saturday;

  @JsonKey(name: "sunday", defaultValue: [])
  final List<WeekItem> sunday;


  factory WeekList.fromJson(Map<String, dynamic> json) {
    return WeekList(
      monday: List<WeekItem>.from((json["1"] as List).map((x) => WeekItem.fromJson(x))),
      tuesday: List<WeekItem>.from((json["2"] as List).map((x) => WeekItem.fromJson(x))),
      wednesday: List<WeekItem>.from((json["3"] as List).map((x) => WeekItem.fromJson(x))),
      thursday: List<WeekItem>.from((json["4"] as List).map((x) => WeekItem.fromJson(x))),
      friday: List<WeekItem>.from((json["5"] as List).map((x) => WeekItem.fromJson(x))),
      saturday: List<WeekItem>.from((json["6"] as List).map((x) => WeekItem.fromJson(x))),
      sunday: List<WeekItem>.from((json["0"] as List).map((x) => WeekItem.fromJson(x)))
    );
  }
}
