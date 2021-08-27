class Note {
  int noteId;
  String noteEnc;
  String noteIv;

  Note({
    this.noteId,
    this.noteEnc = '',
    this.noteIv = '',
  });

  Note.fromMap(Map<String, dynamic> map) {
    noteId = map['note_id'];
    noteEnc = map['note_enc'];
    noteIv = map['note_iv'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'note_enc': noteEnc,
      'note_iv': noteIv,
    };
    if (noteId != null) map['note_id'] = noteId;
    return map;
  }

  Note clone() => Note(
        noteId: this.noteId,
        noteEnc: this.noteEnc,
        noteIv: this.noteIv,
      );

  bool notEqual(Note n) {
    if (n == null) return true;
    if (this.noteEnc != n.noteEnc) return true;
    if (this.noteIv != n.noteIv) return true;
    return false;
  }
}
