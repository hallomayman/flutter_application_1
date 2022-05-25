import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/layout/cubit/states.dart';
import 'package:flutter_application_1/models/post_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/module/chats/chats_screen.dart';
import 'package:flutter_application_1/module/feed/feeds_screen.dart';
import 'package:flutter_application_1/module/settings/settings_screen.dart';
import 'package:flutter_application_1/module/userscreen/user_screen.dart';
import 'package:flutter_application_1/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/message_model.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialLoadingGetUserState());
    print(uId);
    FirebaseFirestore.instance
      ..collection('users').doc(uId).get().then((value) {
        userModel = UserModel.fromJson(value.data()!);
        emit(SocialGetUserSuccessState());
      }).catchError((error) {
        print('${error.toString()}');
        emit(SocialGetUserErrorState('${error.toString()}'));
      });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    Container(),
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ['آخر الأخبار', "الدردشة", "", "الصحفيين", "الإعدادات"];

  void changeBottomNav(int index) {
    if (index == 1 || index == 3) getUsers();
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? image;

  var picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(SocialImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(SocialImagePickedErrorState());
    }
  }

  File? coverImage;

  var pickerCover = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile = await pickerCover.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverPickedSuccessState());
    } else {
      print("No Image Selected");
      emit(SocialCoverPickedErrorState());
    }
  }

  void uploadProfileImage() {
    emit(SocialUpdateLoadingImageProfileState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        userModel!.image = value;
        print(value.toString());
        this.image = null;
        emit(SocialUploadImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadImageErrorState());
    });
  }

  void uploadCoverImage() {
    emit(SocialUpdateLoadingImageCoverState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        userModel!.coverP = value;
        print(value.toString());
        this.coverImage = null;
        emit(SocialUploadCoverSuccessState());
      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadCoverErrorState());
    });
  }

  void updateUser({
    required name,
    required phone,
    required bio,
  }) {
    emit(SocialUpdateLoadingState());

    var model = UserModel(
            name: name,
            phone: phone,
            bio: bio,
            email: userModel!.email,
            image: userModel!.image,
            isEmailVerified: userModel!.isEmailVerified,
            uId: userModel!.uId,
            coverP: userModel!.coverP)
        .toMap();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model)
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateErrorState());
    });
  }

  File? postImage;

  var pickerPost = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile = await pickerPost.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostPickedSuccessState());
    } else {
      print("No Image Selected");
      emit(SocialPostPickedErrorState());
    }
  }

//my work create post and handle

  void removePostImage() {
    postImage = null;
    emit(SocialPostRemovePostImageState());
  }

  void createNewPost({
    required dateTime,
    String? text,
  }) {
    emit(SocialCreatePostLoadingState());
    PostsModel postsModel = PostsModel(
        uId: userModel!.uId,
        name: userModel!.name,
        image: userModel!.image,
        postImage: '',
        commentsList: [],
        text: text ?? '',
        dateTime: dateTime);
    if (postImage != null) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
          .putFile(postImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          postsModel.postImage = value;
          FirebaseFirestore.instance
              .collection('posts')
              .add(postsModel.toMap())
              .then((value) {
            FirebaseFirestore.instance
                .collection('posts')
                .doc(value.id)
                .collection('likes')
                .doc(userModel!.uId)
                .update({'like': false});
            emit(SocialCreatePostSuccessState());
            getUserData();
          }).catchError((error) {
            print(error.toString());
            emit(SocialCreatePostErrorState());
          });
        }).catchError((error) {
          print(error.toString());
          emit(SocialUploadImageErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        emit(SocialPostPickedErrorState());
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .add(postsModel.toMap())
          .then((value) {
        emit(SocialCreatePostSuccessState());
        // getUserData();
      }).catchError((error) {
        print(error.toString());
        emit(SocialCreatePostErrorState());
      });
    }
  }

  //get Posts
  List<PostsModel> posts = [];
  List<String> likeElementIDS = [];

  void getPosts() {
    emit(SocialLoadingGetPostsState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((value) {
      posts = [];
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(element.id)
            .collection('likes')
            .snapshots()
            .listen((likeVal) {
          likeElementIDS = [];
          likeVal.docs.forEach((likeElement) {
            if (likeElement.data()['like']) {
              likeElementIDS.add(likeElement.id);
            }
          });
          FirebaseFirestore.instance
              .collection('posts')
              .doc(element.id)
              .update({'postId': element.id, 'usersIdLiked': likeElementIDS});
        }).onError((error) {
          emit(SocialGetPostsErrorState(error.toString()));
        });
        posts.add(PostsModel.fromJson(element.data()));
      });
    }).onError((error) {
      print(error.toString());
      emit(SocialGetPostsErrorState(error.toString()));
    });
    emit(SocialGetPostsSuccessState());
  }

  void likePost(String docId, PostsModel model, index) {
    int likess = model.usersIdLiked?.length ?? 0;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(docId)
        .get()
        .then((value) {
      likess = value.get('likes') ?? 0;
    }).then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(docId)
          .collection('likes')
          .doc(userModel!.uId)
          .set(({'like': true}))
          .then((value) {
        //  userModel!.boolLiked =true;
        FirebaseFirestore.instance
            .collection('posts')
            .doc(docId)
            .update({'likes': ++likess});
        posts[index].likes = likess;
        userPosts[index].likes = likess;
        emit(SocialLikePostSuccessState());
      }).catchError((error) {
        emit(SocialLikePostErrorState(error.toString()));
      });
    });
  }

  void unlikePost(String docId, PostsModel model, index) {
    int likess = model.usersIdLiked?.length ?? 0;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(docId)
        .get()
        .then((value) {
      likess = value.get('likes') ?? 0;
    }).then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(docId)
          .collection('likes')
          .doc(userModel!.uId)
          .update({'like': false}).then((value) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(docId)
            .update({'likes': (likess != 0) ? --likess : likess});
        posts[index].likes = likess;
        userPosts[index].likes = likess;
        emit(SocialUnLikePostSuccessState());
      }).catchError((error) {
        emit(SocialUnLikePostErrorState(error.toString()));
      });
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    users = [];
    emit(SocialLoadingGetAllUserState());
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.id != userModel!.uId)
            users.add(UserModel.fromJson(element.data()));
        });
        emit(SocialGetAllUserSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUserErrorState(error.toString()));
      });
  }

  void sendMessage({
    required String receivedId,
    required var dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
        text: text,
        receiverId: receivedId,
        dateTime: dateTime,
        senderId: userModel!.uId);

    //me send
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receivedId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });

    //me Received

    FirebaseFirestore.instance
        .collection('users')
        .doc(receivedId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getMessages({required String receivedId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receivedId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    }).onError((error) {
      emit(SocialGetMessageErrorState(error.toString()));
    });
  }

  List<PostsModel> userPosts = [];
  List<String> userPostsId = [];
  List<int> userPostsLikes = [];

  void getUserPostsData({required String id}) {
    userPosts = [];
    userPostsId = [];
    userPostsLikes = [];
    emit(GetUserPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          if (element.data()['uId'] == id) {
            userPosts.add(PostsModel.fromJson(element.data()));
            userPostsLikes.add(value.docs.length);
            userPostsId.add(element.id);
            print(posts[0].dateTime);
            emit(GetUserPostsSuccessState());
          }
        }).catchError((error) {});
      });
      print(posts[0].dateTime);
      emit(GetUserPostsSuccessState());
    }).catchError((error) {
      emit(GetUserPostsErrorState(error));
    });
  }

  List<String> commentsList = [];

  void getPostComments(String id) {
    commentsList = [];
    FirebaseFirestore.instance.collection('posts').doc(id).get().then((value) {
      value.data()!['commentsList'].forEach((element) {
        commentsList.add(element.toString());
      });
      emit(GetCommentsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(GetCommentsErrorState(onError.toString()));
    });
  }

  void addPostComments(String id) {
    FirebaseFirestore.instance.collection('posts').doc(id).update({
      'commentsList': commentsList,
      'comments': commentsList.length
    }).then((value) {
      posts[posts.indexWhere((element) => element.postId == id)].comments =
          commentsList.length;
      posts[posts.indexWhere((element) => element.postId == id)].commentsList =
          commentsList;
      emit(SendCommentsSuccessState());
    }).catchError((onError) {
      emit(SendCommentsErrorState(onError.toString()));
    });
  }
}


/*  void updateUserImages({
    required name,
    required phone,
    required bio,
}) {

    emit(SocialUpdateLoadingState());
    if(image != null){
      uploadProfileImage();
    }else if(coverImage != null){
      uploadCoverImage();
    }else if(coverImage != null && image != null){}else{

    }
  }*/
/*var len= value.data()!['posts']??0;
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userModel!.uId).update({'posts': [{len: postsModel.toMap()}]});*/
