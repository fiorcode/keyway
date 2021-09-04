class Backup {
  int backupId;
  String backupDate;
  String backupType;
  String backupPath;

  Backup({
    this.backupId,
    this.backupDate = '',
    this.backupType = '',
    this.backupPath = '',
  });

  Backup.fromMap(Map<String, dynamic> map) {
    backupId = map['backup_id'];
    backupDate = map['backup_date'];
    backupType = map['backup_type'];
    backupPath = map['backup_path'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'backup_date': backupDate,
      'backup_type': backupType,
      'backup_path': backupPath,
    };
    if (backupId != null) map['backup_id'] = backupId;
    return map;
  }

  Backup clone() => Backup(
        backupId: this.backupId,
        backupDate: this.backupDate,
        backupType: this.backupType,
        backupPath: this.backupPath,
      );

  bool notEqual(Backup u) {
    if (u == null) return true;
    if (this.backupPath != u.backupPath) return true;
    if (this.backupDate != u.backupDate) return true;
    if (this.backupType != u.backupType) return true;
    return false;
  }
}
