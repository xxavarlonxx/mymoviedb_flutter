import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../contants.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isLoading = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String emailValue = '';
  String passwordValue = '';

  Widget _buildLoginHeader(double screenHeight){
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
          height: screenHeight * 0.5,
          color: Colors.orange,
          child: Center(
            child: Container(
              height: 120.0,
              width: 120.0,
              child: Center(
                child: Text('M', style: TextStyle(fontSize: 90, color: Colors.orange, fontWeight: FontWeight.w900),),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildLoginForm (){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildEMailTextfield(),
          SizedBox(height: 16),
          _buildPasswordTextfield(),
          SizedBox(height: 24.0,),
          _buildLoginButton(),
          _buildSigninButton(),
        ],
      ),
    );
  }

  Widget _buildEMailTextfield(){
    TextEditingController _controller = TextEditingController();
    _controller.value = TextEditingValue(text: emailValue);

    return TextField(
      onChanged: (value){
          emailValue = value;
      },
      onSubmitted: (_){
        _fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
      },
      focusNode: _emailFocusNode,
      style: TextStyle(color: isLoading ? kDisabledTextfieldColor : Colors.grey[600]),
      controller: _controller,
      textInputAction: TextInputAction.next,
      enabled: isLoading ? false : true,
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail, color: isLoading ? kDisabledTextfieldColor : Colors.grey,),
        labelText: 'E-Mail',
          labelStyle: TextStyle(
                          color: isLoading ? kDisabledTextfieldColor: Colors.grey
          ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey
            )
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: kDisabledTextfieldColor
          )
        )
      ),
    );
  }

  Widget _buildPasswordTextfield(){
    TextEditingController _controller = TextEditingController();
    _controller.value = TextEditingValue(text: passwordValue);
    return TextField(
      onChanged: (value){
        passwordValue = value;
      },
      onSubmitted: (_){
        login();
      },
      focusNode: _passwordFocusNode,
      controller: _controller,
      enabled: isLoading ? false : true,
      obscureText: true,
      cursorColor: Theme.of(context).primaryColor,
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: isLoading? kDisabledTextfieldColor: Colors.grey,),
        labelText: 'Password',
        labelStyle: TextStyle(
          color: isLoading ? kDisabledTextfieldColor: Colors.grey
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey
            )
        ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: kDisabledTextfieldColor
              )
          )
      ),
    );
  }

  Widget _buildLoginButton(){
    return FlatButton(onPressed: (){
      login();
    },
      child: isLoading ? _buildLoadingCircle() : Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5),),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40)
      ),
      padding: EdgeInsets.symmetric(vertical: 16),
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _buildLoadingCircle(){
    return SpinKitDualRing(
      color: Colors.white,
      size: 20.0,
    );
  }

  Widget _buildSigninButton(){
    return FlatButton(onPressed: (){},
        child: Text('Not an Account yet? Sign in!', style: TextStyle(color: Colors.black26, fontSize: 16, fontWeight: FontWeight.w900),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
        ),
        color: Colors.transparent
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  login(){
    print("Login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildLoginHeader(MediaQuery.of(context).size.height),
              _buildLoginForm(),
             ],
          ),
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset startPoint = Offset(0, size.height* 0.85);
    Offset endPoint = Offset(size.width, size.height * 0.85);

    path.lineTo(startPoint.dx, startPoint.dy);
    path.quadraticBezierTo(size.width * 0.5, size.height, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}