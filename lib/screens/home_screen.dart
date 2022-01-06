import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/districts.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        setState(() {
          
        });
      } 
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Image.asset("assets/resto.jpg", 
                fit: BoxFit.contain,),
              ),
              const Text("Welcome Back", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(
                height: 20,
                child: Text("${loggedInUser.firstName} ${loggedInUser.secondName}", style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),)
              ),
              SizedBox(
                height: 40,
                child: Text("${loggedInUser.email}", style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              ),
              const SizedBox(
                height: 45,
              ),
            ],
          ),
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Future<void> logout(BuildContext context) async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 20,
      iconSize: 36,
      selectedItemColor: Colors.amberAccent,
      backgroundColor: Colors.red,
      currentIndex: selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.house_outlined),
          label: 'Districts',
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({ Key? key }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Restaurant Menus',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/burger.png'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()))
            },
          ),
           ListTile(
            leading: Icon(Icons.room_service),
            title: Text('Districts'),
            onTap: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyDistrict()))
            },
          ),
          ListTile(
            iconColor: Colors.red,
            textColor: Colors.red,
            leading: Icon(Icons.vpn_key),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop(logout(context))},
          ),
        ],
      ),
    );
  }
  Future<void> logout(BuildContext context) async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}