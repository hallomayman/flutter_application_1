import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/cubit/cubit.dart';
import 'package:flutter_application_1/layout/cubit/states.dart';
import 'package:flutter_application_1/models/post_model.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_application_1/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsScreen extends StatelessWidget {
  PostsModel postsModel;

  CommentsScreen({
    required this.postsModel,
  });
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, builder) {},
          builder: (context, builder) {
            return Scaffold(
                appBar: AppBar(),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(
                                "${postsModel.image}",
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
                                      "${postsModel.name}",
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
                                  "${postsModel.dateTime.toString()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
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
                        if (postsModel.postImage != '' &&
                            postsModel.postImage != null)
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(top: 15.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                image: DecorationImage(
                                  image:
                                      NetworkImage("${postsModel.postImage}"),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
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
                                          "${postsModel.likes ?? 0}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
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
                                          "${SocialCubit.get(context).commentsList.length} تعليق",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
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
                        (SocialCubit.get(context).commentsList != null)
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        buildComment(SocialCubit.get(context)
                                            .commentsList[index]),
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    itemCount: SocialCubit.get(context)
                                        .commentsList
                                        .length),
                              )
                            : Text('لا يوجد تعليقات'),
                        Divider(),
                        defaultFormField(
                            textEditingController: commentController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (value != null) {}
                              return 'اكتب تعليق';
                            },
                            label: 'اكتب تعليق',
                            prefix: IconBroken.Send,
                            suffix: Icons.send,
                            fSuffix: () {
                              if (commentController.text != "") {
                                SocialCubit.get(context)
                                    .commentsList
                                    .add(commentController.text);
                                SocialCubit.get(context)
                                    .addPostComments(postsModel.postId!);
                                commentController.text = '';
                              }
                              return 'أكتب تعليق';
                            },
                            onSubmitted: (value) {
                              SocialCubit.get(context)
                                  .commentsList
                                  .add(commentController.text);
                              SocialCubit.get(context)
                                  .addPostComments(postsModel.postId!);
                              commentController.text = '';
                            }),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }

  Widget buildComment(String comment) => Container(
      height: 50.0,
      child: Text(
        '$comment',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ));
}
