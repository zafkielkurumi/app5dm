import 'package:app5dm/constants/images.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/providers/userProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart';
// import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// @FFRoute(
//   name: "/loginPage",
//   routeName: "loginPage",
// )
class LoginPage extends StatelessWidget {
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
          elevation: 0,
        ),
        body: ChangeNotifierProvider<UserModel>(
          create: (_) => UserModel(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Theme(
              data:
                  Theme.of(context).copyWith(splashFactory: NoSplashFactory()),
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipPath(
                        clipper: HeaderClipper(),
                        child: Container(
                          height: 300,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Hero(tag: 'logo', child: Image.asset(Images.logo)),
                            Container(
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withAlpha(10),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        offset: Offset(1, 1))
                                  ]),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    NameFormField(
                                        userNameController: userNameController),
                                    PwdFormField(pwdController: pwdController),
                                    SizedBox(
                                      height: Screen.setHeight(50),
                                    ),
                                    LoginButton(
                                        formKey: _formKey,
                                        pwdController: pwdController,
                                        userNameController: userNameController),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[Text('注册')],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.pwdController,
    @required this.userNameController,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController pwdController;
  final TextEditingController userNameController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Selector<UserModel, UserModel>(
          selector: (_, userModel) => userModel,
          shouldRebuild: (newModel, oldModel) => false,
          builder: (_, userModel, child) {
            return RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate() &&
                    userModel.viewState != ViewState.pending) {
                  var res = await userModel.login(
                      pwd: pwdController.value.text,
                      userName: userNameController.value.text);
                  if (res == true) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
              child: Selector<UserModel, ViewState>(
                  builder: (_, viewState, child) {
                    return viewState == ViewState.pending
                        ? Text(
                            '登录中...',
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            '登录',
                            style: TextStyle(color: Colors.white),
                          );
                  },
                  selector: (_, userModel) => userModel.viewState),
            );
          },
        ));
  }
}

class PwdFormField extends StatelessWidget {
  const PwdFormField({
    Key key,
    @required this.pwdController,
  }) : super(key: key);

  final TextEditingController pwdController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: pwdController,
      decoration: InputDecoration(
        hintText: '密码',
        prefixIcon: Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value.isEmpty && value.trim().isEmpty) {
          return '请输入密码';
        }
        return null;
      },
      obscureText: true,
    );
  }
}

class NameFormField extends StatelessWidget {
  const NameFormField({
    Key key,
    @required this.userNameController,
  }) : super(key: key);

  final TextEditingController userNameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: userNameController,
      decoration: InputDecoration(
        hintText: '用户名',
        prefixIcon: Icon(Icons.perm_identity),
      ),
      validator: (value) {
        if (value.isEmpty && value.trim().isEmpty) {
          return '请输入用户名';
        }
        return null;
      },
    );
  }
}
