
abstract class SocialRegisterState{}

class SocialRegisterInitialState extends SocialRegisterState{}

class SocialRegisterLoadState extends SocialRegisterState{}

class SocialRegisterSuccessState extends SocialRegisterState
{
}

class SocialRegisterErrorState extends SocialRegisterState{
  final String error;
  SocialRegisterErrorState(this.error);
}

class SocialCreateLoadState extends SocialRegisterState{}

class SocialCreateSuccessState extends SocialRegisterState
{
  final String uId;

  SocialCreateSuccessState(this.uId);

}

class SocialCreateErrorState extends SocialRegisterState{
  final String error;
  SocialCreateErrorState(this.error);
}