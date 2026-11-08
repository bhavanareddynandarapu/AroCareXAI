class MedicalReport {
  final String id;
  final String name;
  final String type;
  final String? fileUrl;
  final String filePath;
  final String aiSuggestion;
  final String date;

  MedicalReport({
    String? id,
    required this.name,
    required this.type,
    this.fileUrl,
    required this.filePath,
    required this.aiSuggestion,
    required this.date,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "fileUrl": fileUrl,
      "filePath": filePath,
      "aiSuggestion": aiSuggestion,
      "date": date,
    };
  }


  factory MedicalReport.fromJson(Map<String, dynamic> json) {

    return MedicalReport(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      fileUrl: json["fileUrl"],
      filePath: json["filePath"] ?? "", 
      aiSuggestion: json["aiSuggestion"] ?? "",
      date: json["date"] ?? "",
    );

  }
}