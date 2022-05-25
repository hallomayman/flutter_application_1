class PostsModel {
  String? uId;
  String? name;
  String? image;
  var dateTime;
  String? text;
  String? postImage;
  String? postId;
  int? likes;
  int? comments;
  List<dynamic>? usersIdLiked;
  late List<dynamic> commentsList;

  PostsModel({
    this.uId,
    this.name,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
    this.postId,
    this.likes,
    this.comments,
    this.usersIdLiked,
    required this.commentsList,
  });

  PostsModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    image = json["image"];
    dateTime = json["dateTime"];
    text = json["text"];
    postImage = json["postImage"];
    postId = json["postId"];
    likes = json["likes"];
    comments = json["comments"];
    usersIdLiked = json["usersIdLiked"] ?? [];
    commentsList = json['commentsList'] ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'image': image,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
      'postId': postId,
      'likes': likes ?? 0,
      'comments': comments ?? 0,
      'usersIdLiked': usersIdLiked ?? [],
      'commentsList': commentsList,
    };
  }
}

class LIKEDUSERS {
  String? postId;
  String? uId;
  LIKEDUSERS(this.postId, this.uId);

  LIKEDUSERS.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uId': uId,
    };
  }
}
