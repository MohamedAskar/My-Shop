import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color.fromRGBO(247, 175, 157, 1),
                //     Color.fromRGBO(51, 24, 50, 1),
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   stops: [0, 1],
                // ),
                color: Theme.of(context).primaryColor),
          ),
          Center(
            child: AuthCard(),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _key = GlobalKey();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordfocusNode = FocusNode();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final emailController = TextEditingController();
  var _showPassword = true;

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Okay',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(ctx).accentColor,
                      fontFamily: 'Lexend',
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ));
  }

  void _submit() async {
    if (!_key.currentState.validate()) {
      return;
    }
    _key.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Signup) {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Login
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
        print('submit');
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already connected to an account.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid E-mail address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This E-mail doesn\'t exist, Signup instead.';
      } else if (error.toString().contains('INVAILD_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Couldn\'t reach you, Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
        _showPassword = false;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _showPassword = false;
      });
      _controller.reverse();
    }
  }

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    //_heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        elevation: 16,
        child: AnimatedContainer(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 420 : 380,
          //height: _heightAnimation.value.height,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 420 : 380),
          width: deviceSize.width * 0.75,
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Text(
                  '${_authMode == AuthMode.Signup ? 'Create a new account.' : 'Welcome Back!'}',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                      color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'E-Mail', icon: Icon(Icons.alternate_email)),
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          icon: Icon(Icons.lock_outline),
                        ),
                        focusNode: _passwordFocusNode,
                        obscureText: _showPassword,
                        
                        onFieldSubmitted: (_) {
                          if (_authMode == AuthMode.Signup) {
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordfocusNode);
                          } else
                            _submit();
                        },
                        controller: _passwordController,
                        textInputAction: _authMode == AuthMode.Login
                            ? TextInputAction.done
                            : TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    )
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      maxWidth: _authMode == AuthMode.Signup
                          ? deviceSize.width * 0.75
                          : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              icon: Icon(Icons.lock_outline)),
                          textInputAction: TextInputAction.done,
                          focusNode: _confirmPasswordfocusNode,
                          obscureText: _showPassword,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(
                      '${_authMode == AuthMode.Signup ? 'SIGNUP' : 'LOGIN'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend',
                      ),
                    ),
                    onPressed:() => _submit(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                SizedBox(
                  height: 6,
                ),
                FlatButton(
                  child: Text(
                    '${_authMode == AuthMode.Signup ? 'Already Have account? Login instead.' : 'Not a member? Create a new account.'}',
                    style: TextStyle(fontFamily: 'Lexend'),
                  ),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).accentColor,
                ),
              ]),
            ),
          ),
        ));
  }
}
