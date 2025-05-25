import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_jose_gael/features/post/data/firebase_post_repo.dart';
import 'package:social_app_jose_gael/features/post/domain/entities/comment.dart';
import 'package:social_app_jose_gael/features/post/domain/entities/post.dart';
import 'package:social_app_jose_gael/features/post/domain/repos/post_repo.dart';
import 'package:social_app_jose_gael/features/post/presentation/cubits/post_states.dart';
import 'package:social_app_jose_gael/features/storage/data/firebase_storage_repo.dart';
import 'package:social_app_jose_gael/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepository;
  final StorageRepo storageRepository;

  PostCubit({
    required this.postRepository,
    required this.storageRepository,
    required FirebasePostRepo postRepo,
    required FirebaseStorageRepo storageRepo,
  }) : super(PostsInitial());

  // Create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      // Handle image upload for mobile platforms (using file path)
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl =
            await storageRepository.uploadPostImageMobile(imagePath, post.id);
      }

      // Handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl =
            await storageRepository.uploadPostImageWeb(imageBytes, post.id);
      }

      // Assign image URL to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // Create post in the backend
      postRepository.createPost(newPost);

      // Re-fetch all posts
      fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepository.fecthAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepository.deletePost(postId);
    } catch (e) {
      emit(PostsError("Failed to delete post: $e"));
    }
  }

  // Toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepository.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  // Add a comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepository.addComment(postId, comment);
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  // Delete a comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepository.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
