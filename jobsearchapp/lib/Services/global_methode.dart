

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalMethod{
  static void showErrorDialog({
    required String error,
    required BuildContext ctx,})
  {
    showDialog(context: ctx, builder: (context){
      return AlertDialog(
        title: Row(
          children:  [
            Padding(padding:EdgeInsets.all(8.0),
            child: Icon(
              Icons.logout,color: Colors.grey,
              size: 35,
            ),
            ),
            Padding(padding: EdgeInsets.all(8.0),
            child: Text("Error aa gyi",),
            )
          ],
        ),
        content: Text(
          // "$error",
          error,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context)  : null ;

              },
              child: const Text(
                "Hmm good!",
                style: TextStyle(
                    color: Colors.red
                ),
              ),
          ),
        ],

      );
    });
  }
}