import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/cubit/cubit.dart';
import 'package:flutter_application_1/layout/cubit/states.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  var _nameController = TextEditingController();
  var _bioController = TextEditingController();
  var _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialGetUserSuccessState) {
          showToast(message: "تم التعديل بنجاح", states: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        _nameController.text = userModel!.name!;
        _bioController.text = userModel.bio!;
        _phoneController.text = userModel.phone!;

        var userImage = SocialCubit.get(context).image;
        var userCover = SocialCubit.get(context).coverImage;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text("تعديل الملف الشخصي"),
            actions: [
              IconButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUser(
                        name: _nameController.text,
                        phone: _phoneController.text,
                        bio: _bioController.text);
                  },
                  icon: Icon(
                    Icons.check,
                  )),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is SocialUpdateLoadingState)
                      LinearProgressIndicator(),
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: userCover == null
                                          ? NetworkImage("${userModel.coverP}")
                                          : FileImage(userCover)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 16.0,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 65.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: userImage == null
                                      ? NetworkImage("${userModel.image}")
                                      : FileImage(userImage) as ImageProvider,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getImage();
                                },
                                icon: CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 16.0,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if (SocialCubit.get(context).image != null ||
                        SocialCubit.get(context).coverImage != null)
                      Row(
                        children: [
                          if (SocialCubit.get(context).coverImage != null)
                            Expanded(
                              child: Column(
                                children: [
                                  defaultButton(
                                      function: () {
                                        SocialCubit.get(context)
                                            .uploadCoverImage();
                                      },
                                      text: "رفع صورة الخلفية"),
                                  if (state
                                      is SocialUpdateLoadingImageCoverState)
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  if (state
                                      is SocialUpdateLoadingImageCoverState)
                                    LinearProgressIndicator(),
                                ],
                              ),
                            ),
                          SizedBox(
                            width: 7.0,
                          ),
                          if (SocialCubit.get(context).image != null)
                            Expanded(
                              child: Column(
                                children: [
                                  defaultButton(
                                      function: () {
                                        SocialCubit.get(context)
                                            .uploadProfileImage();
                                      },
                                      text: "رفع صورتك الشخصية"),
                                  if (state
                                      is SocialUpdateLoadingImageProfileState)
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  if (state
                                      is SocialUpdateLoadingImageProfileState)
                                    LinearProgressIndicator(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                        textEditingController: _nameController,
                        type: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'الرجاء إدخال الاسم';
                          }
                          return null;
                        },
                        onSubmitted: (val) {
                          if (val.toString() != "") {
                            userModel.name = val;
                          }
                        },
                        label: "أدخل اسمك",
                        prefix: Icons.account_circle),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      textEditingController: _bioController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال السيرة الذاتية';
                        }
                        return null;
                      },
                      onSubmitted: (val) {
                        if (val.toString() != "") {
                          userModel.bio = val;
                        }
                      },
                      label: "السيرة الذاتية",
                      prefix: Icons.info_rounded,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      textEditingController: _phoneController,
                      type: TextInputType.phone,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال الرقم';
                        }
                        return null;
                      },
                      onSubmitted: (val) {
                        if (val.toString() != "") {
                          userModel.phone = val;
                        }
                      },
                      label: "رقم الجوال",
                      prefix: Icons.phone,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
