import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymoviedb/services/api_service.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import '../components/login_header.dart';
import '../helper.dart';

import '../contants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  Animation animation;

  GlobalKey loginButtonKey = GlobalKey();
  GlobalKey signInButtonKey = GlobalKey();

  double buttonWidth = double.infinity;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordConfirmation = FocusNode();

  bool _isLoading = false;
  int _currentPageIndex = 0;
  String _emailValue = '';
  String _passwordValue = '';
  String _nameValue = '';
  String _passwordConfimationValue = '';

  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LoginHeader(),
            Container(
              height: screenHeight * 0.5,
              child: ControlledAnimation(
                duration: Duration(seconds: 1),
                delay: Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, value) {
                  return Opacity(
                    opacity: value,
                    child: PageView(
                      physics: new NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: <Widget>[getLoginForm(), getSigninForm()],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: <Widget>[
          getEMailTextfield(),
          SizedBox(height: 16),
          getPasswordTextfield(),
          SizedBox(
            height: 32.0,
          ),
          getSubmitButton(loginButtonKey,kLoginButtonText, login),
          getGoToButton(kNotAnAccount, 1)
        ],
      ),
    );
  }

  Widget getSigninForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: <Widget>[
          getEMailTextfield(),
          SizedBox(height: 16),
          getNameTextfield(),
          SizedBox(
            height: 16,
          ),
          getPasswordTextfield(),
          SizedBox(
            height: 16,
          ),
          getPasswordConfirmationTextfield(),
          SizedBox(
            height: 32.0,
          ),
          getSubmitButton(signInButtonKey, kSignInButtonText, signin),
          getGoToButton(kAlreadyAnAccount, 0)
        ],
      ),
    );
  }

  Widget getEMailTextfield() {
    TextEditingController _controller = TextEditingController();
    _controller.value = TextEditingValue(text: _emailValue);

    return TextField(
      onChanged: (value) {
        _emailValue = value;
      },
      onSubmitted: (_) {
        FocusNode nextFocusNode =
            _currentPageIndex == 0 ? _passwordFocusNode : _nameFocusNode;
        fieldFocusChange(context, _emailFocusNode, nextFocusNode);
      },
      focusNode: _emailFocusNode,
      style: TextStyle(
          color: _isLoading ? kDisabledTextfieldColor : Colors.grey[600]),
      controller: _controller,
      textInputAction: TextInputAction.next,
      enabled: _isLoading ? false : true,
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: _isLoading ? kDisabledTextfieldColor : Colors.grey,
          ),
          labelText: 'E-Mail',
          labelStyle: TextStyle(
              color: _isLoading ? kDisabledTextfieldColor : Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kDisabledTextfieldColor))),
    );
  }

  Widget getPasswordTextfield() {
    TextEditingController _controller = TextEditingController();
    _controller.value = TextEditingValue(text: _passwordValue);
    return TextField(
      onChanged: (value) {
        _passwordValue = value;
      },
      onSubmitted: (_) {
        if (_currentPageIndex == 0) {
          login();
        } else {
          fieldFocusChange(context, _passwordFocusNode, _passwordConfirmation);
        }
      },
      focusNode: _passwordFocusNode,
      controller: _controller,
      enabled: _isLoading ? false : true,
      obscureText: true,
      cursorColor: Theme.of(context).primaryColor,
      textInputAction:
          _currentPageIndex == 0 ? TextInputAction.go : TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: _isLoading ? kDisabledTextfieldColor : Colors.grey,
          ),
          labelText: 'Password',
          labelStyle: TextStyle(
              color: _isLoading ? kDisabledTextfieldColor : Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kDisabledTextfieldColor))),
    );
  }

  Widget getPasswordConfirmationTextfield() {
    TextEditingController _controller = TextEditingController();
    _controller.value = TextEditingValue(text: _passwordConfimationValue);
    return TextField(
      onChanged: (value) {
        _passwordConfimationValue = value;
      },
      onSubmitted: (_) {
        signin();
      },
      focusNode: _passwordConfirmation,
      controller: _controller,
      enabled: _isLoading ? false : true,
      obscureText: true,
      cursorColor: Theme.of(context).primaryColor,
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: _isLoading ? kDisabledTextfieldColor : Colors.grey,
          ),
          labelText: 'Re-Type Password ',
          labelStyle: TextStyle(
              color: _isLoading ? kDisabledTextfieldColor : Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kDisabledTextfieldColor))),
    );
  }

  Widget getNameTextfield() {
    TextEditingController _controller = TextEditingController();
    _controller.value = TextEditingValue(text: _nameValue);

    return TextField(
      onChanged: (value) {
        _nameValue = value;
      },
      onSubmitted: (_) {
        fieldFocusChange(context, _nameFocusNode, _passwordFocusNode);
      },
      focusNode: _nameFocusNode,
      style: TextStyle(
          color: _isLoading ? kDisabledTextfieldColor : Colors.grey[600]),
      controller: _controller,
      textInputAction: TextInputAction.next,
      enabled: _isLoading ? false : true,
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: _isLoading ? kDisabledTextfieldColor : Colors.grey,
          ),
          labelText: 'Name',
          labelStyle: TextStyle(
              color: _isLoading ? kDisabledTextfieldColor : Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kDisabledTextfieldColor))),
    );
  }

  Widget getSubmitButton(GlobalKey key, String text, Function onSubmit) {
    return Container(
      key: key,
      width: buttonWidth,
      child: FlatButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          animateButton(key);
          onSubmit();
        },
        child: _isLoading
            ? SpinKitCircle(
                color: Colors.white,
                size: 40.0,
              )
            : Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5),
              ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: EdgeInsets.all(16.0),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget getGoToButton(String text, int targetPage) {
    return FlatButton(
        onPressed: () {
          if (_pageController.hasClients) {
            _pageController.animateToPage(targetPage,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        },
        child: _isLoading
            ? Text("")
            : Text(
                text,
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: Colors.transparent);
  }

  Widget animateButton(GlobalKey key) {
    double initialWidth = key.currentContext.size.width;
    var controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: initialWidth, end: 72.0).animate(controller);

    animation.addListener(() {
      setState(() {
        buttonWidth = animation.value;
        print(buttonWidth);
      });
    });

    controller.forward();
  }

  login() async{
    await APIService().login(_emailValue, _passwordValue);
  }

  signin() {
    print('Signin');
  }
}
