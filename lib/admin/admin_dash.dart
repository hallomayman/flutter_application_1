import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/news.dart';
import 'package:flutter_application_1/admin/search.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_application_1/shared/components/constants.dart';
import 'package:flutter_application_1/shared/styles/icon_broken.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashScreen extends StatelessWidget {
  const DashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut(context);
              },
              icon: Icon(IconBroken.Logout)),
        ],
        title: Text("لوحة التحكم"),
        centerTitle: true,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'الأدمن',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              title: Text('كل الأخبار'),
              onTap: () {
                Navigator.of(context).pop();
                navigateTo(context, AllNewsScreen());
              },
            ),
            ListTile(
              title: Text('تعديل أو حذف خبر'),
              onTap: () {
                Navigator.of(context).pop();
                navigateTo(context, SearchAdminScreen());
              },
            ),
          ],
        ),
      ),
      body: _dashBoard(context),
    );
  }

  Widget _dashBoard(context) {
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        myItems(IconBroken.Paper, "كل الأخبار", Colors.orange, context,
            AllNewsScreen()),
        myItems(IconBroken.Paper_Plus, "تعديل وحذف الأخبار", Colors.pink,
            context, SearchAdminScreen()),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(2, 150.0),
      ],
    );
  }

  Material myItems(
      IconData iconData, String heading, Color color, context, Widget widget) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget,
              ));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(heading,
                          style: TextStyle(color: color, fontSize: 20)),
                    ), //text
                    Material(
                      color: color,
                      borderRadius: BorderRadius.circular(24.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          iconData,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ), //icon
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
