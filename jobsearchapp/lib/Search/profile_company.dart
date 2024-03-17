import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:jobsearchapp/user_state.dart';
import 'package:jobsearchapp/widgets/bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
 // const ProfileScreen({super.key});
  final String userID;
  const ProfileScreen({required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async{
    try{
      _isLoading  = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore
          .instance.collection('users')
          .doc(widget.userID)
          .get();
      if(userDoc == null){
        return;
      }else{
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedTimeStamp.toDate();
          joinedAt  = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';

        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid ==widget.userID;
        });
      }
    }catch(error) {}finally
    {
      _isLoading = false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }
//here is the methode of ronly icons colors and email
  Widget userInfo({ required IconData icon, required String content}){
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
           child: Text(
             content,
             style: TextStyle(color: Colors.white54),
           ),
        )
      ],
    );
  }
  // here is the methode for the  watsapp and constact , redirection
  Widget _contactBy({
    required Color color, required Function fct, required IconData icon
})
  {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,color: color,
          ),
          onPressed: (){
            fct();
          },
        ),
      ),
    );
  }

  void _openWhatsAppChat()async{
    var url  = 'https://wa.me/$phoneNumber?text=HelloWorld';
    launchUrlString(url);
  }
  void _mailTo() async{
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Write subject here, Please&body=Hello, please write details here',
    );
    final url = params.toString();
    launchUrlString(url);
  }


  void _callPhoneNumber()async{
    var url  = 'tel://$phoneNumber';
    launchUrlString(url);
  }




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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3,),
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isLoading
              ?
              const Center(child: CircularProgressIndicator(),)
              :
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Stack(
                    children: [
                      Card(
                        color: Colors.white10,
                        margin: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 100,),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name == null
                                      ?
                                      'Name here'
                                      :
                                      name!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Divider(thickness: 1,color: Colors.white,),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Account Information:',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: userInfo(
                                    icon: Icons.email,content: email),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: userInfo(
                                    icon: Icons.phone,content: phoneNumber),
                              ),
                              const SizedBox(height: 5,),
                              const Divider(thickness: 1,color: Colors.white,),
                              const SizedBox(height: 35,),
                              _isSameUser
                              ?
                              Container()
                              :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _contactBy(
                                      color: Colors.green,
                                      fct: (){
                                        _openWhatsAppChat();
                                      },
                                      icon: FontAwesome.whatsapp,
                                  ),
                                  _contactBy(
                                    color: Colors.red,
                                    fct: (){
                                      _mailTo();
                                    },
                                    icon: Icons.mail_outline,
                                  ),
                                  _contactBy(
                                    color: Colors.blue,
                                    fct: (){
                                      _callPhoneNumber();
                                    },
                                    icon: Icons.call,
                                  ),
                                ],
                              ),


                              // const SizedBox(height: 25,),
                              // const Divider(thickness: 1,color: Colors.white,),
                              // const SizedBox(height: 15,),
                              !_isSameUser
                              ?
                              Container()
                              :
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: MaterialButton(
                                    onPressed: (){
                                      _auth.signOut();
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserState()));
                                    },
                                    color: Colors.black,
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const  Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Logout',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Signatra',
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Icon(
                                            Icons.logout_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.26,
                            height: size.width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 10,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  imageUrl == null
                                      ?
                                      'https://png.pngtree.com/png-vector/20230903/ourmid/pngtree-man-avatar-isolated-png-image_9935818.png'
                                      :
                                      imageUrl,//lecture 82 follow if any errro show
                                ),
                                fit: BoxFit.fill,
                              )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )

        ),

      ),
    );
  }
}
