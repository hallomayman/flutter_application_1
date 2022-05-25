import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:flutter_application_1/module/login/log_in.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../network/local/cash_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class SocialRegisterScreen extends StatefulWidget {
  @override
  _SocialRegisterScreenState createState() => _SocialRegisterScreenState();
}

class _SocialRegisterScreenState extends State<SocialRegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var passwordController = TextEditingController();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
        listener: (context, state) {
          if (state is SocialRegisterSuccessState) {
            showToast(message: 'Success', states: ToastStates.SUCCESS);
          } else if (state is SocialRegisterErrorState) {
            showToast(message: '${state.error}', states: ToastStates.ERROR);
          }

          if (state is SocialCreateSuccessState) {
            CashHelper.saveData(key: 'uId', value: '${state.uId}')
                .then((value) {
              SocialCubit.get(context).getPosts();
              SocialCubit.get(context).getUserData();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SocialLayout()));
            });
          }
        },
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
                          "انشئ حساب",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
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
                          height: 30,
                        ),
                        defaultFormField(
                          type: TextInputType.phone,
                          prefix: Icons.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "ادخل رقم الجوال";
                            }
                            return null;
                          },
                          label: 'رقم الجوال',
                          textEditingController: phoneController,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          type: TextInputType.name,
                          prefix: Icons.person,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "ادخل الاسم";
                            }
                            return null;
                          },
                          label: 'الاسم',
                          textEditingController: nameController,
                        ),
                        SizedBox(
                          height: 30,
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
                            if (formKey.currentState!.validate()) {}
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
                        (state is! SocialRegisterLoadState)
                            ? defaultButton(
                                text: "تسجيل",
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    SocialRegisterCubit.get(context)
                                        .userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                })
                            : load(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('هل لديك حساب ؟'),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SocialLoginScreen()));
                                },
                                child: Text("ادخل الآن"))
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
      ),
    );
  }

  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

/*
* */
