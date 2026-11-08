class MedicineAIService {


static Future<String> analyzeMedicine(String imagePath) async {


  // AI connection will be added here

  await Future.delayed(
      const Duration(seconds:2)
  );


return """

Medicine Name:
Paracetamol 500mg


Generic Name:
Acetaminophen


Uses:
• Fever reduction
• Pain relief


Dosage:
Take only as prescribed by doctor.


Precautions:
• Avoid overdose
• Liver patients should consult doctor


Side Effects:
• Nausea
• Skin allergy (rare)


Drug Interaction:
Avoid combining with other medicines containing Paracetamol.


""";


}


}