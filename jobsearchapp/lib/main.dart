

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jobsearchapp/LogingPage/login_screen.dart';
import 'package:jobsearchapp/firebase_options.dart';
import 'package:jobsearchapp/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform//add here new
   );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
 // const MyApp({super.key});
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context,snapshot)
        {
          if(snapshot.connectionState == ConnectionState.waiting)
             {
              return const MaterialApp(
                home: Scaffold(
                    body: Center(
                      child: Text("this sis testing of firebase is working or not ",style: TextStyle(
                        color: Colors.red,
                        fontSize: 40,
                        fontWeight: FontWeight.bold

                      ),
                      ),

                    ),

                ),
              );
            }
          else if(snapshot.hasError){
            return const  MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text("an error has been occured ",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 40,fontWeight: FontWeight.bold

                    ),),

                ),
              ),
            );
          }
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "jobsearch app",
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primaryColor: Colors.blue,
            ),
           // home: Login(),
            home: UserState(),
          );



        }
    );
  }
}
