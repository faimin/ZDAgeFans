import 'package:zd_age_fans/models/home_model.dart';

class DetailModel {
    Video? video;
    List<dynamic> series;
    List<CartoonItem> similar;
    PlayerLabelArr? playerLabelArr;
    String playerVip;
    PlayerJx playerJx;

    DetailModel({
        required this.video,
        required this.series,
        required this.similar,
        required this.playerLabelArr,
        required this.playerVip,
        required this.playerJx,
    });

    factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        video: Video.fromJson(json["video"]),
        series: List<dynamic>.from(json["series"].map((x) => x)),
        similar: List<CartoonItem>.from(json["similar"].map((x) => CartoonItem.fromJson(x))),
        playerLabelArr: PlayerLabelArr.fromJson(json["player_label_arr"]),
        playerVip: json["player_vip"],
        playerJx: PlayerJx.fromJson(json["player_jx"]),
    );

    Map<String, dynamic> toJson() => {
        "video": video?.toJson(),
        "series": List<dynamic>.from(series.map((x) => x)),
        "similar": List<dynamic>.from(similar.map((x) => x.toJson())),
        "player_label_arr": playerLabelArr?.toJson(),
        "player_vip": playerVip,
        "player_jx": playerJx.toJson(),
    };
}

class PlayerJx {
    String vip;
    String zj;

    PlayerJx({
        required this.vip,
        required this.zj,
    });

    factory PlayerJx.fromJson(Map<String, dynamic> json) => PlayerJx(
        vip: json["vip"],
        zj: json["zj"],
    );

    Map<String, dynamic> toJson() => {
        "vip": vip,
        "zj": zj,
    };
}

class PlayerLabelArr {
    String qiyi;
    String qq;
    String youku;
    String mgtv;
    String bilibili;
    String baba;
    String qiqi;
    String sohu;
    String tt;
    String panda;
    String pptv;
    String letv;
    String xigua;
    String migutv;
    String my;
    String wy;
    String baidu;
    String zjm3U8;
    String the99M3U8;
    String tkm3U8;
    String hnm3U8;
    String lzm3U8;
    String wolong;
    String wjm3U8;
    String sdm3U8;
    String kbm3U8;
    String bjm3U8;
    String xkm3U8;
    String tpm3U8;

    PlayerLabelArr({
        required this.qiyi,
        required this.qq,
        required this.youku,
        required this.mgtv,
        required this.bilibili,
        required this.baba,
        required this.qiqi,
        required this.sohu,
        required this.tt,
        required this.panda,
        required this.pptv,
        required this.letv,
        required this.xigua,
        required this.migutv,
        required this.my,
        required this.wy,
        required this.baidu,
        required this.zjm3U8,
        required this.the99M3U8,
        required this.tkm3U8,
        required this.hnm3U8,
        required this.lzm3U8,
        required this.wolong,
        required this.wjm3U8,
        required this.sdm3U8,
        required this.kbm3U8,
        required this.bjm3U8,
        required this.xkm3U8,
        required this.tpm3U8,
    });

    factory PlayerLabelArr.fromJson(Map<String, dynamic> json) => PlayerLabelArr(
        qiyi: json["qiyi"],
        qq: json["qq"],
        youku: json["youku"],
        mgtv: json["mgtv"],
        bilibili: json["bilibili"],
        baba: json["baba"],
        qiqi: json["qiqi"],
        sohu: json["sohu"],
        tt: json["tt"],
        panda: json["panda"],
        pptv: json["pptv"],
        letv: json["letv"],
        xigua: json["xigua"],
        migutv: json["migutv"],
        my: json["my"],
        wy: json["wy"],
        baidu: json["baidu"],
        zjm3U8: json["zjm3u8"],
        the99M3U8: json["99m3u8"],
        tkm3U8: json["tkm3u8"],
        hnm3U8: json["hnm3u8"],
        lzm3U8: json["lzm3u8"],
        wolong: json["wolong"],
        wjm3U8: json["wjm3u8"],
        sdm3U8: json["sdm3u8"],
        kbm3U8: json["kbm3u8"],
        bjm3U8: json["bjm3u8"],
        xkm3U8: json["xkm3u8"],
        tpm3U8: json["tpm3u8"],
    );

    Map<String, dynamic> toJson() => {
        "qiyi": qiyi,
        "qq": qq,
        "youku": youku,
        "mgtv": mgtv,
        "bilibili": bilibili,
        "baba": baba,
        "qiqi": qiqi,
        "sohu": sohu,
        "tt": tt,
        "panda": panda,
        "pptv": pptv,
        "letv": letv,
        "xigua": xigua,
        "migutv": migutv,
        "my": my,
        "wy": wy,
        "baidu": baidu,
        "zjm3u8": zjm3U8,
        "99m3u8": the99M3U8,
        "tkm3u8": tkm3U8,
        "hnm3u8": hnm3U8,
        "lzm3u8": lzm3U8,
        "wolong": wolong,
        "wjm3u8": wjm3U8,
        "sdm3u8": sdm3U8,
        "kbm3u8": kbm3U8,
        "bjm3u8": bjm3U8,
        "xkm3u8": xkm3U8,
        "tpm3u8": tpm3U8,
    };
}

class Video {
    int id;
    String nameOther;
    String company;
    String name;
    String type;
    String writer;
    String nameOriginal;
    String plot;
    List<String> plotArr;
    Map<String, List<List<String>>> playlists;
    String area;
    String letter;
    String website;
    int star;
    String status;
    String uptodate;
    String timeFormat1;
    DateTime timeFormat2;
    DateTime timeFormat3;
    int time;
    String tags;
    List<String> tagsArr;
    String intro;
    String introHtml;
    String introClean;
    String series;
    String resource;
    int year;
    int season;
    DateTime premiere;
    String rankCnt;
    String cover;
    String commentCnt;
    String collectCnt;

    Video({
        required this.id,
        required this.nameOther,
        required this.company,
        required this.name,
        required this.type,
        required this.writer,
        required this.nameOriginal,
        required this.plot,
        required this.plotArr,
        required this.playlists,
        required this.area,
        required this.letter,
        required this.website,
        required this.star,
        required this.status,
        required this.uptodate,
        required this.timeFormat1,
        required this.timeFormat2,
        required this.timeFormat3,
        required this.time,
        required this.tags,
        required this.tagsArr,
        required this.intro,
        required this.introHtml,
        required this.introClean,
        required this.series,
        required this.resource,
        required this.year,
        required this.season,
        required this.premiere,
        required this.rankCnt,
        required this.cover,
        required this.commentCnt,
        required this.collectCnt,
    });

    factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        nameOther: json["name_other"],
        company: json["company"],
        name: json["name"],
        type: json["type"],
        writer: json["writer"],
        nameOriginal: json["name_original"],
        plot: json["plot"],
        plotArr: List<String>.from(json["plot_arr"].map((x) => x)),
        playlists: Map.from(json["playlists"]).map((k, v) => MapEntry<String, List<List<String>>>(k, List<List<String>>.from(v.map((x) => List<String>.from(x.map((x) => x)))))),
        area: json["area"],
        letter: json["letter"],
        website: json["website"],
        star: json["star"],
        status: json["status"],
        uptodate: json["uptodate"],
        timeFormat1: json["time_format_1"],
        timeFormat2: DateTime.parse(json["time_format_2"]),
        timeFormat3: DateTime.parse(json["time_format_3"]),
        time: json["time"],
        tags: json["tags"],
        tagsArr: List<String>.from(json["tags_arr"].map((x) => x)),
        intro: json["intro"],
        introHtml: json["intro_html"],
        introClean: json["intro_clean"],
        series: json["series"],
        resource: json["resource"],
        year: json["year"],
        season: json["season"],
        premiere: DateTime.parse(json["premiere"]),
        rankCnt: json["rank_cnt"],
        cover: json["cover"],
        commentCnt: json["comment_cnt"],
        collectCnt: json["collect_cnt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name_other": nameOther,
        "company": company,
        "name": name,
        "type": type,
        "writer": writer,
        "name_original": nameOriginal,
        "plot": plot,
        "plot_arr": List<dynamic>.from(plotArr.map((x) => x)),
        "playlists": Map.from(playlists).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => List<dynamic>.from(x.map((x) => x)))))),
        "area": area,
        "letter": letter,
        "website": website,
        "star": star,
        "status": status,
        "uptodate": uptodate,
        "time_format_1": timeFormat1,
        "time_format_2": "${timeFormat2.year.toString().padLeft(4, '0')}-${timeFormat2.month.toString().padLeft(2, '0')}-${timeFormat2.day.toString().padLeft(2, '0')}",
        "time_format_3": timeFormat3.toIso8601String(),
        "time": time,
        "tags": tags,
        "tags_arr": List<dynamic>.from(tagsArr.map((x) => x)),
        "intro": intro,
        "intro_html": introHtml,
        "intro_clean": introClean,
        "series": series,
        "resource": resource,
        "year": year,
        "season": season,
        "premiere": "${premiere.year.toString().padLeft(4, '0')}-${premiere.month.toString().padLeft(2, '0')}-${premiere.day.toString().padLeft(2, '0')}",
        "rank_cnt": rankCnt,
        "cover": cover,
        "comment_cnt": commentCnt,
        "collect_cnt": collectCnt,
    };
}
