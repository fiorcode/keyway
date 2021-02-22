class Tag {
  int id;
  String tagName;
  bool selected = false;

  Tag(this.tagName);

  Tag.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tagName = map['tag_name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tag_name': tagName,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
