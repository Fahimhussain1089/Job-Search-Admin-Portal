import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobsearchapp/jobs/jobs_screens.dart';
import 'package:jobsearchapp/widgets/job_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';


//this is explain in 87 lecture
  Widget _buildSearchField(){
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const  InputDecoration(
        hintText: 'Search for jobs... ',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white)
      ),
      style: const  TextStyle(color: Colors.white,fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }
  List<Widget> _buildActions(){
    return <Widget>[
      IconButton(
          onPressed: (){
            _clearSearchQuery();
          },
          icon: Icon(Icons.clear),
      ),
    ];
  }
  //here is the methode ,to above methode to clear it
  void _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery){
    setState(() {
       searchQuery = newQuery;
       print(searchQuery);
    });
  }




  @override
  Widget build(BuildContext context) {
    return  Container(
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
        backgroundColor: Colors.transparent,
        appBar:  AppBar(
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
          leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobScreen()));
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
          ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
            .where('recruitment',isEqualTo: true)
            .snapshots(),
          builder: (context,AsyncSnapshot snapshot){
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
                        itemBuilder: (BuildContext context, int index){
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
                else{
                  return const Center(
                    child: Text(
                      'There is no jobs',
                      // style: TextStyle(
                      //   fontSize: 30,
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                  );
                }
              }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        ),
      );









  }
}
//start at the 89 lecture 