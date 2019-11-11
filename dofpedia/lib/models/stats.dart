class Stats {
    int value;
    int parchemin;
    String name;

    Stats({
        this.value,
        this.parchemin,
        this.name
    });

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        value: json["value"],
        parchemin: json["parchemin"],
        name : json["name"]
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "parchemin": parchemin,
        "name": name
    };
}