class DoctorAIService {


  static Map<String,String> analyze(
      String symptom
      ){


    symptom =
        symptom.toLowerCase();



    if(symptom.contains("chest") ||
        symptom.contains("heart")){


      return {

        "doctor":
        "Cardiologist",

        "department":
        "Cardiology",

        "level":
        "HIGH",

        "advice":
        "Chest pain may require immediate medical attention"

      };

    }




    else if(symptom.contains("skin") ||
        symptom.contains("rash") ||
        symptom.contains("itch")){


      return {

        "doctor":
        "Dermatologist",

        "department":
        "Skin Department",

        "level":
        "MEDIUM",

        "advice":
        "Consult skin specialist"

      };

    }





    else if(symptom.contains("eye") ||
        symptom.contains("vision")){


      return {

        "doctor":
        "Ophthalmologist",

        "department":
        "Eye Care",

        "level":
        "MEDIUM",

        "advice":
        "Eye examination recommended"

      };

    }





    else if(symptom.contains("diabetes") ||
        symptom.contains("sugar")){


      return {

        "doctor":
        "Diabetologist",

        "department":
        "Endocrinology",

        "level":
        "MEDIUM",

        "advice":
        "Monitor blood sugar levels"

      };

    }





    else if(symptom.contains("fever") ||
        symptom.contains("cold") ||
        symptom.contains("cough")){


      return {

        "doctor":
        "General Physician",

        "department":
        "General Medicine",

        "level":
        "LOW",

        "advice":
        "Take rest and consult doctor if symptoms continue"

      };

    }





    return {


      "doctor":
      "General Physician",


      "department":
      "General Medicine",


      "level":
      "LOW",


      "advice":
      "Medical consultation recommended"


    };


  }


}