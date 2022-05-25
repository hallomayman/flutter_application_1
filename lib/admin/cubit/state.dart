abstract class AdminState{}

class AdminInitialState extends AdminState{}

class AdminLoadingGetPostsState extends AdminState{}

class AdminGetPostsSuccessState extends AdminState{}

class AdminGetPostsErrorState extends AdminState{
  final String error;

  AdminGetPostsErrorState(this.error);

}

class AdminDeletePostsSuccessState extends AdminState{}

class AdminDeletePostsErrorState extends AdminState{
  final String error;

  AdminDeletePostsErrorState(this.error);
}

class AdminSearchPostsSuccessState extends AdminState{}

class AdminSearchPostsErrorState extends AdminState{
  final String error;

  AdminSearchPostsErrorState(this.error);
}

class AdminImagePickedSuccessState extends AdminState{}

class AdminImagePickedErrorState extends AdminState{}

class AdminPostRemovePostImageState extends AdminState{}

class AdminUpdatePostSuccessState extends AdminState{}

class AdminUpdatePostErrorState extends AdminState{}

class AdminUpdatePostLoadingState extends AdminState{}


// Create Post

class AdminCreatePostLoadingState extends AdminState{}

class AdminCreatePostSuccessState extends AdminState{}

class AdminCreatePostErrorState extends AdminState{}


