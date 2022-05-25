import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/message_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;

  ChatDetailsScreen(this.userModel);

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receivedId: userModel.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage("${userModel.image}")),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text('${userModel.name}'),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Conditional.single(
                        fallbackBuilder: (BuildContext context) {
                          return Center(
                            child: load(),
                          );
                        },
                        context: context,
                        widgetBuilder: (BuildContext context) {
                          return Expanded(
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                var message =
                                    SocialCubit.get(context).messages[index];
                                if (SocialCubit.get(context).userModel!.uId ==
                                    message.senderId)
                                  return buildMessageReceived(message);

                                return buildMessageSend(message);
                              },
                              itemCount:
                                  SocialCubit.get(context).messages.length,
                              separatorBuilder:
                                  (BuildContext context, int index) => SizedBox(
                                height: 5.0,
                              ),
                            ),
                          );
                        },
                        conditionBuilder: (BuildContext context) {
                          return SocialCubit.get(context).messages.length > 0;
                        }),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: TextFormField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'أكتب رسالتك ....',
                                ),
                                onFieldSubmitted: (String? value) {
                                  if (value != '') {
                                    var now = new DateTime.now();
                                    SocialCubit.get(context).sendMessage(
                                        receivedId: userModel.uId!,
                                        dateTime: now,
                                        text: messageController.text);
                                    messageController.text = '';
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
                              color: Colors.blue,
                              child: IconButton(
                                onPressed: () {
                                  if (messageController.text != '') {
                                    var now = new DateTime.now();
                                    SocialCubit.get(context).sendMessage(
                                        receivedId: userModel.uId!,
                                        dateTime: now,
                                        text: messageController.text);
                                    messageController.text = '';
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessageSend(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
          ),
          child: Text("${message.text}"),
        ),
      );

  Widget buildMessageReceived(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue[300]!.withOpacity(.6),
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
          ),
          child: Text("${message.text}"),
        ),
      );
}
