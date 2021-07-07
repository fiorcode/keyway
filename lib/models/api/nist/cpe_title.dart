class CpeTitle {
  final String title;
  final String lang;

  CpeTitle(this.title, this.lang);

  factory CpeTitle.fromJson(Map<String, dynamic> parsedJson) =>
      CpeTitle(parsedJson['title'], parsedJson['lang']);
}
