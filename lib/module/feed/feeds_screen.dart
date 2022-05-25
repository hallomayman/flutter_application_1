import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/cubit/cubit.dart';
import 'package:flutter_application_1/layout/cubit/states.dart';
import 'package:flutter_application_1/models/post_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/module/UserProfileScreen/user_profile_screen.dart';
import 'package:flutter_application_1/module/feed/comments.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_application_1/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return SafeArea(
                child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5.0,
                    margin: EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image(
                          image: NetworkImage(
                              "https://image.freepik.com/free-photo/worker-reading-news-with-tablet_1162-83.jpg"),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('هيما نيوز',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontFamily: 'Jannah',
                                    color: Colors.white,
                                  )),
                        ),
                      ],
                    ),
                  ),
                  (cubit.posts.length > 0)
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildPostItem(context, cubit.posts[index], index),
                          itemCount: cubit.posts.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: 10.0,
                          ),
                        )
                      : Center(
                          child: load(),
                        ),
                ],
              ),
            ));
          },
        );
      },
    );
  }

  Widget buildPostItem(context, PostsModel postModel, index) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  int ind = SocialCubit.get(context)
                      .users
                      .indexWhere((element) => element.uId == postModel.uId);
                  UserModel us = SocialCubit.get(context).users[ind];
                  navigateTo(
                      context,
                      ProfileScreen(
                        user: us,
                      ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        "${postModel.image}",
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${postModel.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 16.0,
                            ),
                          ],
                        ),
                        Text(
                          "${postModel.dateTime.toString()}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                height: 1.4,
                              ),
                        ),
                      ],
                    )),
                    SizedBox(
                      width: 15.0,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_horiz,
                          size: 16.0,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(),
              ),
              if (postModel.text != null && postModel.text != '')
                Text(
                  "${postModel.text}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontFamily: 'Jannah',
                      ),
                ),
              if (postModel.postImage != '' && postModel.postImage != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 15.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage("${postModel.postImage}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                IconBroken.Heart,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "${postModel.likes ?? 0}",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                IconBroken.Chat,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "${postModel.comments} تعليق",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        SocialCubit.get(context)
                            .getPostComments(postModel.postId!);
                        navigateTo(
                            context,
                            CommentsScreen(
                              postsModel: postModel,
                            ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(
                              "${SocialCubit.get(context).userModel?.image ?? "https://image.freepik.com/free-vector/startup-man-composition_1284-16346.jpg"}",
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            "أكتب تعليق ....",
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "اعجبني",
                          style:
                              Theme.of(context).textTheme.caption!.copyWith(),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (postModel.usersIdLiked!
                          .contains(SocialCubit.get(context).userModel!.uId)) {
                        print("true Sir asdasdasasd");
                        SocialCubit.get(context)
                            .unlikePost(postModel.postId!, postModel, index);
                      } else {
                        SocialCubit.get(context)
                            .likePost(postModel.postId!, postModel, index);
                      }
                      //SocialCubit.get(context).likePost(postModel.postId!, postModel);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
/*
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Container(
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 6.0),
                        child: Container(
                          height: 25.0,
                          child: MaterialButton(
                              minWidth: 1.0,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Text(
                                '#عمل',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 6.0),
                        child: Container(
                          height: 25.0,
                          child: MaterialButton(
                              minWidth: 1.0,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Text(
                                '#عمل',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 6.0),
                        child: Container(
                          height: 25.0,
                          child: MaterialButton(
                              minWidth: 1.0,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Text(
                                '#عمل',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.blue),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               */