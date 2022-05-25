import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/cubit/cubit.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:flutter_application_1/module/register/register.dart';
import 'package:flutter_application_1/network/local/cash_helper.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_application_1/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../admin/admin_dash.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class SocialLoginScreen extends StatefulWidget {
  @override
  _SocialLoginScreenState createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool isPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLogInState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "سجل الدخول",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          "سجل الدخول الآن وشارك حياتك اليومية",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          type: TextInputType.emailAddress,
                          prefix: Icons.email,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "ادخل الإيميل";
                            }
                            return null;
                          },
                          label: 'الإيميل',
                          textEditingController: emailController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          textEditingController: passwordController,
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "ادخل كلمة السر";
                            }
                            return null;
                          },
                          onSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              SocialLoginCubit.get(context).userSignIn(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          suffix: isPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          isPassword: isPassword,
                          fSuffix: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                          label: "كلمة السر",
                          prefix: Icons.lock,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        (state is! SocialLogInLoadState)
                            ? defaultButton(
                                text: "سجل الدخول",
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    SocialLoginCubit.get(context).userSignIn(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('أنت لا تمتلك حساب ؟'),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SocialRegisterScreen()));
                                },
                                child: Text("انشئ حساب الآن"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is SocialLogInAdminSuccessState) {
            navigateTo(context, DashScreen());
          }

          if (state is SocialLogInLoadState) {
            showToast(
                message: 'جاري تسجيل الدخول', states: ToastStates.WARNING);
          }

          if (state is SocialLogInAdminSuccessState) {
            showToast(message: 'Success', states: ToastStates.SUCCESS);
            CashHelper.saveData(key: 'uId', value: 'Admin').then((value) {
              uId = 'Admin';
              SocialCubit.get(context).getPosts();
              navigateAndFinsh(context, DashScreen());
            });
          }
          if (state is SocialLogInSuccessState) {
            showToast(message: 'Success', states: ToastStates.SUCCESS);
            CashHelper.saveData(key: 'uId', value: '${state.uId}')
                .then((value) {
              uId = state.uId;
              SocialCubit.get(context).getPosts();
              SocialCubit.get(context).getUserData();
              navigateAndFinsh(context, SocialLayout());
            });
          } else if (state is SocialLogInErrorState) {
            showToast(message: '${state.error}', states: ToastStates.ERROR);
          }
        },
      ),
    );
  }
}
