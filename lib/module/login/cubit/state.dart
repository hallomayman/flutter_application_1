

abstract class SocialLogInState{}

class SocialLogInInitialState extends SocialLogInState{}

class SocialLogInLoadState extends SocialLogInState{}

class SocialLogInSuccessState extends SocialLogInState
{
  final String uId;
  SocialLogInSuccessState(this.uId);
}
class SocialLogInAdminSuccessState extends SocialLogInState
{
  SocialLogInAdminSuccessState();
}

class SocialLogInAdminErrorState extends SocialLogInState
{
  SocialLogInAdminErrorState();
}


class SocialLogInErrorState extends SocialLogInState{
  final String error;
  SocialLogInErrorState(this.error);
}