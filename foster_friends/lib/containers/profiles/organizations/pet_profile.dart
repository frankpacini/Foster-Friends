import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/database.dart';

// Define a custom Form widget.
class PetProfile extends StatefulWidget {
  final data;

  PetProfile(this.data);

  @override
  PetState createState() {
    return PetState(this.data);
  }
}

List<bool> isSelected = [false];

class PetState extends State<PetProfile> {
  Map<String, dynamic> data;

  PetState(this.data);

  @override
  void initState() {
    // data = ModalRoute.of(context).settings.arguments;
    String petID = data['id'];
    if(store.state.userData != null){
      List<Map<String, dynamic>> favPets = store.state.userData['pets'];
      
      for (Map pet in favPets) {
        if (pet['id'] == petID) {
          isSelected[0] = true;
        } else {
          isSelected[0] = false;
        }
      }
    }
    print("initial is $isSelected");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        print("hiiii $isSelected");
        await toggleFavPet(data['id'], isSelected[0]).then((value) => store
            .dispatch(getFirebaseUser)
            .then((value) => store.dispatch( new UpdateQueryAction(store.state.query) )));
        setState(() {});
        return true;
      },
      child: Container(
          child: Scaffold(
              appBar: AppBar(actions: <Widget>[
                // action button
                ToggleButtons(
                  children: [
                    Icon(
                      Icons.favorite,
                    )
                  ],
                  isSelected: isSelected,
                  selectedColor: Colors.red,
                  color: Colors.black26,
                  fillColor: Colors.white,
                  borderColor: Colors.white,
                  selectedBorderColor: Colors.white,
                  splashColor: Colors.white,
                  onPressed: (int index) {
                    print("hi $isSelected");

                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });

                    print("bye $isSelected");
                  },
                )
              ]),
              body: Container(
                  margin: EdgeInsets.all(20),
                  child: ListView(
                      //mainAxisAlignment: MainAxisAlignment.start,

                      shrinkWrap: true,
                      children: <Widget>[
                        Image.network(data['image'],
                            height: 200, width: 400, fit: BoxFit.cover),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.center,
                          child: Text(data['name'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'roboto',
                                  fontSize: 40.0,
                                  letterSpacing: 1.5)),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            data['description'],
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'roboto',
                                fontSize: 20.0,
                                letterSpacing: 1.5),
                          ),
                        ),
                        SizedBox(height: 30),
                        Visibility(
                          visible: data['organization'] ==
                              store.state.userData['name'],
                          child: FlatButton(
                              child: Text('Edit Pet Profile'),
                              color: Colors.black12,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/Edit_Pet_Profile',
                                    arguments: data);
                              }),
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(height: 30),
                        Column(children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Pet Type",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5)),
                                Text(data['type'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5))
                              ]),
                          SizedBox(height: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Breed",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5)),
                                Text(data['breed'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5))
                              ]),
                          SizedBox(height: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Organization",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5)),
                                Text(data['organization'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5))
                              ]),
                          SizedBox(height: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Activity Level",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5)),
                                Text(data['activityLevel'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5))
                              ]),
                          SizedBox(height: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Gender",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5)),
                                Text(data['sex'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5))
                              ]),
                          SizedBox(height: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Age",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5)),
                                Text(data['age'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5))
                              ]),
                          SizedBox(height: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Organization Address",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5)),
                                Text(data['orgAddress'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 15.0,
                                        letterSpacing: 1.5))
                              ]),
                        ]),
                      ])))),
    );
  }
}
