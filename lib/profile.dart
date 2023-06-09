// create empty page

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/user.dart';
import 'package:http/http.dart' as http;
import 'package:ewallet/currencywidget.dart';
import 'package:ewallet/models/article.dart';

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

      return keyValueList;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<List<MapEntry<String, String>>> fetchpersonal() async {
    var response = await http.get(Uri.parse(
        'http://192.168.1.30:5000/person/${user.email}')); // Replace 'API_URL' with the actual URL of your API
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Map<String, dynamic> jsonData = Map<String, dynamic>.from(data);
      List<MapEntry<String, String>> keyValueList = jsonData.entries
          .map((entry) => MapEntry(entry.key, entry.value.toString()))
          .toList();
      return keyValueList;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<List<dynamic>> fetcharticletr(String country) async {
    var response =
        await http.get(Uri.parse('http://192.168.1.30:5000/news/$country'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;

      return data;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  var conn;
  User user;
  _ProfileState({this.conn, required this.user});
  int currentPageIndex = 0;
  var newstr = [];
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
      "USD": "https://cdn-icons-png.flaticon.com/512/32/32899.png",
      "toplam": "https://cdn-icons-png.flaticon.com/512/6429/6429538.png"
    };

    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.newspaper),
              icon: Icon(Icons.newspaper),
              label: 'News',
            ),
          ],
        ),
        appBar: AppBar(
            title: const Text(
          'E-Wallet',
          textAlign: TextAlign.center,
        )),
        body: [
          Center(
            child: Column(
              children: [
                // show User Icon and name

                Container(
                  width: double.infinity,
                  height: 160,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // add gradient
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Color.fromARGB(255, 27, 177, 24)
                      ], // whitish to gray
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.discordapp.com/attachments/765687983076540486/1116700285251899422/2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // design a card thats start with icon then text then button
                const Text('Currency Exchange',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.middleInitial)),
                const SizedBox(height: 5),
                Container(
                  // give margin horizontal
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  // add radius to card
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Colors.blue,
                        Color.fromARGB(255, 27, 177, 24)
                      ])),
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
                            height: 445,
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
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // PROFILE PAGE
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: 172,
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      // add gradient background
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.blue,
                        Color.fromARGB(255, 27, 177, 24)
                      ])),
                      child: Card(
                          // add gradient background

                          child: Container(
                            padding: const EdgeInsets.all(10),
                            // add gradient background
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.blue,
                              Colors.lightBlueAccent
                            ])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.person, size: 100),
                                Text('${user.name}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            AutofillHints.middleInitial)),
                                Text(' ${user.email}'),
                              ],
                            ),
                          ),
                          elevation: 10)),
                  Container(
                    height: 400,
                    child: FutureBuilder<List<MapEntry<String, String>>>(
                      future: fetchpersonal(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<MapEntry<String, String>> keyValueList =
                              snapshot.data!;
                          keyValueList.forEach((element) {
                            print(element.key);
                            print(element.value);
                          });

                          return SingleChildScrollView(
                            child: Container(
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // design card for user money for each currency
                                    CurrencyWidget(
                                      user: user,
                                      title: 'EUR',
                                      currency: double.parse(
                                          keyValueList[2].value.toString()),
                                      image: images["EUR"] as String,
                                    ),
                                    CurrencyWidget(
                                      user: user,
                                      title: 'GBP',
                                      currency: double.parse(
                                          keyValueList[5].value.toString()),
                                      image: images["GBP"] as String,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CurrencyWidget(
                                      user: user,
                                      title: 'BTC',
                                      currency: double.parse(
                                          keyValueList[0].value.toString()),
                                      image: images["BTC"] as String,
                                    ),
                                    CurrencyWidget(
                                      user: user,
                                      title: 'SILVER',
                                      currency: double.parse(
                                          keyValueList[4].value.toString()),
                                      image: images["SILVER"] as String,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CurrencyWidget(
                                      user: user,
                                      title: 'GOLD',
                                      currency: double.parse(
                                          keyValueList[3].value.toString()),
                                      image: images["GOLD"] as String,
                                    ),
                                    CurrencyWidget(
                                      user: user,
                                      title: 'USD',
                                      currency: double.parse(
                                          keyValueList[1].value.toString()),
                                      image: images["USD"] as String,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CurrencyWidget(
                                      user: user,
                                      title: 'Total (TL)',
                                      currency: double.parse(
                                          keyValueList[6].value.toString()),
                                      image: images["toplam"] as String,
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Container(
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  height: 172,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  // add gradient background
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blue,
                    Color.fromARGB(255, 27, 177, 24)
                  ])),
                  child: Card(
                    color: Colors.grey[200],
                    child: Column(children: [
                      Icon(Icons.newspaper_rounded, size: 100),
                      Text("News is Here", style: TextStyle(fontSize: 20)),
                      Text("All news about business and economy"),
                    ]),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text("News Turkey",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Container(
                            height: 375,
                            width: 350,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            // add gradient background
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.blue,
                              Color.fromARGB(255, 27, 177, 24)
                            ])),
                            child: Card(
                                color: Colors.grey[200],
                                child: FutureBuilder<List<dynamic>>(
                                  future: fetcharticletr("tr"),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return Text(
                                          'Failed to fetch data from API');
                                    } else {
                                      List<dynamic> data = snapshot.data!;
                                      // get title,author and url in data list,check null
                                      List<Article> articles = [];
                                      for (var i in data) {
                                        if (i["title"] != null &&
                                            i["author"] != null &&
                                            i["url"] != null) {
                                          articles.add(Article(
                                              title: i["title"],
                                              link: i["url"],
                                              author: i["author"]));
                                        }
                                      }
                                      for (var i in articles) {
                                        print(i.author);
                                      }

                                      // Burada data ile yapmak istediğiniz işlemleri gerçekleştirebilirsiniz
                                      // Örneğin, bir ListView oluşturup verileri gösterebilirsiniz
                                      return ListView.builder(
                                        itemCount: articles.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              articles[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            subtitle: Text(
                                              articles[index].author,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            onTap: () async {
                                              // open url
                                              await launch(
                                                  articles[index].link);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("News USA",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Container(
                            height: 375,
                            width: 350,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            // add gradient background
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.blue,
                              Color.fromARGB(255, 27, 177, 24)
                            ])),
                            child: Card(
                                color: Colors.grey[200],
                                child: FutureBuilder<List<dynamic>>(
                                  future: fetcharticletr("us"),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return Text(
                                          'Failed to fetch data from API');
                                    } else {
                                      List<dynamic> data = snapshot.data!;
                                      // get title,author and url in data list,check null
                                      List<Article> articles = [];
                                      for (var i in data) {
                                        if (i["title"] != null &&
                                            i["author"] != null &&
                                            i["url"] != null) {
                                          articles.add(Article(
                                              title: i["title"],
                                              link: i["url"],
                                              author: i["author"]));
                                        }
                                      }
                                      for (var i in articles) {
                                        print(i.author);
                                      }

                                      // Burada data ile yapmak istediğiniz işlemleri gerçekleştirebilirsiniz
                                      // Örneğin, bir ListView oluşturup verileri gösterebilirsiniz
                                      return ListView.builder(
                                        itemCount: articles.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              articles[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            subtitle: Text(
                                              articles[index].author,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            onTap: () async {
                                              // open url
                                              await launch(
                                                  articles[index].link);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("News England",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Container(
                            height: 375,
                            width: 350,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            // add gradient background
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.blue,
                              Color.fromARGB(255, 27, 177, 24)
                            ])),
                            child: Card(
                                color: Colors.grey[200],
                                child: FutureBuilder<List<dynamic>>(
                                  future: fetcharticletr("in"),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return Text(
                                          'Failed to fetch data from API');
                                    } else {
                                      List<dynamic> data = snapshot.data!;
                                      // get title,author and url in data list,check null
                                      List<Article> articles = [];
                                      for (var i in data) {
                                        if (i["title"] != null &&
                                            i["author"] != null &&
                                            i["url"] != null) {
                                          articles.add(Article(
                                              title: i["title"],
                                              link: i["url"],
                                              author: i["author"]));
                                        }
                                      }
                                      for (var i in articles) {
                                        print(i.author);
                                      }

                                      // Burada data ile yapmak istediğiniz işlemleri gerçekleştirebilirsiniz
                                      // Örneğin, bir ListView oluşturup verileri gösterebilirsiniz
                                      return ListView.builder(
                                        itemCount: articles.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              articles[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            subtitle: Text(
                                              articles[index].author,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            onTap: () async {
                                              // open url
                                              await launch(
                                                  articles[index].link);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "News France",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 375,
                            width: 350,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            // add gradient background
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.blue,
                              Color.fromARGB(255, 27, 177, 24)
                            ])),
                            child: Card(
                                color: Colors.grey[200],
                                child: FutureBuilder<List<dynamic>>(
                                  future: fetcharticletr("fr"),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return Text(
                                          'Failed to fetch data from API');
                                    } else {
                                      List<dynamic> data = snapshot.data!;
                                      // get title,author and url in data list,check null
                                      List<Article> articles = [];
                                      for (var i in data) {
                                        if (i["title"] != null &&
                                            i["author"] != null &&
                                            i["url"] != null) {
                                          articles.add(Article(
                                              title: i["title"],
                                              link: i["url"],
                                              author: i["author"]));
                                        }
                                      }
                                      for (var i in articles) {
                                        print(i.author);
                                      }

                                      // Burada data ile yapmak istediğiniz işlemleri gerçekleştirebilirsiniz
                                      // Örneğin, bir ListView oluşturup verileri gösterebilirsiniz
                                      return ListView.builder(
                                        itemCount: articles.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              articles[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            subtitle: Text(
                                              articles[index].author,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            onTap: () async {
                                              // open url
                                              await launch(
                                                  articles[index].link);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ][currentPageIndex]);
  }
}
