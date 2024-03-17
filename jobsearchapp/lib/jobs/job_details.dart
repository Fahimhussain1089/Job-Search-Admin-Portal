import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobsearchapp/Services/global_methode.dart';
import 'package:jobsearchapp/Services/global_variable.dart';
import 'package:jobsearchapp/jobs/jobs_screens.dart';
import 'package:jobsearchapp/widgets/comments_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetailsScreen extends StatefulWidget {
 // const JobDetailsScreen({super.key});
  final String uploadedBy;
  final String jobID;
  const JobDetailsScreen({
    required this.uploadedBy,
    required this.jobID,

});


  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _commentControler = TextEditingController();

  bool _isCommenting = false;


  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants  = 0;
  bool isDeadlineAvaliable = false;

  bool showComment = false;

  //here is the methode for
  void getJobData() async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if(userDoc == null){
      return;
    }
    else
      {
        setState(() {
          authorName = userDoc.get('name');
          userImageUrl =  userDoc.get('userImage');
        });
      }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobID)
        .get();
    if( jobDatabase == null){
      return;
    }
    else
    {
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription=  jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('deadlineDate');
        var postDate =  postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
        });

        var date = deadlineDateTimeStamp!.toDate();
        isDeadlineAvaliable = date.isAfter(DateTime.now());
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  // here is the methode for divider
  Widget dividerWidget()
  {
    return const Column(
      children: [
        SizedBox(height: 10,),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        const SizedBox(height: 10,),
      ],
    );
  }
  //here is the methode for material button in job_detail screen, fot send mail
  applyForJob(){
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query: 'subject=Applying for $jobTitle&body=Hello, please attach Resume CV file',

    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

    void addNewApplicant() async{
      var docRef = FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobID);
      docRef.update({
        'applicants' : applicants + 1 ,
      });
     // Navigator.pop(context);
    }



  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
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
            icon: const  Icon(Icons.close,size: 20,color: Colors.white,),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobScreen()), );
            },
            
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const  EdgeInsets.all(4.0),
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: const  EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const  EdgeInsets.only(left: 4),
                        child: Text(
                          jobTitle == null
                              ?
                             ''
                              :
                              jobTitle!,
                              maxLines: 3,
                              style:  TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.grey,
                              ),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  userImage == null
                                      ?
                                      jobDetailImage
                                      :
                                      userImageUrl!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const  EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authorName == null
                                      ?
                                      ''
                                      :
                                      authorName!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  locationCompany!,
                                  style: const TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            applicants.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5,),
                           const Text(
                            'Applicants',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          const Icon(
                            Icons.how_to_reg_sharp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                      ?
                      Container()
                      :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dividerWidget(),
                          Text(
                            'Recruitment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: (){
                                    User? user = _auth.currentUser;
                                    final _uid = user!.uid;
                                    if(_uid == widget.uploadedBy)
                                      {
                                        try{
                                          FirebaseFirestore.instance
                                              .collection('jobs')
                                              .doc(widget.jobID)
                                              .update({'recruitment' : true} );
                                        }catch(error)
                                        {
                                          GlobalMethod.showErrorDialog(
                                              error: 'Action cannot be performed',
                                              ctx: context
                                          );
                                        }
                                      }
                                    else{
                                      GlobalMethod.showErrorDialog(
                                          error: 'Your can not perform this action',
                                          ctx: context,
                                      );
                                    }
                                    getJobData();
                                  },
                                  child:const  Text(
                                    'ON',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.normal,

                                    ),
                                  )
                              ),
                              Opacity(
                                opacity: recruitment == true ? 1 : 0 ,
                                child: const  Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 40,),
                              TextButton(
                                  onPressed: (){
                                    User? user = _auth.currentUser;
                                    final _uid = user!.uid;
                                    if(_uid == widget.uploadedBy)
                                    {
                                      try{
                                        FirebaseFirestore.instance
                                            .collection('jobs')
                                            .doc(widget.jobID)
                                            .update({'recruitment' : false} );
                                      }catch(error)
                                      {
                                        GlobalMethod.showErrorDialog(
                                            error: 'Action cannot be performed',
                                            ctx: context
                                        );
                                      }
                                    }
                                    else{
                                      GlobalMethod.showErrorDialog(
                                        error: 'Your can not perform this action',
                                        ctx: context,
                                      );
                                    }
                                    getJobData();
                                  },
                                  child:const  Text(
                                    'OFF',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                              ),
                              Opacity(
                                opacity: recruitment == false ? 1 : 0 ,
                                child: const  Icon(
                                  Icons.check_box,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      dividerWidget(),
                      Text(
                        'Job Desciption',
                        style: TextStyle(
                          fontSize: 20,color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        jobDescription == null
                            ?
                            ''
                            :
                            jobDescription!,

                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
              ),
              Padding(
                  padding: EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Center(
                          child: Text(
                            isDeadlineAvaliable
                            ?
                            'Actively Recruiting ,Send CV/Resume:'
                            :
                            'Deadline passed away:',
                            style: TextStyle(
                              color: isDeadlineAvaliable
                              ?
                              Colors.green
                              :
                              Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,

                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Center(
                          child: MaterialButton( 
                            onPressed: (){
                              applyForJob();
                            },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'Easy Apply Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Uploaded on:',
                               style: TextStyle(
                                  color: Colors.white,
                               ),
                            ),
                            Text(
                              postedDate == null
                                  ?
                                  ''
                                  :
                                  postedDate!,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Deadline date:',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              deadlineDate == null
                                  ?
                                  ''
                                  :
                              deadlineDate!,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        dividerWidget(),



                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(
                                milliseconds: 500
                            ),
                            child: _isCommenting
                              ?
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentControler,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLength: 200,
                                      keyboardType: TextInputType.text,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                                        enabledBorder:const UnderlineInputBorder(
                                          borderSide:  BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.pink),
                                        )
                                      ),
                                    ),
                                  ),
                                  Flexible(child: Column(
                                    children: [
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: MaterialButton(
                                        onPressed: () async{
                                          if(_commentControler.text.length < 7)
                                            {
                                              GlobalMethod.showErrorDialog(
                                                  error: 'Comment cannot be less than 7 characters',
                                                  ctx: context,
                                              );
                                            }
                                          else{
                                            final _generatedId = const Uuid().v4();
                                            await FirebaseFirestore.instance
                                            .collection('jobs')
                                            .doc(widget.jobID)
                                            .update({
                                              'jobComments':
                                                  FieldValue.arrayUnion([{
                                                    'userId' : FirebaseAuth.instance.currentUser!.uid,
                                                     'commentId' : _generatedId,
                                                     'name' : name,
                                                     'userImageUrl' : userImage,
                                                     'commentBody' : _commentControler.text,
                                                     'time' : Timestamp.now(),
                                                  }]),
                                            });
                                            await Fluttertoast.showToast(
                                                msg : ' Your comment has been added',
                                                toastLength:  Toast.LENGTH_LONG,
                                               backgroundColor: Colors.grey,
                                              fontSize: 20,

                                            );
                                            _commentControler.clear();
                                          }
                                          setState(() {
                                            showComment  = true;
                                          });

                                        },
                                        color: Colors.blueAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Post',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,

                                          ),

                                        ),
                                      ),
                                      ),
                                      TextButton(
                                          onPressed: (){
                                            setState(() {
                                              _isCommenting = !_isCommenting;
                                              showComment = false;
                                            });
                                          },
                                          child: const  Text(
                                            'Cancel',
                                            style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,

                                          ),
                                          )
                                      ),
                                    ],
                                  ),
                                  ),
                                ],
                              )
                                :
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        setState(() {
                                          _isCommenting = !_isCommenting;
                                          showComment = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add_comment,
                                        color: Colors.blueAccent,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    IconButton(
                                      onPressed: (){
                                        setState(() {
                                          showComment = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.blueAccent,

                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                          showComment == false
                              ?
                              Container()
                              :
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                  .collection('jobs')
                                  .doc(widget.jobID)
                                  .get(),
                                  builder: (context,snapshot){
                                    if(snapshot.connectionState == ConnectionState.waiting){
                                      return const Center(child: CircularProgressIndicator(),);
                                    }
                                    else
                                    {
                                      if(snapshot.data == null){
                                        const Center (child: Text('No Comment for this job'),);
                                      }
                                    }
                                    return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return CommentWidget(
                                              commentId: snapshot.data!['jobComments'][index]['commentId'],
                                              commenterId: snapshot.data!['jobComments'][index]['userId'],
                                              commenterName: snapshot.data!['jobComments'][index]['name'],
                                              commentBody: snapshot.data!['jobComments'][index]['commentBody'],
                                              commenterImageUrl: snapshot.data!['jobComments'][index]['userImageUrl'],
                                          );
                                        },
                                        separatorBuilder: (context,index){
                                          return const Divider(
                                            thickness: 1,
                                              color: Colors.grey,
                                          );
                                        },
                                        itemCount: snapshot.data!['jobComments'].length,
                                    );
                                  }
                                ),

                              )
                        ],
                      ),
                    ),
                  ),
              )

              
            ],
          ),
        ),
      ),

    );
  }
}
//in this page some error in operatot
