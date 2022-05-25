import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/module/register/cubit/state.dart';
import 'package:flutter_application_1/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SocialRegisterLoadState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      uId = value.user!.uid;
      userCreate(
          name: name, email: email, uId1: '${value.user!.uid}', phone: phone);
      showToast(
          message: '${value.user!.email} \nSuccess',
          states: ToastStates.SUCCESS);
      emit(SocialRegisterSuccessState());
    }).catchError((error) {
      showToast(message: '${error.toString()}', states: ToastStates.ERROR);
      emit(SocialRegisterErrorState('${error.toString()}'));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String uId1,
    required String phone,
  }) {
    emit(SocialCreateLoadState());
    UserModel model = UserModel(
        uId: uId1,
        name: name,
        phone: phone,
        email: email,
        image:
            "https://avatars.hsoubcdn.com/59e2807ffcb655212853f59fa503ab4e?s=256",
        coverP:
            "https://image.freepik.com/free-photo/emotional-bearded-male-has-surprised-facial-expression-astonished-look-dressed-white-shirt-with-red-braces-points-with-index-finger-upper-right-corner_273609-16001.jpg",
        bio: 'write you bio ....',
        isEmailVerified: false);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId1)
        .set(model.toMap())
        .then((value) {
      uId = uId1;
      emit(SocialCreateSuccessState('$uId1'));
    }).catchError((error) {
      emit(SocialCreateErrorState('${error.toString()}'));
    });
  }
}
