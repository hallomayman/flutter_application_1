import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/cubit/cubit.dart';
import 'package:flutter_application_1/layout/cubit/states.dart';
import 'package:flutter_application_1/module/edit_profile/edit_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/icon_broken.dart';
import '../UserProfileScreen/user_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 190.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage("${userModel?.coverP}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 65.0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage("${userModel?.image}"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${userModel?.name}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "${userModel?.bio}",
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          navigateTo(
                              context,
                              ProfileScreen(
                                  user: SocialCubit.get(context).userModel!));
                        },
                        child: Text(
                          "رؤية المناشير",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                      },
                      child: Icon(
                        Icons.edit,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        FirebaseMessaging.instance
                            .subscribeToTopic('announcements');
                      },
                      child: Text(""
                          "إشتراك"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        FirebaseMessaging.instance
                            .unsubscribeFromTopic('announcements');
                      },
                      child: Text(""
                          "إلغاء الإشتراك"),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defultOutLinedButton(
                        onTap: () {
                          signOut(context);
                        },
                        text: 'تسجيل الخروج',
                        icon: IconBroken.Logout)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Text(
                                "${SocialCubit.get(context).userPostsId.length ?? 0}",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                "نشر",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Text(
                                "0",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                "الصور",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Text(
                                "0",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                "متابعون",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Text(
                                "0",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                "يتابع",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
