 /*
 Center(
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
                              gradient: LinearGradient(colors: [
                            Colors.blue,
                            Colors.lightBlueAccent
                          ])),
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
                      gradient: LinearGradient(colors: [
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


          */