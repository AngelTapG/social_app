import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_jose_gael/features/auth/domain/entities/app_user.dart';
import 'package:social_app_jose_gael/features/auth/presentation/components/my_text_field.dart';
import 'package:social_app_jose_gael/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_app_jose_gael/features/post/domain/entities/post.dart';
import 'package:social_app_jose_gael/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_app_jose_gael/features/post/presentation/cubits/post_states.dart';
import 'package:social_app_jose_gael/responsive/constrained_scaffold.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image picker
  PlatformFile? pickedImage;

  // web image picker
  Uint8List? webPickedImage;

  // text controller -> caption
  final captionController = TextEditingController();

  // current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        pickedImage = result.files.first;

        if (kIsWeb) {
          webPickedImage = pickedImage!.bytes;
        }
      });
    }
  }

  // create & upload post
  void uploadPost() {
    if (pickedImage == null || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both image and caption are required")),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: captionController.text,
      imageUrl: '', // Se puede actualizar después con la URL real
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    final postCubit = context.read<PostCubit>();

    if (kIsWeb) {
      postCubit.createPost(newPost);
    } else {
      postCubit.createPost(newPost, imagePath: pickedImage?.path);
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      builder: (context, state) {
        // Debug

        // loading or uploading ..
        if (state is PostsUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            if (kIsWeb && webPickedImage != null) Image.memory(webPickedImage!),
            if (!kIsWeb && pickedImage != null)
              Image.file(File(pickedImage!.path!)),
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),
            MyTextField(
              controller: captionController,
              hintText: "Caption",
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
