import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foster_friends/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './main.dart';

class UploadPetForm extends StatefulWidget {
  @override
  UploadPetFormState createState() {
    return UploadPetFormState();
  }
}

class UploadPetFormState extends State<UploadPetForm> {
  // -------------------------- map location function -----------------------
  String _locationMessageCoordinate = "Get Coordinate";
  String _locationMessageAddress = "Use Org Address";
  Geoflutterfire geo = Geoflutterfire();
  String petLocation1 = "";
  String petLocation2 = "";
  void _getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessageCoordinate = "Coordinates Get!";
      petLocation1 = "${position.latitude},${position.longitude}";
      print(petLocation1);
      //print(_organizations);
    });
  }
  void _getCurrentLocation2() async {
    String userID = "";
    FirebaseUser user  = await getCurrentUser();
    userID = user.uid;
    String temp;
    Firestore.instance.collection("organizations").document(userID).get().then((onValue) {
      temp = onValue.data["name"];
      //print(onValue.data['description']);
    });
    setState(() {
      //var temp = Firestore.instance.collection("organizations").snapshots();
      //_locationMessageAddress = temp.data.documents[user.uid]['address'];
      _locationMessageCoordinate = "Org Address Get!";
      petLocation2 = temp;
    });
  }
  // -------------------------- save user inputs ----------------------------
  final petAge = TextEditingController();
  final petBreed = TextEditingController();
  final petDescription = TextEditingController();
  final petName = TextEditingController();
  final petSex = TextEditingController();
  final petActivityLevel = TextEditingController();
  final petType = TextEditingController();
  final petOrganization = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    petName.dispose();
    petBreed.dispose();
    petDescription.dispose();
    petName.dispose();
    petSex.dispose();
    petActivityLevel.dispose();
    petType.dispose();
    petOrganization.dispose();
    super.dispose();
  }


  // -------------------------- variables for pet type, breed, sex dropdown menu ----------------------------
  //static Map<String, List<String>> map = {'Dog':['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'],'Cat':['Maine Coon','Bengal','Siamese'],'Bird':['Maine Coon','Bengal','Siamese']};
  List<String> _petTypes = ['Dog', 'Cat', 'Bird'];
  List<String> _dogBreed = ['Labrador Retrievers', 'German Shepherd Dogs', 'Golden Retrievers'];
  List<String> _catBreed = ['Maine Coon','Bengal','Siamese'];
  List<String> _birdBreed = [''];
  static List<String> _breedType = [];
  String _selectedPetTypes;
  String _selectedBreedTypes;
  String _selectedSex;
  String _selectedActivityLevel;
  List<String> _sex = ['Female','Male'];
  List<String> _activity = ['High','Medium','Low'];

  // -------------------------- variables for shelter name dropdown menu ----------------------------
  //List<String> _shelters = Firestore.instance.collection("organizations").getDocuments() as List<String>;
  //Future<QuerySnapshot> ref = Firestore.instance.collectionGroup("organizations").getDocuments();
  //Firestore.instance.collection('organizations').snapshots().listen((data) => data.documents.forEach((doc) => print(doc["name"])));
  static List<String> _organizations;
  String _selectedOrganization;
  //StreamSubscription<QuerySnapshot> getOrganizations = Firestore.instance.collection('organizations')
  //  .snapshots().listen(
  //        (data) => _organizations.add('${data.documents[0]['name']}')
  //  );
  void _getOrganizations() async {
    
    QuerySnapshot querySnapshot = await Firestore.instance.collection("collection").getDocuments().then((onValue){
      return onValue;
    });
    print(querySnapshot);
    //var list = querySnapshot.documents;
   // Firestore.instance.collection("collection").getDocuments().then((onValue) {
    //  _organizations.add(onValue.data["name"]);
    //});
    setState(() {
      _organizations = ["list"];
    });
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Thank you for submitting a pet!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                //Navigator.popUntil(context, ModalRoute.withName("/Landing"));
                Navigator.popAndPushNamed(context, "/Landing");
              },
            ),
          ],
        );
      },
    );
  }

  // -------------------------- enable / disable SUBMIT button ----------------------------
  bool _enabled = false;

  Color color = const Color(0xFFFFCC80);
  @override
  Widget build(BuildContext context) {

    var _onPressed;
    if (petName!= "" && petAge!="" && petOrganization!="" && petType!="" && petBreed!="" && petSex!="" && petActivityLevel!="" && petDescription!="" && (petLocation1!="" || petLocation2!="")) {
      _onPressed = () async {
        DocumentReference ref = Firestore.instance.collection("pets").document();
        String petId = ref.documentID;
        await ref.setData({
                "id": petId,
                "age": petAge.text,
                "breed": petBreed.text,
                "description": petDescription.text,
                "geolocation": new GeoPoint(double.parse(petLocation1.split(",")[0]),double.parse(petLocation1.split(",")[1])),
                "orgAddress": petLocation2,
                "name": petName.text,
                "sex": petSex.text,
                "activityLevel": petActivityLevel.text,
                "type": petType.text,
                "organization": petOrganization.text,
              });
        print("haro");
        _showDialog();
      };
    }
    const List<Color> orangeGradients = [
      Color(0xFFFFCC80),
      Color(0xFFFE8853),
      Color(0xFFFEF5350),
    ];
    return Column(children: <Widget>[
      ClipPath(
        clipper: TopWaveClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: orangeGradients,
                begin: Alignment.topLeft,
                end: Alignment.center),
          ),
          height: MediaQuery.of(context).size.height / 7.5,
        ),
      ),
      TextFormField(
          decoration: const InputDecoration(
            hintText: 'Pet Name',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet name';
            }
            return null;
          },
          controller: petName,
          ),
      TextFormField(
          decoration: const InputDecoration(
            hintText: 'Pet Age',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet age';
            }
            return null;
          },
          controller: petAge,
          ),
      StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("organizations").snapshots(),
        builder: (context,snapshot) {
          if(!snapshot.hasData) {
            Text("Loading");
          }
          else {
            List<DropdownMenuItem> organinzationsItems = [];
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              DocumentSnapshot snap = snapshot.data.documents[i];
              String temp = "";
              Firestore.instance.collection("organizations").document(snap.documentID).get().then((onValue) {
                temp = onValue.data["name"];
                print(onValue.data['name']);
                organinzationsItems.add(
                  DropdownMenuItem (child: Text(
                    onValue.data['name'],
                    ),
                  value: onValue.data['name'],
                )
              );
              });
              
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton(
                  hint: Text('Organization'),
                  items: organinzationsItems,
                  onChanged: (organizationsValue){
                    setState(() {
                      _selectedOrganization = organizationsValue;
                      petOrganization.text = organizationsValue;
                    });
                  },
                  value: _selectedOrganization,
                )
              ],
            );
          }
        },
      ),
      DropdownButton(
            hint: Text('Select a Pet Type'), // Not necessary for Option 1
            value: _selectedPetTypes,
            onChanged: (newValue) {
              _selectedBreedTypes = null;
              setState(() {
                petType.text = newValue;
                _selectedPetTypes = newValue;
                if (newValue == "Dog") {
                  _breedType = _dogBreed;
                } else if (newValue == "Cat") {
                  _breedType = _catBreed;
                } else if (newValue == "Bird") {
                  _breedType = _birdBreed;
                }
              });
            },
            items: _petTypes.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),
      DropdownButton(
        hint: Text('Select a Breed Type'), // Not necessary for Option 1
        value: _selectedBreedTypes,
        onChanged: (newValue) {
          setState(() {
            petBreed.text = newValue;
            _selectedBreedTypes = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _breedType.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      DropdownButton(
        hint: Text('Select a Sex'), // Not necessary for Option 1
        value: _selectedSex,
        onChanged: (newValue) {
          setState(() {
            petSex.text = newValue;
            _selectedSex = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _sex.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      DropdownButton(
        hint: Text('Select an Activity Level'), // Not necessary for Option 1
        value: _selectedActivityLevel,
        onChanged: (newValue) {
          setState(() {
            petActivityLevel.text = newValue;
            _selectedActivityLevel = newValue;
          });
        },
        // ??????????????????????? if () _breedType
        items: _activity.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            hintText: 'Pet Description',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a pet description';
            }
            return null;
          },
          controller: petDescription,
          ),
      Row (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FlatButton(
              color: color,
              child: Text(_locationMessageCoordinate),
              onPressed: () {
                _getCurrentLocation();
              }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: FlatButton(
              color: color,
              child: Text(_locationMessageAddress),
              onPressed: () {
                _getCurrentLocation2();
              }
            ),
          )
        ]
      ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Center(
              child: RaisedButton(
                color: Theme.of(context).buttonColor,
                onPressed: _onPressed,
                child: Text("SUBMIT",
                style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).backgroundColor)),
              ))),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
                
                child: Text("CANCEL",
                  style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          )),
                
              ))),
              
    ])
    ;
    
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    //creating first curver near bottom left corner
    var firstControlPoint = new Offset(size.width / 7, size.height - 80);
    var firstEndPoint = new Offset(size.width / 2, size.height / 2);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //creating second curver near center
    var secondControlPoint = Offset(size.width / 2, size.height / 5);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    //creating third curver near top right corner
    var thirdControlPoint = Offset(size.width - (size.width / 11), size.height / 5);
    var thirdEndPoint = Offset(size.width, 0.0);
    
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move to top right corner
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }
  
  

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}