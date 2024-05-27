class EntryModel {
  EntryModel({
    required this.isOut,
    required this.roomName,
    required this.studentId,
    required this.studentName,
    required this.entryDate,
  });

  final bool isOut;
  final String roomName;
  final String studentId;
  final String studentName;
  final DateTime entryDate;
}
