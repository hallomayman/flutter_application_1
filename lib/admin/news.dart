import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/post_model.dart';
import 'package:flutter_application_1/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class AllNewsScreen extends StatelessWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return BlocConsumer<AdminCubit, AdminState>(
            builder: (context, state) {
              var cubit = AdminCubit.get(context);
              return Scaffold(
                appBar: AppBar(),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: (cubit.posts.length > 0)
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
                          child: Column(
                            children: [
                              load(),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text("لا يوجد بيانات"),
                            ],
                          ),
                        ),
                ),
              );
            },
            listener: (context, state) {});
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
                      onPressed: () {
                        AdminCubit.get(context).deletePost(postModel);
                      },
                      icon: Icon(
                        Icons.delete,
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
            ],
          ),
        ),
      );
}
