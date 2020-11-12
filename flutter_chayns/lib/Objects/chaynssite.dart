class Site {
  int id;
  String siteId;
  String name;
  String locationName;
  String pathToPic;
  static String table = "location_tabelle";

  Site({this.name, this.siteId, this.pathToPic, this.locationName});

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        siteId: json["siteId"] == null ? null : json["siteId"],
        name: json["name"] == null ? null : json["name"],
      );

  factory Site.fromJsonAsSearchQuery(Map<String, dynamic> json) => Site(
        siteId: json["siteId"] == null ? null : json["siteId"],
        locationName: json["locationName"] == null ? null : json["locationName"],
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'siteId': siteId,
      'pathToPic': pathToPic,
    };
    return map;
  }

  Site.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    siteId = map['siteId'];
    pathToPic = map['pathToPic'];
  }
}
