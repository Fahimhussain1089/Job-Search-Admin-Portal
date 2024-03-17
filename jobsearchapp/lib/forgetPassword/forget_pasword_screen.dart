import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobsearchapp/LogingPage/login_screen.dart';
import 'package:jobsearchapp/Services/global_variable.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _forgetPassTextController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this,
        duration: Duration(seconds: 20));
    _animation = CurvedAnimation(parent: _animationController,
        curve: Curves.linear)
      ..addListener((){
        setState(() {

        });
      })
      ..addStatusListener((animationStatus){
        if(animationStatus == AnimationStatus.completed){
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  void _forgetPassSbmitForm() async{
    try{
      await _auth.sendPasswordResetEmail(
        email: _forgetPassTextController.text,

      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()),);
    }catch(error){
      Fluttertoast.showToast(msg: error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: forgetUrlimage,
            placeholder: (context,url)=> Image.asset(
              'assets/images/wallpaper2.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context,url,error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value,1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,

                ),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Signatra',
                    fontSize: 55,
                    fontWeight: FontWeight.bold,

                  ),

                ),
                const SizedBox(height: 10,),
                const Text(
                  'Email address',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,

                  ),

                ),
                const SizedBox(height: 20,),
                TextField(
                  controller: _forgetPassTextController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white54,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )
                  ),


                ),
                const SizedBox(height: 60,),
                //create forgetpresssumitfrom
                MaterialButton(
                    onPressed: (){
                      _forgetPassSbmitForm();
                    },
                  color: Colors.cyan,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:const  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Reset now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                  ),

                ),
              ],
            ),

          )


        ],
      ),
    );
  }
}
