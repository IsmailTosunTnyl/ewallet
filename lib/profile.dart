// create empty page

import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/user.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  var conn;
  User user;
  Profile({super.key, required this.conn, required this.user});

  @override
  _ProfileState createState() => _ProfileState(conn: conn, user: user);
}

class _ProfileState extends State<Profile> {
  Future<List<MapEntry<String, String>>> fetchData() async {
    var response = await http.get(Uri.parse(
        'http://192.168.1.30:5000/currency')); // Replace 'API_URL' with the actual URL of your API
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Map<String, dynamic> jsonData = Map<String, dynamic>.from(data);
      List<MapEntry<String, String>> keyValueList = jsonData.entries
          .map((entry) => MapEntry(entry.key, entry.value.toString()))
          .toList();
      print(keyValueList);
      return keyValueList;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  var conn;
  User user;
  _ProfileState({this.conn, required this.user});

  @override
  Widget build(BuildContext context) {
    // create list for images
    var images = {
      "EUR":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Euro_symbol_black.svg/2010px-Euro_symbol_black.svg.png",
      "GBP": "https://cdn0.iconfinder.com/data/icons/london-3/34/21-512.png",
      "BTC":
          "https://altcoinsbox.com/wp-content/uploads/2023/02/bitcoin-gold-coin-with-BTC-logo.webp",
      "SILVER":
          "https://www.pngall.com/wp-content/uploads/5/Plain-Silver-Coin.png",
      "GOLD": "https://www.pngall.com/wp-content/uploads/4/Empty-Gold-Coin.png",
      "USD": "https://cdn-icons-png.flaticon.com/512/32/32899.png"
    };
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          children: [
            // show User Icon and name
            Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                // add gradient background
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.blue,
                  Color.fromARGB(255, 27, 177, 24)
                ])),
                child: Card(
                    // add gradient background

                    child: Container(
                      padding: EdgeInsets.all(10),
                      // add gradient background
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent])),
                      child: Column(
                        children: [
                          Icon(Icons.person, size: 100),
                          Text('${user.name}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AutofillHints.middleInitial)),
                          Text(' ${user.email}'),
                        ],
                      ),
                    ),
                    elevation: 10)),

            // design a card thats start with icon then text then button
            Text('Currency Exchange',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: AutofillHints.middleInitial)),
            SizedBox(height: 5),
            Container(
              // give margin horizontal
              margin: EdgeInsets.symmetric(horizontal: 20),
              // add radius to card
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [Colors.blue, Color.fromARGB(255, 27, 177, 24)])),
              child: Card(
                elevation: 10,
                // add radius to card

                child: FutureBuilder<List<MapEntry<String, String>>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<MapEntry<String, String>> keyValueList =
                          snapshot.data!;
                      return Container(
                        // male lighgray background
                        color: Colors.grey[200],
                        height: 350,
                        child: ListView.builder(
                          itemCount: keyValueList.length,
                          itemBuilder: (context, index) {
                            String key = keyValueList[index].key;
                            String value = keyValueList[index].value;
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: Image.network(
                                  images[key]!,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(key),
                                subtitle: Text(value),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
