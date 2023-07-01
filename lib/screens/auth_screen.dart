import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

import '../global/app_text_style.dart';
import '../global/app_color.dart';

import '../screens/on_boarding_2.dart';
import '../provider/auth_provider.dart';
import '../widgets/action_button.dart';
import '../widgets/error_dialog.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = "/authScreen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthMode authMode = AuthMode.signIn;
  bool _passwordObscure = true;
  bool _passwordConfirm = true;
  bool _isLoading = false;
  final TextEditingController _passwordControl = TextEditingController();
  final Map<String, String> userAuth = {
    "userEmail": "",
    "userPassword": "",
    "userName": ""
  };
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordControl.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final authAction = Provider.of<Auth>(context, listen: false);

      _formKey.currentState!.save();
      if (authMode == AuthMode.signIn) {
        await authAction.signIn(
            userAuth["userEmail"]!, userAuth["userPassword"]!, context);
      } else {
        await authAction.signUp(userAuth["userEmail"]!,
            userAuth["userPassword"]!, userAuth["userName"]!, context);
      }
    } catch (e) {
      String errorMessage = e.toString();
      //print("${e.toString()} is the error message");
      showDialog(
          context: context,
          builder: (ctx) {
            return ErrorDialog(errorMessage: errorMessage);
          });

      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 42.h,
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/Pattern.png",
                      fit: BoxFit.cover,
                    ),
                    Container(
                      margin: EdgeInsets.all(10.h),
                      child: Image.asset(
                        "assets/images/food_illistration.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
                child: Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 7.5.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            authMode == AuthMode.signIn
                                ? "Connectez-vous à votre compte"
                                : "Inscription gratuite",
                            style: textStyle1,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              //   border: Border.all(color: greenColor1),
                            ),
                            child: TextFormField(
                              onSaved: (newValue) {
                                userAuth["userEmail"] = newValue!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer votre email";
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email!";
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              decoration: const InputDecoration(
                                  //      enabledBorder: OutlineInputBorder(),
                                  hintText: "Email",
                                  //     border: InputBorder.none,
                                  icon: Icon(
                                    Icons.mail,
                                    color: greenColor1,
                                  )),
                            ),
                          ),
                          if (authMode != AuthMode.signIn)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                //   border: Border.all(color: greenColor1),
                              ),
                              child: TextFormField(
                                onSaved: (newValue) {
                                  userAuth["userName"] = newValue!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veuillez entrer votre nom complet";
                                  }

                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                                decoration: const InputDecoration(
                                    //      enabledBorder: OutlineInputBorder(),
                                    hintText: "Name",
                                    //     border: InputBorder.none,
                                    icon: Icon(
                                      Icons.person,
                                      color: greenColor1,
                                    )),
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              onSaved: ((newValue) {
                                userAuth["userPassword"] = newValue!;
                              }),
                              controller: _passwordControl,
                              obscureText: _passwordObscure,
                              focusNode: _passwordFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer un mot de passe";
                                }
                                if (authMode !=
                                    AuthMode.signIn) if (value.length <= 5) {
                                  return "Veuillez entrer un mot de passe fort !";
                                }
                                return null;
                              },
                              textInputAction: authMode == AuthMode.signIn
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              onFieldSubmitted: authMode == AuthMode.signIn
                                  ? null
                                  : (_) {
                                      FocusScope.of(context).requestFocus(
                                          _passwordConfirmFocusNode);
                                    },
                              decoration: InputDecoration(
                                hintText: "Mot de passe",
                                //    border: InputBorder.none,
                                icon: const Icon(
                                  Icons.lock,
                                  color: greenColor1,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (_passwordObscure) {
                                      setState(() {
                                        _passwordObscure = false;
                                      });
                                    } else {
                                      setState(() {
                                        _passwordObscure = true;
                                      });
                                    }
                                  },
                                  icon: Icon(_passwordObscure
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                          ),
                          if (authMode != AuthMode.signIn)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                obscureText: _passwordConfirm,
                                validator: (value) {
                                  if (value == "" ||
                                      value != _passwordControl.text) {
                                    return "Veuillez vous assurer que le mot de passe est le même !";
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                focusNode: _passwordConfirmFocusNode,
                                decoration: InputDecoration(
                                  hintText: "Confirmez le mot de passe",
                                  //     border: InputBorder.none,
                                  icon: const Icon(Icons.lock,
                                      color: greenColor1),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      if (_passwordConfirm) {
                                        setState(() {
                                          _passwordConfirm = false;
                                        });
                                      } else {
                                        setState(() {
                                          _passwordConfirm = true;
                                        });
                                      }
                                    },
                                    icon: Icon(_passwordConfirm
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off),
                                  ),
                                ),
                              ),
                            ),
                          if (authMode == AuthMode.signIn)
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(OnBoarding2.routeName);
                                  },
                                  child: Text(
                                    "Mot de passe oublié?",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      color: greenColor1,
                                    ),
                                  ),
                                )
                              ],
                            )
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 12.h,
                child: Column(
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator(
                            color: greenColor1,
                            strokeWidth: 2.0,
                          )
                        : ActionButton(
                            height: 4.5.h,
                            width: authMode == AuthMode.signIn ? 30.w : 40.w,
                            onTap: _submit,
                            text: (authMode == AuthMode.signIn
                                ? "Connexion"
                                : "Créer un compte")),
                    TextButton(
                      onPressed: () {
                        if (authMode == AuthMode.signIn) {
                          setState(() {
                            authMode = AuthMode.signUp;
                          });
                        } else {
                          setState(() {
                            authMode = AuthMode.signIn;
                          });
                        }
                      },
                      child: Text(
                        authMode == AuthMode.signIn
                            ? "Vous n'avez pas encore de compte ?, Inscrivez-vous"
                            : "Vous avez déjà un compte? se connecter",
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: greenColor1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum AuthMode {
  signUp,
  signIn,
}
