import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
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
                child: Image.asset("assets/register.png", 
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
              ActionChip(label: const Text("Logout"), onPressed: (){
                logout(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}