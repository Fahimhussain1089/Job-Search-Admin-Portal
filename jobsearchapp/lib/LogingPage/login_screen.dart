import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jobsearchapp/Services/global_methode.dart';
import 'package:jobsearchapp/Services/global_variable.dart';
import 'package:jobsearchapp/SignupPage/signup_screen.dart';
import 'package:jobsearchapp/forgetPassword/forget_pasword_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin{
  late Animation<double> _animation;
  late AnimationController _animationController;

  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();
  bool _obscureText  = false; //true
  bool  _isLoading = false;
  final  FirebaseAuth _auth = FirebaseAuth.instance;

  final  TextEditingController _emailTextController = TextEditingController(text: "");
  final  TextEditingController _passTextController = TextEditingController(text: "");

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
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

  void _submitFormOnLogin() async{
    final isvalid = _loginFormKey.currentState!.validate();
    if(isvalid){
      setState(() {
        _isLoading = true;

      });
      try{
        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.trim(),
            password: _passTextController.text.trim(),
        );
        Navigator.canPop(context) ? Navigator.pop(context)  : null ;
      }catch(error){
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context); //ye global methode class se ayega jiseme methode declase hai 
        print("error aa gyi $error");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
          placeholder: (context,url) => Image.asset(
            "assets/images/wallpaper2.jpg",
            fit: BoxFit.fill,
          ),
            errorWidget: (context,url,error) =>const  Icon(Icons.error) ,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value,0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:16 ,vertical: 18),
              child: ListView(
                children: [
                  Padding(
                    padding: const  EdgeInsets.only(left:80 ,right: 80),
                  child: Image.asset("assets/images/login.png"),
                  ),
                  //her written
                  const SizedBox(height: 15,),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                          controller: _emailTextController,
                          validator: (value){
                            if(value!.isEmpty || !value.contains("@")){
                              return "Please enter a valid Email Address ";
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            )
                          ),
                        ),
                        //pasword
                        const  SizedBox(height: 5,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          obscureText: !_obscureText,//change it dynamically
                          validator: (value){
                            if(value!.isEmpty || value.length < 7 )
                              {
                                return"please enter a valid password";
                              }else{
                              return null ;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration:  InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            ),
                              hintText: "Password",
                              hintStyle:const  TextStyle(
                                  color: Colors.white
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder:const  UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)
                              )
                          ),

                        ),
                        const SizedBox(height: 15,),
                        //forgetten screen
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) => ForgetPassword()
                              ),
                              );

                            },
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        //button
                        const SizedBox(height: 10,),
                        MaterialButton(
                          onPressed: _submitFormOnLogin,
                        color: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child:Padding(
                            padding: const EdgeInsets.symmetric(vertical:15.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Login',
                                  style:TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        //Sign up page
                        const SizedBox(height: 40,),
                        Center(child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "account nai hai apke pass??",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(text: " "),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(context,MaterialPageRoute(builder: (context) => SignUp()),),
                                text: "Signup",
                                style: const TextStyle(
                                  color: Colors.cyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )

                              )
                            ],
                          ),
                        ),)



                      ],
                    ),
                    
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//9lecture completed