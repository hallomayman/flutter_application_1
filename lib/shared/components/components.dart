import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../admin/cubit/cubit.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backGround = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40,
      child: MaterialButton(
        child: Text(
          (isUpperCase) ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: function,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backGround,
      ),
    );

Widget defaultAppBar({
  context,
  title,
  actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios),
      ),
      title: Text(title),
      actions: actions,
    );

Widget defaultFormField({
  required TextEditingController textEditingController,
  required TextInputType type,
  bool isPassword = false,
  onSubmitted,
  onChange,
  onTap,
  required validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  fSuffix,
  bool isSelectedAble = true,
}) =>
    TextFormField(
      controller: textEditingController,
      keyboardType: type,
      enabled: isSelectedAble,
      onFieldSubmitted: onSubmitted,
      onChanged: onChange,
      obscureText: isPassword,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: (suffix != null)
            ? IconButton(onPressed: fSuffix, icon: Icon(suffix))
            : null,
        border: OutlineInputBorder(),
      ),
      validator: validate,
    );

Widget buildTaskItem(
        {required String title,
        required String date,
        required String time,
        required int id,
        context}) =>
    Dismissible(
      key: Key('$id'),
      onDismissed: (direction) {},
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(time),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  //AppCubit.get(context).updateData(status: 'done', id: id);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  // AppCubit.get(context).updateData(status: 'archive', id: id);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );

Widget tasksBuilder({required List<Map> tasks}) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(
        title: tasks[index]['title'],
        date: tasks[index]['date'],
        time: tasks[index]['time'],
        id: tasks[index]['id'],
        context: context),
    separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Divider(),
        ),
    itemCount: tasks.length);

void showToast(
        {required String message,
        required ToastStates states,
        toastLength = Toast.LENGTH_SHORT}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chooseStateColor(states),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseStateColor(ToastStates states) {
  Color color;

  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget load() => Center(
      child: CircularProgressIndicator(),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Widget buildUsersListItem(context, UserModel user, Widget widget) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          navigateTo(context, widget);
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                '${user.image}',
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${user.name}',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );

void navigateAndFinsh(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

Widget defultOutLinedButton({
  required Function onTap,
  required String text,
  required IconData icon,
}) =>
    OutlinedButton(
        style: ButtonStyle(
            side: MaterialStateProperty.all(
          BorderSide(color: defaultColor, width: 2),
        )),
        onPressed: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                icon,
                color: Colors.red[700],
                size: 30,
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ));

Future<void> showMyDialog(context, PostsModel postsModel) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('هل أنت متأكد'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('هل أنت متأكد من حذف الخبر.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('نعم'),
            onPressed: () {
              AdminCubit.get(context).deletePost(postsModel);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('لا'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
