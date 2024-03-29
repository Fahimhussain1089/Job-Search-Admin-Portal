import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobsearchapp/Persistent/persistent.dart';
import 'package:jobsearchapp/Search/search_joc.dart';
import 'package:jobsearchapp/user_state.dart';
import 'package:jobsearchapp/widgets/bottom_nav_bar.dart';
import 'package:jobsearchapp/widgets/job_widget.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  String? jobCategoryFilter;


  final FirebaseAuth _auth = FirebaseAuth.instance;


//here is the methode for filter job
  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color(0xFFd5cfac),
            title: Text('Job Categorys',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, color: Colors.black, fontFamily: 'Signatra'),
            ),


            content: Container(
              width: size.width * 0.9,
              height: size.height * 0.5,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.jobCategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          jobCategoryFilter = Persistent.jobCategoryList[index];
                        });
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                        print(
                          'jobCategoryList[index], ${Persistent.jobCategoryList[index]}'
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.green,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Persistent.jobCategoryList[index],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFbeb15b),// Set the background color to green
                ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                    onPressed: (){
                      setState(() {
                        jobCategoryFilter = null;
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;

                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFbeb15b),// Set the background color to green
                    ),
                    child: const Text('Cancel Filter',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                ),
              ],

          );
        }
    );
  }
  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFbeb15b),
            Color(0xFFd5cfac)
          ],
          begin: Alignment.topCenter,
          end: Alignment.centerRight,
          stops: [0.2,0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum:0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
         // title:  const Text('Jobs Screen'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const  BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFbeb15b),
                      Color(0xFFd5cfac)],
                    begin: Alignment.topCenter,
                    end: Alignment.centerRight,
                    stops: const[0.2,0.9]
                )
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.filter_list,color: Colors.black,),
            onPressed: (){
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded,color: Colors.black,),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()),);
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobCategory',isEqualTo: jobCategoryFilter)
              .where('recruitment',isEqualTo: true)
              .orderBy('createdAt',descending: false)
              .snapshots(),
          builder: (context,AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator(),);
              }
            else if(snapshot.connectionState == ConnectionState.active)
              {
                if(snapshot.data?.docs.isNotEmpty == true)
                  {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder:(BuildContext context,int index)
                        {
                          return JobWidget(
                            jobTitle: snapshot.data?.docs[index]['jobTitle'],
                            jobDescription: snapshot.data?.docs[index]['jobDescription'],
                            jobId: snapshot.data?.docs[index]['jobId'],
                            uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                            userImage: snapshot.data?.docs[index]['userImage'],
                            name: snapshot.data?.docs[index]['name'],
                            recruitment: snapshot.data?.docs[index]['recruitment'],
                            email: snapshot.data?.docs[index]['email'],
                            location: snapshot.data?.docs[index]['location'],


                          );
                        }
                    );
                  }
                else {
                  return const Center(
                    child: Text('There is no jobs'),
                  );
                }
              }
            return Center(
              child: Text(
                'Something Went wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 30,
                ),
              ),
            );
          }
        ),

      ),
    );
  }
}
//lecture will be start