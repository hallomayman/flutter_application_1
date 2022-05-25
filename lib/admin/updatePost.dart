import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/admin_dash.dart';
import 'package:flutter_application_1/admin/cubit/cubit.dart';
import 'package:flutter_application_1/admin/cubit/state.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/post_model.dart';

class UpdatePostScreen extends StatelessWidget {
  PostsModel model;
  UpdatePostScreen({required this.model});

  @override
  Widget build(BuildContext context) {
    var text = TextEditingController();

    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) async {
        if (state is AdminUpdatePostLoadingState) {
          showToast(message: "جاري النشر", states: ToastStates.WARNING);
        }

        if (state is AdminImagePickedSuccessState) {
          showToast(message: "تم إختيار الصورة", states: ToastStates.SUCCESS);
        }

        if (state is AdminPostRemovePostImageState) {
          showToast(message: "تم إزالة الصورة", states: ToastStates.WARNING);
        }

        if (state is AdminUpdatePostSuccessState) {
          showToast(message: "تم تعديل المنشور", states: ToastStates.SUCCESS);
          // Timer(Duration(seconds: 20),(){});
          Timer(Duration(seconds: 1), () {
            showToast(
                message: "سيتم نقلك للشاشة الرئيسية خلال ثواني",
                states: ToastStates.SUCCESS);
          });
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DashScreen()));
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        text.text = model.text!;
        var cubit = AdminCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (text.text.isEmpty && cubit.postImage == null) {
                    showToast(
                        message: "أدخل نص أو أضف صورة",
                        states: ToastStates.WARNING,
                        toastLength: Toast.LENGTH_LONG);
                  } else {
                    cubit.updateNewPost(id: model.postId, text: text.text);
                    cubit.postImage = null;
                    text.text = '';
                  }
                },
                child: Text(
                  'تعديل',
                ),
              ),
            ],
            title: Text("تعديل خبر"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is AdminUpdatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is AdminUpdatePostLoadingState) SizedBox(height: 7.0),
                Expanded(
                  child: TextFormField(
                    controller: text,
                    decoration: InputDecoration(
                      hintText: '${model.text ?? "اكتب التعديل"}',
                      border: InputBorder.none,
                    ),
                    onFieldSubmitted: (val) {
                      if (val.toString() != "") {
                        model.text = val;
                      }
                    },
                  ),
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.removePostImage();
                        },
                        icon: CircleAvatar(
                            radius: 20.0,
                            child: Icon(
                              Icons.close,
                              size: 16.0,
                            )),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            cubit.getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text("أضف صورة"),
                            ],
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text("# المصدر"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
