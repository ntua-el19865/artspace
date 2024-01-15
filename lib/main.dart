import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/provider/provider.dart';
import 'package:untitled2/screens/login.dart';
import 'package:provider/provider.dart';





void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(usrId: null)),
        ChangeNotifierProvider(create: (context) => DesignProvider()),
        ChangeNotifierProvider(create: (context) => LikesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //Our first screen
      home:LoginScreen(),
    );
  }
}
/*void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Space',
      debugShowCheckedModeBanner : false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,

      ),
      home: const Login(title: 'Art Space'),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
            child: Text(widget.title)),
      ),
      body: SafeArea(
              child:Form(
                key: _formKey,
                 child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Padding(
                         padding:
                         const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                         child: TextFormField(
                           controller: emailController,
                           decoration: const InputDecoration(
                             border: OutlineInputBorder(), labelText: "Email"),
                           validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter your email';
                             }
                             return null;
                       },
                     ),
                   ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                         },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (emailController.text == "arun@gogosoon.com" && passwordController.text == "qazxswedcvfr") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        email: emailController.text,
                                      )),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Invalid Credentials')),
                                );
                              }
                            } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill input')),

                            );
                          }
                        },
                        child: const Text('Login'),
                       ),
                     ),
                    ),
                 ],
                ),
              ),
            ),
          )
      );
    }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Center(
              child: Text('Art Space')),
        ),
        body: Column(
          children: [
            Text(email),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Go back!"),
              ),
            ),
          ],
        ));
  }
}*/
/*void main() => runApp(MyApp());

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/register': (BuildContext context) => new SignupScreen(),
  '/': (BuildContext context) => new LoginScreen(),
};

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sqflite App',
      theme: new ThemeData(primarySwatch: Colors.teal),
      routes: routes,
    );
  }
}*/
