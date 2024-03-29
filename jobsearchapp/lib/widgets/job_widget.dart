import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobsearchapp/Services/global_methode.dart';
import 'package:jobsearchapp/jobs/job_details.dart';

class JobWidget extends StatefulWidget {


  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;
  const JobWidget({
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location
});


  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {


  final FirebaseAuth _auth = FirebaseAuth.instance;


  _deleteDialoag(){
    User? user = _auth.currentUser;
    final _uid =user!.uid;
    showDialog(
        context: context,
        builder: (ctx){
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () async{
                  try{
                    if(widget.uploadedBy == _uid)
                    {
                      await FirebaseFirestore.instance.collection('jobs')
                          .doc(widget.jobId)
                          .delete();
                      await Fluttertoast.showToast(
                        msg: 'Jobs has been deleted',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18.0,
                      );
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    }
                    else
                    {
                      GlobalMethod.showErrorDialog(
                          error: 'Tum se na ho pyi',
                          ctx: context);
                    }
                  }
                  catch(error)
                  {
                    GlobalMethod.showErrorDialog(
                        error: 'ye bhi tum se na ho pyi',
                        ctx: context);
                  }finally{}

                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete,color: Colors.red,),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),

                    )
                  ],
                )
            ),
          ],
        );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return  Card(
      color:Colors.white24 ,
      elevation: 8,
      margin: const  EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: ListTile(
        onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(
              uploadedBy: widget.uploadedBy,
              jobID: widget.jobId,
            )),);
                  },
        onLongPress: (){
          _deleteDialoag();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right:BorderSide(width: 1)
            )
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),

          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),


      ),
    );
  }
}
