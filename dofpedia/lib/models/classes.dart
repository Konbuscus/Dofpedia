class Classes {
  int iId;
  int ankamaId;
  String name;
  Null level;
  String type;
  String url;
  String description;
  List<String> roles;
  List<Spells> spells;
  String maleImg;
  String femaleImg;

  Classes(
      {this.iId,
      this.ankamaId,
      this.name,
      this.level,
      this.type,
      this.url,
      this.description,
      this.roles,
      this.spells,
      this.maleImg,
      this.femaleImg});

  Classes.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    ankamaId = json['ankamaId'];
    name = json['name'];
    level = json['level'];
    type = json['type'];
    url = json['url'];
    description = json['description'];
    roles = json['roles'].cast<String>();
    if (json['spells'] != null) {
      spells = new List<Spells>();
      json['spells'].forEach((v) {
        spells.add(new Spells.fromJson(v));
      });
    }
    maleImg = json['maleImg'];
    femaleImg = json['femaleImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['ankamaId'] = this.ankamaId;
    data['name'] = this.name;
    data['level'] = this.level;
    data['type'] = this.type;
    data['url'] = this.url;
    data['description'] = this.description;
    data['roles'] = this.roles;
    if (this.spells != null) {
      data['spells'] = this.spells.map((v) => v.toJson()).toList();
    }
    data['maleImg'] = this.maleImg;
    data['femaleImg'] = this.femaleImg;
    return data;
  }
}

class Spells {
  String name;
  String variant;

  Spells({this.name, this.variant});

  Spells.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['variant'] = this.variant;
    return data;
  }
}