import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/item_type.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/text_animation_type.dart';
import 'package:chewie/chewie.dart';
import 'package:vs_story_designer/src/presentation/widgets/animated_onTap_button.dart';
import 'package:video_player/video_player.dart';

class EditableItem {
  bool deletePosition = false;
  Offset position = const Offset(0.0, 0.0);
  double scale = 1;
  double rotation = 0;
  ItemType type = ItemType.text;
  String text = '';
  String? mediaPath;
  List<String> textList = [];
  Color textColor = Colors.transparent;
  TextAlign textAlign = TextAlign.center;
  double fontSize = 20;
  int fontFamily = 0;
  int fontAnimationIndex = 0;
  Color backGroundColor = Colors.transparent;
  TextAnimationType animationType = TextAnimationType.none;
  VideoPlayerController? videoPlayerController;

  EditableItem();

  createVideoController({String? url}) {
    String? path = url ?? mediaPath;
    if (path != null) {
      if (path.toLowerCase().contains(".mp4") ||
          path.toLowerCase().contains(".mkv") ||
          path.toLowerCase().contains(".avi")) {
        if ((path.isNotEmpty)) {
          if (path.contains('sfo3.')) {
            if ((path.startsWith('https') == false)) path = 'https://$path';
            videoPlayerController =
                VideoPlayerController.networkUrl(Uri.parse(path));
          } else {
            videoPlayerController =
                VideoPlayerController.file(File.fromUri(Uri.parse(path)));
          }
        }
      }
    }
  }

  EditableItem.fromJson(Map<String, dynamic> json) {
    deletePosition = json['deletePosition'] ?? false;
    position = Offset(
      json['position']['dx'] ?? 0.0,
      json['position']['dy'] ?? 0.0,
    );
    scale = json['scale'] ?? 1;
    rotation = json['rotation'] ?? 0;
    type = _parseItemType(json['type']);
    text = json['text'] ?? '';
    mediaPath = json['mediaPath'] ?? '';
    textList = List<String>.from(json['textList'] ?? []);
    textColor = _parseColor(json['textColor']);
    textAlign = _parseTextAlign(json['textAlign']);
    fontSize = json['fontSize'] ?? 20;
    fontFamily = json['fontFamily'] ?? 0;
    fontAnimationIndex = json['fontAnimationIndex'] ?? 0;
    backGroundColor = _parseColor(json['backGroundColor']);
    animationType = _parseTextAnimationType(json['animationType']);
  }

  Map<String, dynamic> toJson() {
    return {
      'deletePosition': deletePosition,
      'position': {'dx': position.dx, 'dy': position.dy},
      'scale': scale,
      'rotation': rotation,
      'type': type.name,
      'text': text,
      'mediaPath': mediaPath,
      'textList': textList,
      'textColor': textColor.value,
      'textAlign': textAlign.index,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'fontAnimationIndex': fontAnimationIndex,
      'backGroundColor': backGroundColor.value,
      'animationType': animationType.index,
    };
  }

  bool isVideoPath(String path) {
    return path.contains(".mp4") ||
        path.contains(".mkv") ||
        path.contains(".avi");
  }

  // Widget getWidget(
  //     {ChewieController? chewieController,
  //     required Size screenSize,
  //     required Function() onTap}) {
  //   switch (type) {
  //     case ItemType.text:
  //       return IntrinsicWidth(
  //         child: IntrinsicHeight(
  //           child: Container(
  //             constraints: BoxConstraints(
  //               minHeight: 50,
  //               minWidth: 50,
  //               maxWidth: screenSize.width - 120,
  //             ),
  //             width: deletePosition ? 100 : null,
  //             height: deletePosition ? 100 : null,
  //             child: AnimatedOnTapButton(
  //               onTap: () => onTap(),
  //               child: Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   Center(
  //                     child: _text(
  //                         background: true,
  //                         paintingStyle: PaintingStyle.fill,
  //                         controlNotifier: _controlProvider),
  //                   ),
  //                   IgnorePointer(
  //                     ignoring: true,
  //                     child: Center(
  //                       child: _text(
  //                           background: true,
  //                           paintingStyle: PaintingStyle.stroke,
  //                           controlNotifier: _controlProvider),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(right: 0, top: 0),
  //                     child: Stack(
  //                       children: [
  //                         Center(
  //                           child: _text(
  //                               paintingStyle: PaintingStyle.fill,
  //                               controlNotifier: _controlProvider),
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //       break;

  //     /// image [file_image_gb.dart]
  //     case ItemType.image:
  //       if (mediaPath.isNotEmpty) {
  //         return SizedBox(
  //           width: _size.width - 72,
  //           child: FileImageBG(
  //             filePath: File(_controlProvider.mediaPath),
  //             generatedGradient: (color1, color2) {
  //               _colorProvider.color1 = color1;
  //               _colorProvider.color2 = color2;
  //             },
  //           ),
  //         );
  //       } else {
  //         return Container();
  //       }

  //       break;

  //     case ItemType.gif:
  //       return SizedBox(
  //         width: 150,
  //         height: 150,
  //         child: Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             /// create Gif widget
  //             Center(
  //               child: Container(
  //                 alignment: Alignment.center,
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Colors.transparent),
  //                 // child: GiphyRenderImage.original(gif: draggableWidget.gif),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //       break;

  //     case ItemType.video:
  //       if (_chewieController != null) {
  //         return ClipRRect(
  //           borderRadius: BorderRadius.circular(16),
  //           child: Container(
  //             // width: _size.width - 72,
  //             decoration:
  //                 BoxDecoration(borderRadius: BorderRadius.circular(16)),
  //             child: FutureBuilder(
  //                 future: _future,
  //                 builder: (context, snapshot) {
  //                   return AspectRatio(
  //                     aspectRatio: _chewieController!
  //                         .videoPlayerController.value.aspectRatio,
  //                     child: Chewie(
  //                       controller: _chewieController!,
  //                     ),
  //                   );
  //                 }),
  //           ),
  //         );
  //       } else {
  //         return Container();
  //       }
  //   }
  // }

  static Color _parseColor(int colorValue) {
    return Color(colorValue);
  }

  static TextAlign _parseTextAlign(int index) {
    return TextAlign.values[index];
  }

  static ItemType _parseItemType(String name) {
    switch (name) {
      case 'text':
        return ItemType.text;
      case 'image':
        return ItemType.image;
      case 'video':
        return ItemType.video;
      case 'gif':
        return ItemType.gif;
    }
    return ItemType.text;
  }

  static TextAnimationType _parseTextAnimationType(int index) {
    return TextAnimationType.values[index];
  }
}
