class HealthData {


  // ==============================
  // User Health Information
  // ==============================


  static String userName = "";

  static int age = 0;

  static double height = 0;

  static double weight = 0;

  static int heartRate = 0;

  static double sleepHours = 0;



  // ==============================
  // AI Prediction Result
  // ==============================


  static int healthScore = 0;


  static String healthStatus =
      "No health analysis available";



  // ==============================
  // AI Suggestions
  // ==============================


  static List<String> suggestions = [];




  // ==============================
  // Save User Details
  // ==============================


  static void saveUserDetails({


    required String name,


    required int userAge,


    required double userHeight,


    required double userWeight,


    required int userHeartRate,


    required double userSleepHours,


  }) {


    userName = name;


    age = userAge;


    height = userHeight;


    weight = userWeight;


    heartRate = userHeartRate;


    sleepHours = userSleepHours;


  }





  // ==============================
  // Save AI Prediction Result
  // ==============================


  static void updateHealthResult({


    required int score,


    required String status,


    required List<String> advice,


  }) {


    healthScore = score;


    healthStatus = status;


    suggestions = advice;


  }




  // ==============================
  // Clear Health Data
  // ==============================


  static void clearData(){


    userName = "";


    age = 0;


    height = 0;


    weight = 0;


    heartRate = 0;


    sleepHours = 0;


    healthScore = 0;


    healthStatus =
        "No health analysis available";


    suggestions = [];


  }


}