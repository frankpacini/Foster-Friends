//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:foster_friends/containers/profiles/profile.dart';
import 'package:foster_friends/main.dart';


// main application build
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchState(0);
  }
}

// building state
class SearchState extends StatefulWidget {
  // SearchState({Key key}) : super(key: key); // have no idea what this is
  final int index;
  SearchState(this.index);
  @override
  SearchStateUser createState() => SearchStateUser(null, "", index);
}

// This is the bottom bar body options
class SearchStateUser extends State<SearchState> {
  
  @override
  void initState(){
    store.dispatch(getFirebaseUser);
  }

  FirebaseUser _user;
  String _userType;
  int _selectedIndex;

  FirebaseUser get user => _user;
  String get userType => _userType;

  SearchStateUser(this._user, this._userType, this._selectedIndex);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[

    Text("Search"),
    Profile()
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    const List<Color> orangeGradients = [
      Color(0xFFFFCC80),
      Color(0xFFFE8853),
      Color(0xFFFEF5350),
    ];
    return Scaffold(
      
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), 
          child: AppBar(
        title: const Text('Foster Friends'), // top bar
        //backgroundColor: Color(0xFFFFCC80),
        flexibleSpace: 
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
        
      )),
      
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Contruction of navigation
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Color(0xFFFFCC80),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}