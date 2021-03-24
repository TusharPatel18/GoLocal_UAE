import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showSuccessMessage(BuildContext context,
    {message: 'success', title: "Success",VoidCallback callback}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Colors.green),
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text("OK",style: TextStyle(color: Colors.green),),
          onPressed: () {
            Navigator.pop(context);
            if(callback!=null){
              callback();
            }
          },
        )
      ],
    ),
  );
}
showLoaderDialog(BuildContext context,) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator(),),
  );
}
showLoaderDialogWithMessage(BuildContext context,String title,String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      insetPadding: EdgeInsets.all(24.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 15,),
          Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator()),
          SizedBox(height: 15,),
          Text(message??"Loading")
        ],
    ),
      ),),
  );
}
showErrorMessage(BuildContext context, {message: "Error", title: "Oops!",VoidCallback callback}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Colors.red),
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text("OK",style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.pop(context);
            if(callback!=null){
              callback();
            }
          },
        )
      ],
    ),
  );
}

showWarningMessage(BuildContext context,
    {message: "Warning", title: "Warning!"}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Colors.orange),
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text("OK",style: TextStyle(color: Colors.orange),),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}
