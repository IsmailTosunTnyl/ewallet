import 'package:ewallet/profile.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ewallet/models/user.dart';

void main() async {
  var settings = new ConnectionSettings(
      host: '192.168.1.30',
      port: 3306,
      user: 'root',
      password: '',
      db: 'ybblog');
  var conn = await MySqlConnection.connect(settings);
  runApp(MyApp(
    conn: conn,
  ));
}

class MyApp extends StatelessWidget {
  var conn;
  MyApp({super.key, this.conn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        conn: conn,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  var conn;
  MyHomePage({super.key, required this.title, this.conn});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // get data from text fields create controller
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // create a fields for email and password
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // get data from text fields
                var email = emailController.text;
                var password = passwordController.text;
                // print data to console
                print('Email: $email');
                print('Password: $password');
                // check if user in database
                widget.conn.query(
                    'select * from users where email = ? and password = ?',
                    [email, password]).then((results) {
                  if (results.isNotEmpty) {
                    // if user exists

                    var data = results.first;
                    print(data);
                    User user = User(
                      email: data['email'].toString(),
                      name: data['name'].toString() +
                          ' ' +
                          data['lastName'].toString(),
                      id: data['id'],
                      password: data['password'].toString(),
                    );
                    // go to profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          conn: widget.conn,
                          user: user,
                        ),
                      ),
                    );
                  } else {
                    // if user not exists show error message in dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Error',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          content: Text('Email or Password is incorrect'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
