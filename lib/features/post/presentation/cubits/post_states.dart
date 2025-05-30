/*
POST STATES
*/

import 'package:social_app_jose_gael/features/post/domain/entities/post.dart';

abstract class PostStates {}

// initial
class PostsInitial extends PostStates {}

// loading..
class PostLoading extends PostStates {}

// uploading..
class PostsUploading extends PostStates {}

// error
class PostsError extends PostStates {
  final String message;
  PostsError(this.message);
}

// loaded
class PostsLoaded extends PostStates {
  final List<Post> posts;
  PostsLoaded(this.posts);
}
