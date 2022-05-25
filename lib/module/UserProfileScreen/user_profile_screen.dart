import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/post_model.dart';
import 'package:flutter_application_1/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/user_model.dart';
import '../../shared/styles/icon_broken.dart';

class ProfileScreen extends StatelessWidget {
  UserModel user;
  ProfileScreen({
    required this.user,
  });
  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).getUserPostsData(id: user.uId!);
    return Builder(builder: (context) {
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  IconBroken.Arrow___Right,
                  color: defaultColor,
                ),
              ),
              elevation: 1,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        height: 290,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  width: double.infinity,
                                  height: 240,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          '${user.coverP}',
                                        ),
                                      ))),
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 94,
                              child: CircleAvatar(
                                radius: 90,
                                backgroundImage: NetworkImage(
                                  '${user.image}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${user.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('${user.bio}',
                          style: Theme.of(context).textTheme.caption),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('أخبار',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                Text('${cubit.userPostsId.length}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                            /*Column(
                              children: [
                                Text(
                                  'الصور',
                                  style: Theme.of(context).textTheme.bodyText1
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.bodyText1
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'المتابعين',
                                  style: Theme.of(context).textTheme.bodyText1
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.bodyText1
                                )],
                            ),
                            Column(
                              children: [
                                Text(
                                  'يتابع',
                                  style: Theme.of(context).textTheme.bodyText1
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.bodyText1
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPostItem(
                              context, cubit.userPosts[index], index),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                          itemCount: cubit.userPosts.length),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
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
              Row(
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
                                "${SocialCubit.get(context).userPosts[index].likes ?? 0}",
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
                      onTap: () {},
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(
                              "${SocialCubit.get(context).userModel!.image}",
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
                      int i = SocialCubit.get(context).posts.indexWhere(
                          (element) => postModel.postId == element.postId);

                      if (SocialCubit.get(context)
                          .posts[i]
                          .usersIdLiked!
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
