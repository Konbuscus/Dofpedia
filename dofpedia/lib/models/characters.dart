// To parse this JSON data, do
//
//     final characters = charactersFromJson(jsonString);

import 'dart:convert';

import 'package:dofpedia/models/stats.dart';

import 'Item.dart';

List<Characters> charactersFromJson(String str) => List<Characters>.from(json.decode(str).map((x) => Characters.fromJson(x)));

String charactersToJson(List<Characters> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Characters {
    int id;
    String name;
    String type;
    String url;
    List<ItemsEquipped> itemsEquipped;

    Characters({
        this.id,
        this.name,
        this.type,
        this.url,
        this.itemsEquipped,
    });

    factory Characters.fromJson(Map<String, dynamic> json) => Characters(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        url: json["url"],
        itemsEquipped: List<ItemsEquipped>.from(json["itemsEquipped"].map((x) => ItemsEquipped.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "url": url,
        "itemsEquipped": List<dynamic>.from(itemsEquipped.map((x) => x.toJson())),
    };
}

class ItemsEquipped {
    List<Item> itemsOnBody;
    List<Map<String, DofusTrophy>> dofusTrophies;
    List<Stats> stats;

    ItemsEquipped({
        this.itemsOnBody,
        this.dofusTrophies,
        this.stats,
    });

    factory ItemsEquipped.fromJson(Map<String, dynamic> json) => ItemsEquipped(
        itemsOnBody: List<Item>.from(json["Item"].map((x) => Item.fromJson(x))),
        dofusTrophies: List<Map<String, DofusTrophy>>.from(json["DofusTrophies"].map((x) => Map.from(x).map((k, v) => MapEntry<String, DofusTrophy>(k, DofusTrophy.fromJson(v))))),
        stats: List<Stats>.from(json["Stats"].map((x) => Stats.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Item": List<dynamic>.from(itemsOnBody.map((x) => x.toJson())),
        "DofusTrophies": List<dynamic>.from(dofusTrophies.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
        "Stats": List<dynamic>.from(stats.map((x) => x.toJson())),
    };
}

class DofusTrophy {
    DofusTrophy();

    factory DofusTrophy.fromJson(Map<String, dynamic> json) => DofusTrophy(
    );

    Map<String, dynamic> toJson() => {
    };
}



