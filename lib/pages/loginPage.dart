import 'package:app5dm/apis/userApi.dart';
import 'package:app5dm/constants/images.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/providers/userProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "/loginPage",
  routeName: "loginPage",
  showStatusBar: false,
)
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
                                    TextFormField(
                                      controller: userNameController,
                                      decoration: InputDecoration(
                                        hintText: '用户名',
                                        prefixIcon: Icon(Icons.perm_identity),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty &&
                                            value.trim().isEmpty) {
                                          return '请输入用户名';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: pwdController,
                                      decoration: InputDecoration(
                                        hintText: '密码',
                                        prefixIcon: Icon(Icons.lock_outline),
                                      ),
                                       validator: (value) {
                                        if (value.isEmpty &&
                                            value.trim().isEmpty) {
                                          return '请输入密码';
                                        }
                                        return null;
                                      },
                                      obscureText: true,
                                    ),
                                    SizedBox(
                                      height: Screen.setHeight(50),
                                    ),
                                    SizedBox(
                                        width: double.infinity,
                                        child: Selector<UserModel, UserModel>(
                                          selector: (_, userModel) => userModel,
                                          shouldRebuild: (newModel, oldModel) =>
                                              newModel.viewState !=
                                              oldModel.viewState,
                                          builder: (_, userModel, child) {
                                            return RaisedButton(
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                        .validate() &&
                                                    userModel.viewState !=
                                                        ViewState.pending) {
                                                  var res =
                                                      await userModel.login(
                                                          pwd: pwdController
                                                              .value.text,
                                                          userName:
                                                              userNameController
                                                                  .value.text);
                                                  if (res == true) {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  }
                                                }
                                              },
                                              child: userModel.viewState ==
                                                      ViewState.pending
                                                  ? Text('登录中')
                                                  : Text('登录'),
                                            );
                                          },
                                        )),
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
