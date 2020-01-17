import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_animations/simple_animations.dart';

import '../contants.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{



  //AnimationController controller;
  Animation animation;
  //AnimationController _fadeOutController;
  //AnimationController _fadeInController;
  //Animation<double> _widthAnimation;
  //Animation<double> _fadeOutAnimation;
  //Animation<double> _fadeInAnimation;

  GlobalKey globalKey = GlobalKey();
  double buttonWidth = double.infinity;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool isLoading = false;
  String emailValue = '';
  String passwordValue = '';

  /*@override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener((){
      print(animation.value);
      setState(() {

      });
    });
    
    animation = Tween<double>(begin: double.infinity, end: 50).animate(controller);
    
    //controller.forward();
    //_widthAnimation = Tween<double>(begin: 200, end: 50).animate(_widthController);

    //_fadeOutController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //_fadeOutAnimation = Tween<double>(begin: 100, end: 0).animate(_fadeOutController);

  }*/


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
              _buildLoginButton(),
              _buildSigninButton()
            ],
          ),
        ),
      ),
    );
  }


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
                child: Text('M', style: TextStyle(fontSize: 90.0, color: Colors.orange, fontWeight: FontWeight.w900),),
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
          //_buildLoginButton(),
          //_buildSigninButton(),
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
    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Container(
          key: globalKey,
          width: buttonWidth,
          child: FlatButton(onPressed: (){
                //login();
                setState(() {
                  isLoading = true;
                });
                animateButton();
              },
                child: isLoading ? _buildLoadingCircle() : Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                ),
                padding: EdgeInsets.all(16.0),
                color: Theme.of(context).primaryColor,
          ),
        ),
    );
  }

  animateButton(){
    double initialWidth = globalKey.currentContext.size.width;
    var controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: initialWidth, end: 72.0).animate(controller);

    animation.addListener((){
      setState(() {
        buttonWidth = animation.value;
        print(buttonWidth);
      });
    });

    controller.forward();
  }

  Widget _buildLoadingCircle(){
    return SpinKitCircle(
      color: Colors.white,
      size: 40.0,
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