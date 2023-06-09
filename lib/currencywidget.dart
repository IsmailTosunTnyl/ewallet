import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyWidget extends StatefulWidget {
  CurrencyWidget(
      {Key? key,
      required this.title,
      required this.currency,
      required this.image,
      required this.user})
      : super(key: key);

  final String title;
  double currency;
  final String image;
  final User user;

  @override
  _CurrencyWidgetState createState() => _CurrencyWidgetState();
}

class _CurrencyWidgetState extends State<CurrencyWidget> {
  Future<Map<String, dynamic>> fetchData() async {
    var response = await http.get(Uri.parse(
        'http://192.168.1.30:5000/GetHistory/${widget.user.id}/${widget.title}'));
    print(
        'http://192.168.1.30:5000/GetHistory/${widget.user.id}/${widget.title}');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                height: 400,
                width: 100,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      child: Dialog(
                        child: SingleChildScrollView(
                          child: Container(
                              child: Column(
                            children: [
                              Text(
                                "History",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FutureBuilder<Map<String, dynamic>>(
                                future: fetchData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    Map<String, dynamic> responseData =
                                        snapshot.data!;
                                    List<dynamic> historyList =
                                        responseData['history'];
                                    double sum = responseData['sum'];

                                    return SizedBox(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: historyList.length,
                                              itemBuilder: (context, index) {
                                                Map<String, dynamic>
                                                    historyItem =
                                                    historyList[index];
                                                return ListTile(
                                                  title: Text(
                                                      'Amount: ${historyItem['amount']}'),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Date: ${historyItem['date']}'),
                                                      Text(
                                                          'DateFec: ${historyItem['dateFec']}'),
                                                      Text(
                                                          'Money Type: ${historyItem['moneyType']}'),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Text('Gain: $sum',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: Text('No data available'));
                                  }
                                },
                              )
                            ],
                          )),
                        ),
                      ),
                    );
                  },
                ),
              );
            });
      },
      onDoubleTap: () {
        // showDialog to show about dialog
        var date = DateTime.now();
        showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text(
                      'Buy ${widget.title}',
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      // add textfiled thats takes only number
                      // add date picker
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            padding: EdgeInsets.all(10),
                            // add ouyline
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green)),
                            child: Image.network(widget.image,
                                width: 50, height: 50)),
                        SizedBox(height: 10),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              hintText: 'Enter Amounth',
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              widget.currency = double.parse(value);
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 200,
                          child: OutlinedButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2021),
                                        lastDate: DateTime(2024))
                                    .then((value) {
                                  setState(() {
                                    date = value!;
                                  });
                                });
                              },
                              child: Text(date.toString().substring(0, 10))),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                            onPressed: () async {
                              String amount = _controller.text;

                              // make a post request to the server
                              String url =
                                  "http://192.168.1.30:5000/Kaydet/${widget.user.id}/${widget.title}/${amount}/${date.toString().substring(0, 10)}";

                              try {
                                final response =
                                    await http.post(Uri.parse(url));
                                if (response.statusCode == 200) {
                                  // POST request successful
                                  print('POST request successful!');
                                  // Handle the response data if needed
                                } else {
                                  // Failed to send POST request
                                  print(
                                      'Failed to send POST request. Status code: ${response.statusCode}');
                                  // Handle the error or check the response content for more details
                                }
                              } catch (error) {
                                // Exception occurred during POST request
                                print('Error: $error');
                                // Handle the error
                              }
                              Navigator.pop(context);
                              print(url);
                            },
                            child: Text('Buy Now')),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'))
                    ],
                  );
                }),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        // add gradient background and radius
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
                colors: [Colors.blue, Color.fromARGB(255, 27, 177, 24)])),
        // radius for card

        child: Card(
          margin: EdgeInsets.all(5),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 150,
            height: 180,
            child: Column(
              children: [
                Image.network(widget.image, width: 50, height: 50),
                SizedBox(height: 10),
                Text(widget.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.middleInitial)),
                Text('${widget.currency}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
