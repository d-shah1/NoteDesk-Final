import 'package:flutter/material.dart';
import 'DialogBox.dart';
import 'Authentication.dart';


class LoginRegisterPage extends StatefulWidget {

  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
});
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
    return _LoginRegisterPageState();
  }
}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {

  DialogBox dialogBox = new DialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = '';
  String _password = '';

   bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    else
      {
      return false;
    }
  }

  void validateAndSubmit() async {
    if(validateAndSave())
      {
        try{
          if(_formType == FormType.login) {
            String userid = await widget.auth.signIn(_email,_password);
            dialogBox.information(context, 'Congratulations ', 'You are logged in successfully' );
            print('Login userId =' + userid);
          }
          else {
            String userid = await widget.auth.signUp(_email,_password);
             dialogBox.information(context, 'Congratulations ', 'Your Account has been created successfully' );
            print('Register userId =' + userid);
          }
          widget.onSignedIn();
        }
        catch(e)
    {
      dialogBox.information(context, 'Error = ', e.toString());
      print('Error = ' + e.toString());
    }
      }

  }

  void moveToRegister() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }


  List<Widget> createInputs() {
    return [
     backgrnd(),
     Padding(
       padding: EdgeInsets.all(30),
       child: Column(
         children: <Widget>[
           Container(
             padding: EdgeInsets.all(5),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(10),
               boxShadow: [
                 BoxShadow(
                   color: Color.fromRGBO(143, 148, 251, 1),
                   blurRadius: 20.0,
                   offset: Offset(0, 10)
                 )
               ]
             ),
             child: Column(
               children: <Widget>[
                 Container(
                   padding: EdgeInsets.all(8),
                   decoration: BoxDecoration(
                     border: Border(bottom: BorderSide(color: Colors.grey[100]))
                   ),
                   child: TextFormField(
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       hintText: 'Email or Phone number',
                       prefixIcon: Icon(Icons.email),
                       hintStyle: TextStyle(color: Colors.grey[400])
                     ),
                     keyboardType: TextInputType.emailAddress,
                     onSaved: (value) {
                      return  _email = value;
                     },
                   ),
                 ),
                  Container(
                   padding: EdgeInsets.all(8),
                   decoration: BoxDecoration(
                     border: Border(bottom: BorderSide(color: Colors.grey[100]))
                   ),
                   child: TextFormField(
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       hintText: 'Password',
                       prefixIcon: Icon(Icons.vpn_key),
                       hintStyle: TextStyle(color: Colors.grey[400])
                     ),
                     obscureText: true,
                     onSaved: (value) {
                      return  _password = value;
                     },
                   ),
                 )
               ],
             ),
           )
         ],
       ),
     )
    ];
  }

  Widget backgrnd() {
    return Container(
       height: 400,
             decoration: BoxDecoration(
               image: DecorationImage(
                 image: AssetImage('assets/images/background.png'),
                 fit: BoxFit.fill
               )
             ),
             child: Stack(
               children: <Widget>[
                 Positioned(
                   left: 30,
                   width: 80,
                   height: 200,
                   child: Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(
                         image: AssetImage('assets/images/light-1.png')
                       )
                     ),
                   ),
                 ),
                 Positioned(
                   left: 140,
                   width: 80,
                   height: 150,
                   child: Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(
                         image: AssetImage('assets/images/light-2.png')
                       )
                     ),
                   ),
                 ),
                  Positioned(
                   right: 40,
                   top: 40,
                   width: 80,
                   height: 150,
                   child: Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(
                         image: AssetImage('assets/images/clock.png')
                       )
                     ),
                   ),
                 ),
                 Positioned(
                   child: Container(
                     margin: EdgeInsets.only(top: 80),
                     child: Center(
                       child: Text('NoteDesk', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold))
                     ),
                   )
                 )
               ],
             ),
    );
  }

  List<Widget> createButtons() {

    SizedBox(
      height: 20.0,
    );
    
    if (_formType == FormType.login)
    {
      return [
        Padding(
          padding: EdgeInsets.only(left: 100, right: 100),
        child: SizedBox(
          height: 50,
          width: 60,
        child: RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(18.0),
            ),
          color: Color.fromRGBO(143, 148, 251, 1),
          onPressed: validateAndSubmit,
        ),
        ),
        ),
        FlatButton(
          child: new Text("New User? Click Here",
              style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.black54,
          onPressed: moveToRegister,
        )
      ];
    }
    else
      {
      return
        [
        Padding(
          padding: EdgeInsets.only(left: 100, right: 100),
          child: SizedBox(
            height: 50,
            width: 60,
          child:RaisedButton(
          child: new Text("Register", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(18.0),
            ),
          color: Color.fromRGBO(143, 148, 251, 1),
          onPressed: validateAndSubmit,
        ),
        )
        ),
        new FlatButton(
          child: Text('Already Have an Account ? Click Here',
              style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.black54,
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}

