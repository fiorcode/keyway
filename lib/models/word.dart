class Word {
  final String? value;
  final String? freq;

  Word({this.value, this.freq});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(value: json['word'], freq: json['freq']);
  }
}
