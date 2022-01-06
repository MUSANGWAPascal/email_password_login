import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';


class MyDistrict extends StatefulWidget {
  const MyDistrict({Key? key}) : super(key: key);

  @override
  State<MyDistrict> createState() => _MyDistrictState();
}

class _MyDistrictState extends State<MyDistrict> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetching Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  const DataFromAPI({Key? key}) : super(key: key);

  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future fetchDistricts() async{

    var url = await http.get(Uri.parse("https://pascalrestoapi.azurewebsites.net/api/v1/district/"));

    var jsonData = json.decode(url.body);
    List<District> districts=[];

    for(var data in jsonData){
      District dish = District(data["district_name"]);

      districts.add(dish);
    }
    return districts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
        "All Districts",
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'times new roman',
        ),
      ),
        centerTitle: true,
        elevation: 20.0,
      ),
      body: Card(
        child: FutureBuilder(
            future: fetchDistricts(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.data == null){
                return const Center(
                  child: Text(
                    "",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                );
              }
              else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i){
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                          ),
                          title: Text(snapshot.data[i].name),
                          subtitle: const Text("District"),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      );
                    });
              }
            }

        ),
      ),
    );
  }
}

class District{
  final String name;

  District(this.name);
}
