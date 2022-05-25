import 'package:flutter/material.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 20.0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png"),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              "الدردشات",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 15.0,
                child: Icon(
                  Icons.edit,
                  size: 16.0,
                  color: Colors.white,
                ),
              )),
          IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 15.0,
                child: Icon(
                  Icons.camera_alt,
                  size: 16.0,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text("بحث"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.16,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    width: 20.0,
                  ),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => buildStoryItem(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemBuilder: (context, index) => buildChatItem(),
                  separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                  itemCount: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChatItem() => Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                    "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png"),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(bottom: 3.0, start: 3.0),
                child: CircleAvatar(
                  radius: 7.0,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "أحمد إبراهيم أبو نجا",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "الرسالة أرسلت الساعة العاشرة صباحاً",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: 7.0,
                        height: 7.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Text("2:33 ص"),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget buildStoryItem() => Container(
        width: MediaQuery.of(context).size.width * 0.16,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 3.0, start: 3.0),
                  child: CircleAvatar(
                    radius: 7.0,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            Text(
              "أحمد إبراهيم أبو نجا",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
