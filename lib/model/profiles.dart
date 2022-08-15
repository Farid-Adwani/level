import 'dart:math';

class Profile {
   String id;
   String name;
   String description;
   String image;
   String nname;


   Profile({required this.id, required this.name, required this.description,required this.image ,required this.nname});
  
static var data={
"total_persons":174654,
"all_per":100.0,
  "mkid":10.0,
  "fkid":15.542,
  "myoung":2.54,
  "fyoung":4.17,
  "madult":12.0,
  "fadult":14.0,
  "mold":35.0,
  "fold":1.055,
  "women_per":60.0,
  "men_per":40.0,

};


static Map<DateTime, double> hourLine={
DateTime.parse("1969-07-20 00:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 01:00:00Z"): Random().nextDouble(),
DateTime.parse("1969-07-20 02:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 03:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 04:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 05:00:00Z"): Random().nextDouble(),
DateTime.parse("1969-07-20 06:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 07:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 08:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 09:00:00Z"): Random().nextDouble(),
DateTime.parse("1969-07-20 10:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 11:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 12:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 13:00:00Z"): Random().nextDouble(),
DateTime.parse("1969-07-20 14:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 15:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 16:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 17:00:00Z"): Random().nextDouble(),
DateTime.parse("1969-07-20 18:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 19:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 20:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 21:00:00Z"): Random().nextDouble(),
DateTime.parse("1969-07-20 22:00:00Z"):  Random().nextDouble(),
DateTime.parse("1969-07-20 23:00:00Z"):  Random().nextDouble(),

};

  static var Profiles = {
    "people":
   Profile(
    id: "0",
    nname: "all_per",
    name: "All People",
    description: "Total number if people detected",
    image: "assets/images/people.png",
  ),
   "female":
   Profile(
    id: "1",
    nname: "women_per",

    name: "Female",
    description: "Number of females detected",
    image: "assets/images/female.png",
  ),
  "male":
   Profile(
    id: "2",
    nname: "men_per",

    name: "Male",
    description: "Number of males detected",
    image: "assets/images/male.png",
  ),
  "mkid":
   Profile(
    id: "3",
    nname: "mkid",
    name: "Male Kid",
    description: "Number of male kids detected",
    image: "assets/images/mkid.png",
  ),
  "myoung":
   Profile(
    id: "4",
    nname: "myoung",

    name: "Male Young",
    description: "Number of male youth detected",
    image: "assets/images/myoung.png",
  ),
  "madult":
   Profile(
    id: "5",
    nname: "madult",

    name: "Male Adult",
    description: "Number of male adults detected",
    image: "assets/images/madult.png",
  ),
  "mold":
   Profile(

    id: "6",
    nname: "mold",

    name: "Male Adult",
    description: "Number of male olds detected",
    image: "assets/images/mold.png",
  ),
  "fkid":
   Profile(
    id: "7",
    nname: "fkid",

    name: "Female Kid",
    description: "Number of female kids detected",
    image: "assets/images/fkid.png",
  ),
  "fyoung":
   Profile(

    id: "8",
    nname: "fyoung",
    
    name: "Female Young",
    description: "Number of female youth detected",
    image: "assets/images/fyoung.png",
  ),
  "fadult":
   Profile(
    id: "9",
    nname: "fadult",

    name: "Female Adult",
    description: "Number of female adult detected",
    image: "assets/images/fadult.png",
  ),
  "fold":
   Profile(
    id: "10",
    nname: "fold",

    name: "Female Old",
    description: "Number of female old detected",
    image: "assets/images/fold.png",
  ),
   
};

}


