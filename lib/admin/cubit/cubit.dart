import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/admin/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/post_model.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitialState());

  static AdminCubit get(context) => BlocProvider.of(context);
  List<PostsModel> posts = [];
  List<String> likeElementIDS = [];

  void getPosts() {
    emit(AdminLoadingGetPostsState());
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
          emit(AdminGetPostsErrorState(error.toString()));
        });
        posts.add(PostsModel.fromJson(element.data()));
      });
    }).onError((error) {
      print(error.toString());
      emit(AdminGetPostsErrorState(error.toString()));
    });
    emit(AdminGetPostsSuccessState());
  }

  void deletePost(PostsModel postsModel) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postsModel.postId)
        .delete()
        .then((value) {
      posts.removeWhere((element) => element == postsModel);
      emit(AdminDeletePostsSuccessState());
    }).catchError((onError) {
      emit(AdminDeletePostsErrorState(onError.toString()));
    });
  }

  List<PostsModel> postsSearch = [];
  List<String> likeElementIdSearch = [];

  void searchPost(String name) {
    emit(AdminLoadingGetPostsState());
    posts.where((element) => element.name!.contains(name)).forEach((element) {
      postsSearch.add(element);
    });
    if (postsSearch.length > 0) {
      emit(AdminSearchPostsSuccessState());
    } else {
      emit(AdminSearchPostsErrorState('لا يوجد أخبار لهذا الناشر'));
    }
  }

  File? postImage;

  var pickerPost = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile = await pickerPost.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(AdminImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(AdminImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(AdminPostRemovePostImageState());
  }

  void updateNewPost({
    String? text,
    String? id,
  }) {
    emit(AdminUpdatePostLoadingState());
    if (postImage != null) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
          .putFile(postImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          String image = value;
          FirebaseFirestore.instance.collection('posts').doc(id).update({
            'postImage': image,
            'text': text,
          });
          getPosts();
          emit(AdminUpdatePostSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(AdminUpdatePostErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        emit(AdminUpdatePostErrorState());
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(id)
          .update({'text': text}).then((value) {
        getPosts();
        emit(AdminUpdatePostSuccessState());
        // getUserData();
      }).catchError((error) {
        print(error.toString());
        emit(AdminUpdatePostErrorState());
      });
    }
  }
}
