class UserModel {
  String? uId;
  String? name;
  String? phone;
  String? email;
  String? image;
  String? coverP;
  String? bio;
  bool? isEmailVerified;
  var boolLiked;

  UserModel({
    this.uId,
    this.name,
    this.phone,
    this.email,
    this.image,
    this.coverP,
    this.bio,
    this.isEmailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json["image"];
    coverP = json["cover"];
    bio = json["bio"];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'cover': coverP,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
