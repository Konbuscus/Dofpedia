import 'package:dofpedia/models/characters.dart';
import 'package:dofpedia/models/stats.dart';

import 'Recipe.dart';

class Item {
	int iId;
	int ankamaId;
	String name;
	int level;
	String type;
	String imgUrl;
	String url;
	String description;
	List<Stats> statistics;
	Recipe recipe;
	int setId;

	Item({this.iId, this.ankamaId, this.name, this.level, this.type, this.imgUrl, this.url, this.description, this.statistics, this.recipe, this.setId});

	Item.fromJson(Map<String, dynamic> json) {
		iId = json['_id'];
		ankamaId = json['ankamaId'];
		name = json['name'];
		level = json['level'];
		type = json['type'];
		imgUrl = json['imgUrl'];
		url = json['url'];
		description = json['description'];
		if (json['statistics'] != null) {
			statistics = new List<Stats>();
			json['statistics'].forEach((v) { statistics.add(new Stats.fromJson(v)); });
		}
		if (json['recipe'] != null) {
			recipe = json["recipe"]; 
		}
		setId = json['setId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['_id'] = this.iId;
		data['ankamaId'] = this.ankamaId;
		data['name'] = this.name;
		data['level'] = this.level;
		data['type'] = this.type;
		data['imgUrl'] = this.imgUrl;
		data['url'] = this.url;
		data['description'] = this.description;
		if (this.statistics != null) {
      data['statistics'] = this.statistics.map((v) => v.toJson()).toList();
    }
		if (this.recipe != null) {
      data['recipe'] = this.recipe;
    }
		data['setId'] = this.setId;
		return data;
	}
}
