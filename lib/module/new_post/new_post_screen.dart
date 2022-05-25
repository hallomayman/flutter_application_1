import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/cubit/cubit.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../layout/cubit/states.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = TextEditingController();

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) async {
        if (state is SocialCreatePostLoadingState) {
          showToast(message: "جاري النشر", states: ToastStates.WARNING);
        }

        if (state is SocialPostPickedSuccessState) {
          showToast(message: "تم إختيار الصورة", states: ToastStates.SUCCESS);
        }

        if (state is SocialPostRemovePostImageState) {
          showToast(message: "تم إزالة الصورة", states: ToastStates.WARNING);
        }

        if (state is SocialCreatePostSuccessState) {
          showToast(message: "تم نشر المنشور", states: ToastStates.SUCCESS);
          // Timer(Duration(seconds: 20),(){});
          Timer(Duration(seconds: 1), () {
            showToast(
                message: "سيتم نقلك للشاشة الرئيسية خلال ثواني",
                states: ToastStates.SUCCESS);
          });
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SocialLayout()));
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        var model = SocialCubit.get(context).userModel;
        var cubit = SocialCubit.get(context);
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
                    var now = new DateTime.now();
                    var formatter = new DateFormat('dd-MM-yyyy', 'ar');
                    String formattedTime =
                        DateFormat('kk:mm:a', 'ar').format(now);
                    String formattedDate = formatter.format(now);
                    cubit.createNewPost(
                        dateTime: "$formattedTime $formattedDate",
                        text: text.text);
                    cubit.postImage = null;
                    text.text = '';
                  }
                },
                child: Text(
                  'نشر',
                ),
              ),
            ],
            title: Text("نشر خبر"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  SizedBox(height: 7.0),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        "${model!.image}",
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Text(
                        "${model.name}",
                        style: TextStyle(height: 1.3),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: text,
                    decoration: InputDecoration(
                      hintText: 'ما هي آخر الأخبار يا  ${model.name} ؟...',
                      border: InputBorder.none,
                    ),
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
