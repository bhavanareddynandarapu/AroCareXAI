class HealthReport {

  final String date;
  final double bmi;
  final int score;
  final String status;


  HealthReport({
    required this.date,
    required this.bmi,
    required this.score,
    required this.status,
  });


  Map<String, dynamic> toJson() {

    return {
      "date": date,
      "bmi": bmi,
      "score": score,
      "status": status,
    };

  }


  factory HealthReport.fromJson(Map<String,dynamic> json){

    return HealthReport(
      date: json["date"],
      bmi: json["bmi"],
      score: json["score"],
      status: json["status"],
    );

  }

}