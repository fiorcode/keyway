class Tag {
  int id;
  String tagName;
  int tagColor;
  bool selected;

  Tag({
    this.tagName,
    this.tagColor = 4294967295,
    this.selected = false,
  });

  Tag.fromMap(Map<String, dynamic> map) {
    this.id = map['tag_id'];
    this.tagName = map['tag_name'];
    this.tagColor = map['tag_color'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tag_name': this.tagName,
      'tag_color': this.tagColor,
    };
    if (id != null) map['tag_id'] = this.id;
    return map;
  }
}
