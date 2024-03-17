import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobsearchapp/Persistent/persistent.dart';
import 'package:jobsearchapp/Services/global_methode.dart';
import 'package:jobsearchapp/Services/global_variable.dart';
import 'package:jobsearchapp/widgets/bottom_nav_bar.dart';
import 'package:uuid/uuid.dart';

class UploadJoabNow extends StatefulWidget {
 // const UploadJoabNow({super.key});

  @override
  State<UploadJoabNow> createState() => _UploadJoabNowState();
}

class _UploadJoabNowState extends State<UploadJoabNow> {

  TextEditingController _jobCategoryController = TextEditingController(
      text: "Select Job Category");
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _jobDescriptionController = TextEditingController();
  TextEditingController _deadlineDateController = TextEditingController(
      text: "Job Deadline Date");


  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _deadlineDateController.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(padding: EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'JobDescription' ? 3 : 1,
          //two line me code worite kr sakte ho font chota rhega
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black54,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
          ),

        ),
      ),
    );
  }

  //here is methore for fct button

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color(0xFFd5cfac),
            title: Text(
              'Job Categorys',
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
                          _jobCategoryController.text = Persistent
                              .jobCategoryList[index];
                        });
                        Navigator.pop(context);
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
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),))
            ],

          );
        }
    );
  }

  //job deadline date ki dead line ke methode
  void _pickedDatedDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0),
        ),
        lastDate: DateTime(2100)
    );
    if (picked != null) {
      setState(() {
        _deadlineDateController.text =
        '${picked!.year} - ${picked!.month} - ${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  //here is methode for, upload tak button(future ye task run ho)
  void _uploadTak() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_deadlineDateController.text == 'Choose job Deadline date' ||
          _jobCategoryController.text == "Chosse job Category") {
        GlobalMethod.showErrorDialog(
            error: "Please pick everything",
            ctx: context
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
          'jobId': jobId,
          'uploadedBy': _uid,
          'email': user.email,
          'jobTitle': _jobTitleController.text,
          'jobDescription': _jobDescriptionController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'jobCategory': _jobCategoryController.text,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,


        });
        await Fluttertoast.showToast(
          msg: 'The task  has been uploaded ',
          backgroundColor: Colors.grey,
          fontSize: 20.0,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = 'Choose job category';
          _deadlineDateController.text = 'Choose job Deadline date';
        });
      }
      catch (error) {
        {
          setState(() {
            _isLoading = false;
          });
          GlobalMethod.showErrorDialog(error: error.toString(), ctx: context,);
        }
      }
      finally
          {
            setState(() {
              _isLoading = false;
            });
          }
    }
    else
      {
        print('Its not Valid');
      }

}

//screen pe job post show krene ke liye methode hai.

  // void getMyData() async{
  //   final DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //
  //   setState(() {
  //     name = userDoc.get('name');
  //     userImage = userDoc.get('userImage');
  //     location = userDoc.get('location');
  //   });
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   getMyData();
  // }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFFbeb15b),
                Color(0xFFd5cfac)
              ],
              begin: Alignment.topCenter,
              end: Alignment.centerRight,
              stops: const[0.2,0.9]

          )
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2,),
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title:  const Text('Upload Joab Now '),
        //   centerTitle: true,
        //   flexibleSpace: Container(
        //     decoration:const  BoxDecoration(
        //         gradient: LinearGradient(
        //             colors: [
        //               Color(0xFFbeb15b),
        //               Color(0xFFd5cfac)],
        //             begin: Alignment.topCenter,
        //             end: Alignment.centerRight,
        //             stops: const[0.2,0.9]
        //
        //         )
        //     ),
        //
        //   ),
        // ),
        //
        body:  Center(
          child:   Padding(
            padding:  EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Please fill all Fields',
                            style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold,fontFamily: 'Signatra'),

                          ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: 'Job Category : '),

                            _textFormField(
                              valueKey: 'JobCategory',
                              controller: _jobCategoryController,
                              enabled: false,
                              fct: (){
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: 'JobTitle :'),
                            _textFormField(
                              valueKey: 'JobTitle',
                              controller: _jobTitleController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Job Description :'),
                            _textFormField(
                              valueKey: 'JobDescription',
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Job Deadline Date :'),
                            _textFormField(
                              valueKey: 'Deadline ',
                              controller: _deadlineDateController,
                              enabled: false,
                              fct: (){
                                _pickedDatedDialog();
                              },
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),

                    ),
                    Center(
                      child: _isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                          onPressed: (){
                            //here is methode for, upload tak button(future ye task run ho)
                            _uploadTak();
                          },
                          color: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child:const  Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Post Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Signatra',
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.white,
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
          ),
        ),
      ),
    );
  }
}

