import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:video_player/video_player.dart';
import '../profile/controllers/profile_controller.dart';
import 'story_controller.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StoryController controller = Get.put(StoryController());

    return Scaffold(
      appBar: AppBar(
        title: Text('story'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final story = controller.story.value;
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (story?.imageUrl != null)
                        Card(
                          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                          child: Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 300, // Increased height for image
                                  maxWidth: double.infinity,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(story!.imageUrl!),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.deleteMedia(false),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (story?.videoUrl != null)
                        Card(
                          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                          child: Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 300, // Increased height for video
                                  maxWidth: double.infinity,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9, // Maintain aspect ratio for video
                                  child: controller.videoControllers[story!.videoUrl!] != null
                                      ? VideoPlayer(controller.videoControllers[story.videoUrl!]!)
                                      : const Center(child: CircularProgressIndicator()),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.deleteMedia(true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (story == null || (story.imageUrl == null && story.videoUrl == null))
                        const Center(child: Text('No media available')),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Text(
              'Here you can manage and view your story'.tr,
              style: TextStyle(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.pickImage(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  ),
                  child: Text('Add Image Story'.tr),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                ElevatedButton(
                  onPressed: () => controller.captureImage(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  ),
                  child: Text('Capture Image Story'.tr),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.pickVideo(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  ),
                  child: Text('Add Video Story'.tr),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                ElevatedButton(
                  onPressed: () => controller.captureVideo(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  ),
                  child: Text('Capture Video Story'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
