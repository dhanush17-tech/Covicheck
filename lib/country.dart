class Country {
  String name;
  String flag;
  String code;

  Country({this.name, this.flag, this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return new Country(
      name: json['country'] as String,
      flag: json["countryInfo"]['flag'] as String,
      code: json["countryInfo"]['iso2'] as String,
    );
  }
}
