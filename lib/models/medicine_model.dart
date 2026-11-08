class MedicineModel {

  final String name;
  final String generic;
  final String uses;
  final String dosage;
  final String precautions;
  final String sideEffects;
  final String interaction;
  final String date;

  MedicineModel({
    required this.name,
    required this.generic,
    required this.uses,
    required this.dosage,
    required this.precautions,
    required this.sideEffects,
    required this.interaction,
    required this.date,
  });

  Map<String,dynamic> toJson(){

    return {
      "name":name,
      "generic":generic,
      "uses":uses,
      "dosage":dosage,
      "precautions":precautions,
      "sideEffects":sideEffects,
      "interaction":interaction,
      "date":date
    };

  }

}