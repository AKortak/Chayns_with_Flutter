import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chaynssite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter_chayns/Database/db.dart';

class Locations {
  List<Site> locations;
  Locations({this.locations});

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      locations: json["locations"] == null ? null : List<Site>.from(json["locations"].map((x) => Site.fromJson(x))),
    );
  }

  factory Locations.fromJsonAsSearchQuery(Map<String, dynamic> json) {
    return Locations(
      locations: json["locations"] == null ? null : List<Site>.from(json["locations"].map((x) => Site.fromJsonAsSearchQuery(x))),
    );
  }

  Future<List<Site>> fetchFavoriteSites() async {
    File file;
    List<Site> siteList = [];
    await DB.deleteTable(Site.table);
    var documentDirectory = await getApplicationDocumentsDirectory();
    var response = await http.get(
      'https://webapi.tobit.com/dataagg/v1.0/location',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsInZlciI6MSwia2lkIjoibnpjem1kYmQifQ.eyJqdGkiOiJlZjY0MjM1Ny1kNmQ2LTQ5OWEtYjM3Yy00ODQyODdkOWFlMTEiLCJzdWIiOiIxMzMtOTc0NzMiLCJ0eXBlIjoxLCJleHAiOiIyMDIwLTExLTAzVDA4OjE2OjM2WiIsImlhdCI6IjIwMjAtMTAtMzBUMDg6MTY6MzZaIiwiTG9jYXRpb25JRCI6Mzc4LCJTaXRlSUQiOiI2MDAyMS0wODk4OSIsIklzQWRtaW4iOmZhbHNlLCJUb2JpdFVzZXJJRCI6MjE5NjAwNywiUGVyc29uSUQiOiIxMzMtOTc0NzMiLCJGaXJzdE5hbWUiOiJBbGkiLCJMYXN0TmFtZSI6IktvcnRhayIsIlJvbGVzIjpbInN3aXRjaF9sb2NhdGlvbiJdLCJwcm92IjowfQ.dUd5R11ZfVsq6v_4-kPi9616-QilQCSOKy1sQRn8I6ULYig0WAf-cL6ADX1v4IOcZFZSYFpEiYtD_vTcxx2FGVN1Ud1IUYCDd5pmac6_ubZ6-X3IHF9ythlcJD-7pzr59yfqAjRCdnJ__6vElbp9anpIh-B1wJt2HNobl8DNCk8x6iwnXKwFGmETqvg0JhmsG75Sh76_5nF-Jf1zC2uvFU7uu9w6t7QHn9qOwMxbvf1qf8V-5jf0ivncWjx4mF1dBBZdtpOalAkKHpv671mK1yKPpJ1OFdrljiCvGSakktcqWagwHVFE_ZuzoljRn2pTTxM8k5-UH0GdfoJayenl0A"
      },
    );
    var responseJson = jsonDecode(response.body);
    Locations s = Locations.fromJson(responseJson);
    for (int i = 0; i < s.locations.length; i++) {
      String siteId = s.locations[i].siteId;
      String name = s.locations[i].name;
      var response = await http.get(
        'https://sub60.tobit.com/l/$siteId?size=60',
      );
      file = new File(join(documentDirectory.path, '$name.png'));
      file.writeAsBytes(response.bodyBytes);
      Site mySite = Site(siteId: siteId, name: name, pathToPic: file.toString());
      DB.insert(Site.table, mySite);
      siteList.add(mySite);
    }
    return siteList;
  }

  Future<List<Site>> fetchSitesFromSearch(String searchText) async {
    List<Site> siteList = [];
    if (searchText != "") {
      print("Falsche durchlaufennnnnnnn@@@@@@@@@@@@@@@@@@@@@@@");
      File file;
      var documentDirectory = await getApplicationDocumentsDirectory();
      var response = await http.get(
        'https://chayns2.tobit.com/SiteSearchApi/location/search/$searchText/?skip=0&take=10&select=color,locationId,siteId,locationName',
      );
      var responseJson = jsonDecode(response.body);
      List<Site> mySiteList = responseJson.map<Site>((json) => Site.fromJsonAsSearchQuery(json)).toList();
      for (int i = 0; i < mySiteList.length; i++) {
        String siteId = mySiteList[i].siteId;
        String name = mySiteList[i].locationName;
        var response = await http.get(
          'https://sub60.tobit.com/l/$siteId?size=60',
        );
        file = new File(join(documentDirectory.path, '$name.png'));
        file.writeAsBytes(response.bodyBytes);
        Site mySite = Site(siteId: siteId, locationName: name, pathToPic: file.toString());
        siteList.add(mySite);
        print(mySite.locationName);
      }
    } else {
      getSitesFromDBOrElseFetch().then((value) => siteList.addAll(value));
    }
    return siteList;
  }

  Future<List<Site>> getSitesFromDBOrElseFetch() async {
    List<Site> siteList = [];
    List<Map<String, dynamic>> asyncSiteListe = await DB.query(Site.table);
    for (int i = 0; i < asyncSiteListe.length; i++) {
      Site site = Site.fromMap(asyncSiteListe[i]);
      siteList.add(site);
      print(site.siteId + site.pathToPic + site.name);
    }
    if (siteList.isEmpty) {
      print("durchlaufen@@@@@@@@@@@");
      await fetchFavoriteSites();
      getSitesFromDBOrElseFetch();
    }
    return siteList;
  }
}
