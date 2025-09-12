import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/post/domain/entities/comment.dart';
import 'package:insta_clone/features/post/domain/entities/post.dart';
import 'package:insta_clone/features/post/domain/repos/post_repo.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_state.dart';
import 'package:insta_clone/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({required this.postRepo, required this.storageRepo})
    : super(PostsInitial());

  // create new post
  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    try {
      // handle image upload for mobile platforms (using file paht)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }
      // handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // create post in backend
      postRepo.createPost(newPost);

      // re-fetch all posts
      fetchAllPosts();
    } catch (e) {
      emit(PostsError("failed to create post: $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostsError("Not deleted"));
    }
  }

  // toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  // toggle like to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  // delete comment froma a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
