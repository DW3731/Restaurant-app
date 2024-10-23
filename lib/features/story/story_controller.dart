import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../profile/controllers/profile_controller.dart';

class Story {
  final XFile? image;
  final XFile? video;
  final String? imageUrl;
  final String? videoUrl;

  Story({this.image, this.video, this.imageUrl, this.videoUrl});
}

class StoryController extends GetxController {
  Rx<Story?> story = Rx<Story?>(null);
  final ImagePicker _picker = ImagePicker();
  Map<String, VideoPlayerController> videoControllers = {};

  @override
  void onInit() {
    super.onInit();
    fetchStory();
  }

  Future<void> fetchStory() async {
    final vendorId = Get.find<ProfileController>().profileModel?.id?.toString();

    if (vendorId == null) {
      Get.snackbar('Error', 'Vendor ID is null');
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('stories').doc(vendorId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final imageUrl = data['imageUrl'] as String?;
        final videoUrl = data['videoUrl'] as String?;

        story.value = Story(
          imageUrl: imageUrl,
          videoUrl: videoUrl,
        );

        if (videoUrl != null) {
          await _initializeVideoControllerFromUrl(videoUrl);
        }
      } else {
        story.value = Story();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch story: $e');
    }
  }

  Future<void> _initializeVideoControllerFromUrl(String url) async {
    final controller = VideoPlayerController.network(url);
    await controller.initialize();
    controller.setLooping(true);
    videoControllers[url] = controller;
    update();
  }

  Future<void> addStoryToFirestore(XFile? image, XFile? video) async {
    final vendorId = Get.find<ProfileController>().profileModel?.id?.toString();
    final vendorEmail = Get.find<ProfileController>().profileModel?.email;
    final vendorName = Get.find<ProfileController>().profileModel?.restaurants![0].name;

    if (vendorId == null) {
      Get.snackbar('Error', 'Vendor ID is null');
      return;
    }

    try {
      String? imageUrl;
      String? videoUrl;

      final FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: 'gs://fooddeliverydw.appspot.com',
      );

      if (image != null) {
        final imageFile = File(image.path);
        final imageRef = storage.ref().child('stories/$vendorId/image.jpg');
        final imageUploadTask = await imageRef.putFile(imageFile);
        imageUrl = await imageUploadTask.ref.getDownloadURL();
      }

      if (video != null) {
        final videoFile = File(video.path);
        final videoRef = storage.ref().child('stories/$vendorId/video.mp4');
        final videoUploadTask = await videoRef.putFile(videoFile);
        videoUrl = await videoUploadTask.ref.getDownloadURL();
      }

      final docRef = FirebaseFirestore.instance.collection('stories').doc(vendorId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({
          'vendorEmail': vendorEmail,
          'vendorName': vendorName,
          'imageUrl': imageUrl,
          'videoUrl': videoUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.set({
          'vendorId': vendorId,
          'vendorEmail': vendorEmail,
          'vendorName': vendorName,
          'imageUrl': imageUrl,
          'videoUrl': videoUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      Get.snackbar('Success', 'Story added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add story: $e');
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (story.value?.video != null) {
        story.value = Story(image: image, video: story.value!.video);
      } else {
        story.value = Story(image: image);
      }
      await addStoryToFirestore(story.value?.image, story.value?.video);
    }
  }

  Future<void> captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (story.value?.video != null) {
        story.value = Story(image: image, video: story.value!.video);
      } else {
        story.value = Story(image: image);
      }
      await addStoryToFirestore(story.value?.image, story.value?.video);
    }
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 30));
    if (video != null) {
      if (story.value?.image != null) {
        story.value = Story(image: story.value!.image, video: video);
      } else {
        story.value = Story(video: video);
      }
      await _initializeVideoController(video.path);
      await addStoryToFirestore(story.value?.image, story.value?.video);
    }
  }

  Future<void> captureVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
    if (video != null) {
      if (story.value?.image != null) {
        story.value = Story(image: story.value!.image, video: video);
      } else {
        story.value = Story(video: video);
      }
      await _initializeVideoController(video.path);
      await addStoryToFirestore(story.value?.image, story.value?.video);
    }
  }

  Future<void> _initializeVideoController(String path) async {
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    controller.setLooping(true);
    videoControllers[path] = controller;
    update();
  }

  Future<void> deleteMedia(bool isVideo) async {
    final vendorId = Get.find<ProfileController>().profileModel?.id?.toString();

    if (vendorId == null) {
      Get.snackbar('Error', 'Vendor ID is null');
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('stories').doc(vendorId);

      if (isVideo) {
        story.value = Story(image: story.value?.image, video: null);
        await docRef.update({
          'videoUrl': FieldValue.delete(),
        });
        final videoPath = story.value?.video?.path;
        if (videoPath != null) {
          videoControllers[videoPath]?.dispose();
          videoControllers.remove(videoPath);
        }
      } else {
        story.value = Story(image: null, video: story.value?.video);
        await docRef.update({
          'imageUrl': FieldValue.delete(),
        });
      }

      Get.snackbar('Success', 'Media deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete media: $e');
    }
  }

  @override
  void dispose() {
    for (var controller in videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
