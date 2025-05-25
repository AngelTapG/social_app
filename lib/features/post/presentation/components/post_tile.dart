import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_jose_gael/features/auth/domain/entities/app_user.dart';
import 'package:social_app_jose_gael/features/auth/presentation/components/my_text_field.dart';
import 'package:social_app_jose_gael/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_app_jose_gael/features/post/domain/entities/comment.dart';
import 'package:social_app_jose_gael/features/post/domain/entities/post.dart';
import 'package:social_app_jose_gael/features/post/presentation/components/comment_tile.dart';
import 'package:social_app_jose_gael/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_app_jose_gael/features/post/presentation/cubits/post_states.dart';
import 'package:social_app_jose_gael/features/profile/domain/data/presentation/pages/cubits/profile_cubit.dart';
import 'package:social_app_jose_gael/features/profile/domain/data/presentation/pages/entities/profile_user.dart';
import 'package:social_app_jose_gael/features/profile/domain/data/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // Cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = widget.post.userId == currentUser?.uid;
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((_) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  final commentTextController = TextEditingController();

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new comment"),
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    if (commentTextController.text.isEmpty) return;

    final newComment = Comment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    postCubit.addComment(widget.post.id, newComment);
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed?.call();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // Top section: profile pic / name / delete button
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(uid: widget.post.userId),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  if (postUser?.profileImageUrl != null)
                    CachedNetworkImage(
                      imageUrl: postUser!.profileImageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Icon(Icons.person),
                    )
                  else
                    const Icon(Icons.person),
                  const SizedBox(width: 10),
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOptions,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Post image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox(height: 430),
            errorWidget: (_, __, ___) => const Icon(Icons.error),
          ),

          // Action buttons: like, comment, timestamp
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: toggleLikePost,
                      child: Icon(
                        widget.post.likes.contains(currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.post.likes.contains(currentUser!.uid)
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.post.likes.length.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(widget.post.text),
              ],
            ),
          ),

          // Comment section
          BlocBuilder<PostCubit, PostStates>(
            builder: (context, state) {
              if (state is PostsLoaded) {
                final updatedPost = state.posts.firstWhere(
                  (p) => p.id == widget.post.id,
                );
                if (updatedPost.comments.isNotEmpty) {
                  return ListView.builder(
                    itemCount: updatedPost.comments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CommentTile(
                        comment: updatedPost.comments[index],
                      );
                    },
                  );
                }
              } else if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostsError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
