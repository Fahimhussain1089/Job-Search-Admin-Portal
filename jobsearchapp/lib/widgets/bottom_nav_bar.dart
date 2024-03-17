import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobsearchapp/Search/profile_company.dart';
import 'package:jobsearchapp/Search/search_companies.dart';
import 'package:jobsearchapp/jobs/jobs_screens.dart';
import 'package:jobsearchapp/jobs/upload_job.dart';
import 'package:jobsearchapp/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {
 // const BottomNavigationBarForApp({super.key});
  int indexNum = 0;


  BottomNavigationBarForApp({required this.indexNum});

  void _logout(context){
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(context: context,
        builder: (context){
      return  AlertDialog(
        backgroundColor: Colors.black54,
        title: const  Row(
          children: [
            Padding(padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 35,
              ),),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),

            )
          ],
        ),
        //
        content: const Text(
            'Do you want to Log out? ',
          style: TextStyle(color: Colors.white,fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child:const  Text('No',style: TextStyle(color: Colors.green,fontSize: 20),
              ),
          ),
          TextButton(
            onPressed: (){
              _auth.signOut();
              Navigator.canPop(context) ? Navigator.pop(context) : null;
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => UserState()),);
            },
            child:const  Text('Yes',style: TextStyle(color: Colors.green,fontSize: 20),
            ),
          ),

        ],
      );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Color(0xFFbeb15b),
      backgroundColor: Color(0xFFd5cfac),
      buttonBackgroundColor: Color(0xFF5d5d3c),
      height: 50,

      index: indexNum,
        items:const [
          Icon(Icons.list,size: 20,color: Colors.black),
          Icon(Icons.search,size: 20,color: Colors.black),
           Icon(Icons.add,size: 20,color: Colors.black),
           Icon(Icons.person_pin,size: 20,color: Colors.black),
          Icon(Icons.exit_to_app,size: 20,color: Colors.black),

        ],

      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.easeInOutCubicEmphasized,

      onTap: (index)
        {
          if(index == 0 )
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => JobScreen() ),);
          }
          else if(index == 1)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllWorkerScreen() ),);
          } else if(index == 2)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UploadJoabNow() ),);
          }else if(index == 3)
          {
            final FirebaseAuth _auth = FirebaseAuth.instance;
            final User? user = _auth.currentUser;
            final String uid = user!.uid;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen(
              userID: uid,
            ) ),);
          }else if(index == 4)
          {
            _logout(context);
          }

        }
     );
  }
}
