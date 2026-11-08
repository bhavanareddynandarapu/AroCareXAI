class HospitalService {


  static Future<List> searchHospitals(String location) async {


    await Future.delayed(
      const Duration(seconds: 1),
    );


    return [

      {
        "name":
        "Apollo Hospital - $location",

        "lat":
        13.2172,

        "lon":
        79.1003,

      },


      {
        "name":
        "Government General Hospital - $location",

        "lat":
        13.2185,

        "lon":
        79.1015,

      },


      {
        "name":
        "Sri Venkateswara Hospital - $location",

        "lat":
        13.2200,

        "lon":
        79.0980,

      },


    ];

  }


}