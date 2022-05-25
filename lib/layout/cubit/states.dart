
abstract class SocialStates{}

class SocialInitialState extends SocialStates{}

class SocialChangeBottomNavState extends SocialStates{}

class SocialNewPostState extends SocialStates{}

class SocialLoadingGetUserState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates{
  final String error;

  SocialGetUserErrorState(this.error);

}

class SocialLoadingGetAllUserState extends SocialStates{}

class SocialGetAllUserSuccessState extends SocialStates{}

class SocialGetAllUserErrorState extends SocialStates{
  final String error;

  SocialGetAllUserErrorState(this.error);

}

class SocialImagePickedSuccessState extends SocialStates{}

class SocialImagePickedErrorState extends SocialStates{}

class SocialUploadImageSuccessState extends SocialStates{}

class SocialUploadImageErrorState extends SocialStates{}


class SocialCoverPickedSuccessState extends SocialStates{}

class SocialCoverPickedErrorState extends SocialStates{}

class SocialUploadCoverSuccessState extends SocialStates{}

class SocialUploadCoverErrorState extends SocialStates{}

class SocialUpdateLoadingState extends SocialStates{}

class SocialUpdateLoadingImageProfileState extends SocialStates{}

class SocialUpdateLoadingImageCoverState extends SocialStates{}

class SocialUpdateErrorState extends SocialStates{}

// Create Post

class SocialCreatePostLoadingState extends SocialStates{}

class SocialCreatePostSuccessState extends SocialStates{}

class SocialCreatePostErrorState extends SocialStates{}

class SocialPostPickedSuccessState extends SocialStates{}

class SocialPostPickedErrorState extends SocialStates{}

//remove image Post State

class SocialPostRemovePostImageState extends SocialStates{}


//get Posts

class SocialLoadingGetPostsState extends SocialStates{}

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates{
  final String error;

  SocialGetPostsErrorState(this.error);

}

//likes posts

class SocialLikePostSuccessState extends SocialStates{}

class SocialLikePostErrorState extends SocialStates{
  final String error;

  SocialLikePostErrorState(this.error);

}

class SocialUnLikePostSuccessState extends SocialStates{}

class SocialUnLikePostErrorState extends SocialStates{
  final String error;

  SocialUnLikePostErrorState(this.error);

}

//chat


class SocialSendMessageSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{
  final String error;

  SocialSendMessageErrorState(this.error);
}

class SocialGetMessageSuccessState extends SocialStates{}

class SocialGetMessageErrorState extends SocialStates{
  final String error;

  SocialGetMessageErrorState(this.error);
}

class GetUserPostsLoadingState extends SocialStates {}

class GetUserPostsSuccessState extends SocialStates {}

class GetUserPostsErrorState extends SocialStates {
  String error;
  GetUserPostsErrorState(this.error);
}

class GetCommentsSuccessState extends SocialStates {}

class GetCommentsErrorState extends SocialStates {
  String error;
  GetCommentsErrorState(this.error);
}

class SendCommentsSuccessState extends SocialStates {}

class SendCommentsErrorState extends SocialStates {
  String error;
  SendCommentsErrorState(this.error);
}
