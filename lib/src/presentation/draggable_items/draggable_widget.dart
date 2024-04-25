// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
// import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:vs_story_designer/src/domain/models/editable_items.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/control_provider.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/gradient_notifier.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/font_family.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/item_type.dart';
// import 'package:vs_story_designer/src/presentation/utils/constants/text_animation_type.dart';
import 'package:vs_story_designer/src/presentation/widgets/animated_onTap_button.dart';
import 'package:vs_story_designer/src/presentation/widgets/file_image_bg.dart';

class DraggableWidget extends StatefulWidget {
  final EditableItem draggableWidget;
  final Function(PointerDownEvent)? onPointerDown;
  final Function(PointerUpEvent)? onPointerUp;
  final Function(PointerMoveEvent)? onPointerMove;
  final BuildContext context;
  final String? mediaPath;
  const DraggableWidget(
      {super.key,
      required this.context,
      required this.draggableWidget,
      this.onPointerDown,
      this.onPointerUp,
      this.onPointerMove,
      this.mediaPath});

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;
  Future<void>? _future;

  Future<void> initVideoPlayer() async {
    await _videoPlayerController?.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController?.value.aspectRatio,
        showControls: false,
        allowFullScreen: false,
        allowMuting: false,
        allowPlaybackSpeedChanging: false,
        autoPlay: false,
        looping: false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    String? path;
    if (widget.mediaPath != null) {
      path = widget.mediaPath;
    } else {
      var _controlProvider =
          Provider.of<ControlNotifier>(context, listen: false);
      path = _controlProvider.mediaPath;
    }

    if (isVideoPath(path ?? "")) {
      if ((path?.isNotEmpty ?? false) && _chewieController == null) {
        _videoPlayerController =
            VideoPlayerController.file(File.fromUri(Uri.parse(path!)));
        _future = initVideoPlayer();
      }
    }
  }

  bool isVideoPath(String path) {
    debugPrint(path);
    return path.toLowerCase().contains(".mp4") ||
        path.contains(".mkv") ||
        path.contains(".avi");
  }

  @override
  void didUpdateWidget(covariant DraggableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    var _controlProvider = Provider.of<ControlNotifier>(context, listen: false);
    String? path = _controlProvider.mediaPath;
    if (isVideoPath(path)) {
      if (_controlProvider.mediaPath.isNotEmpty && _chewieController == null) {
        VideoPlayerController videoPlayerController =
            VideoPlayerController.file(
                File.fromUri(Uri.parse(_controlProvider.mediaPath)));
        videoPlayerController.initialize().then((value) {
          _chewieController = ChewieController(
              videoPlayerController: videoPlayerController,
              aspectRatio: videoPlayerController.value.aspectRatio,
              showControls: false,
              autoInitialize: false,
              autoPlay: true);
        });
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _colorProvider = Provider.of<GradientNotifier>(context, listen: false);
    var _controlProvider = Provider.of<ControlNotifier>(context, listen: false);
    Widget? overlayWidget;

    switch (widget.draggableWidget.type) {
      case ItemType.text:
        overlayWidget = IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 50,
                minWidth: 50,
                maxWidth: _size.width - 120,
              ),
              width: widget.draggableWidget.deletePosition ? 100 : null,
              height: widget.draggableWidget.deletePosition ? 100 : null,
              child: AnimatedOnTapButton(
                onTap: () =>
                    _onTap(context, widget.draggableWidget, _controlProvider),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: _text(
                          background: true,
                          paintingStyle: PaintingStyle.fill,
                          controlNotifier: _controlProvider),
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: Center(
                        child: _text(
                            background: true,
                            paintingStyle: PaintingStyle.stroke,
                            controlNotifier: _controlProvider),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0, top: 0),
                      child: Stack(
                        children: [
                          Center(
                            child: _text(
                                paintingStyle: PaintingStyle.fill,
                                controlNotifier: _controlProvider),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        break;

      /// image [file_image_gb.dart]
      case ItemType.image:
        if (_controlProvider.mediaPath.isNotEmpty) {
          overlayWidget = SizedBox(
            width: _size.width,
            child: FileImageBG(
              filePath: File(_controlProvider.mediaPath),
              generatedGradient: (color1, color2) {
                _colorProvider.color1 = color1;
                _colorProvider.color2 = color2;
              },
            ),
          );
        } else {
          overlayWidget = Container();
        }

        break;

      case ItemType.gif:
        overlayWidget = SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// create Gif widget
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  // child: GiphyRenderImage.original(gif: draggableWidget.gif),
                ),
              ),
            ],
          ),
        );
        break;

      case ItemType.video:
        if (_chewieController != null) {
          overlayWidget = ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: _size.width,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    return AspectRatio(
                      aspectRatio: _chewieController!
                          .videoPlayerController.value.aspectRatio,
                      child: IgnorePointer(
                        child: Chewie(
                          controller: _chewieController!,
                        ),
                      ),
                    );
                  }),
            ),
          );
        } else {
          overlayWidget = Container();
        }
    }

    /// set widget data position on main screen
    return AnimatedAlignPositioned(
      duration: const Duration(milliseconds: 50),
      dy: (widget.draggableWidget.deletePosition
          ? _deleteTopOffset(_size)
          : (widget.draggableWidget.position.dy * _size.height)),
      dx: (widget.draggableWidget.deletePosition
          ? 0
          : (widget.draggableWidget.position.dx * _size.width)),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: widget.draggableWidget.deletePosition
            ? _deleteScale()
            : widget.draggableWidget.scale,
        child: Transform.rotate(
          angle: widget.draggableWidget.rotation,
          child: Listener(
            onPointerDown: widget.onPointerDown,
            onPointerUp: widget.onPointerUp,
            onPointerMove: widget.onPointerMove,

            /// show widget
            child: overlayWidget,
          ),
        ),
      ),
    );
  }

  /// text widget
  Widget _text(
      {required ControlNotifier controlNotifier,
      required PaintingStyle paintingStyle,
      bool background = false}) {
    // if (draggableWidget.animationType == TextAnimationType.none) {
    return Text(widget.draggableWidget.text,
        textAlign: widget.draggableWidget.textAlign,
        style: _textStyle(
            controlNotifier: controlNotifier,
            paintingStyle: paintingStyle,
            background: background));
    // }
    //  else {
    // return DefaultTextStyle(
    //   style: _textStyle(
    //       controlNotifier: controlNotifier,
    //       paintingStyle: paintingStyle,
    //       background: background),
    //   child: AnimatedTextKit(
    //     repeatForever: true,
    //     onTap: () => _onTap(context, draggableWidget, controlNotifier),
    //     animatedTexts: [
    //       if (draggableWidget.animationType == TextAnimationType.scale)
    //         ScaleAnimatedText(draggableWidget.text,
    //             duration: const Duration(milliseconds: 1200)),
    //       if (draggableWidget.animationType == TextAnimationType.fade)
    //         ...draggableWidget.textList.map((item) => FadeAnimatedText(item,
    //             duration: const Duration(milliseconds: 1200))),
    //       if (draggableWidget.animationType == TextAnimationType.typer)
    //         TyperAnimatedText(draggableWidget.text,
    //             speed: const Duration(milliseconds: 500)),
    //       if (draggableWidget.animationType == TextAnimationType.typeWriter)
    //         TypewriterAnimatedText(
    //           draggableWidget.text,
    //           speed: const Duration(milliseconds: 500),
    //         ),
    //       if (draggableWidget.animationType == TextAnimationType.wavy)
    //         WavyAnimatedText(
    //           draggableWidget.text,
    //           speed: const Duration(milliseconds: 500),
    //         ),
    //       if (draggableWidget.animationType == TextAnimationType.flicker)
    //         FlickerAnimatedText(
    //           draggableWidget.text,
    //           speed: const Duration(milliseconds: 1200),
    //         ),
    //     ],
    //   ),
    // );
    // }
  }

  _textStyle(
      {required ControlNotifier controlNotifier,
      required PaintingStyle paintingStyle,
      bool background = false}) {
    return AppFonts.getTextThemeENUM(
            controlNotifier.fontList![widget.draggableWidget.fontFamily])
        .bodyLarge!
        .merge(
          TextStyle(
            // fontFamily: controlNotifier.fontList![draggableWidget.fontFamily],
            // package: controlNotifier.isCustomFontList ? null : 'vs_story_designer',
            fontWeight: FontWeight.w500,
            shadows: !controlNotifier.enableTextShadow
                ? []
                : <Shadow>[
                    Shadow(
                        offset: const Offset(0, 0),
                        blurRadius: 3.0,
                        color: widget.draggableWidget.textColor == Colors.black
                            ? Colors.white54
                            : Colors.black)
                  ],
          ),
        )
        .copyWith(
            color: background ? Colors.black : widget.draggableWidget.textColor,
            fontSize: widget.draggableWidget.deletePosition
                ? 8
                : widget.draggableWidget.fontSize,
            background: Paint()
              ..strokeWidth = 20.0
              ..color = widget.draggableWidget.backGroundColor
              ..style = paintingStyle
              ..strokeJoin = StrokeJoin.round
              ..filterQuality = FilterQuality.high
              ..strokeCap = StrokeCap.round
              ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1));
  }

  _deleteTopOffset(size) {
    double top = 0.0;
    if (widget.draggableWidget.type == ItemType.text) {
      top = size.width / 1.3;
      return top;
    } else if (widget.draggableWidget.type == ItemType.gif) {
      top = size.width / 1.3;
      return top;
    }
  }

  _deleteScale() {
    double scale = 0.0;
    if (widget.draggableWidget.type == ItemType.text) {
      scale = 0.4;
      return scale;
    } else if (widget.draggableWidget.type == ItemType.gif) {
      scale = 0.3;
      return scale;
    }
  }

  /// onTap text
  void _onTap(BuildContext context, EditableItem item,
      ControlNotifier controlNotifier) {
    var _editorProvider =
        Provider.of<TextEditingNotifier>(this.widget.context, listen: false);
    var _itemProvider = Provider.of<DraggableWidgetNotifier>(
        this.widget.context,
        listen: false);

    /// load text attributes
    _editorProvider.textController.text = item.text.trim();
    _editorProvider.text = item.text.trim();
    _editorProvider.fontFamilyIndex = item.fontFamily;
    _editorProvider.textSize = item.fontSize;
    _editorProvider.backGroundColor = item.backGroundColor;
    _editorProvider.textAlign = item.textAlign;
    _editorProvider.textColor =
        controlNotifier.colorList!.indexOf(item.textColor);
    _editorProvider.animationType = item.animationType;
    _editorProvider.textList = item.textList;
    _editorProvider.fontAnimationIndex = item.fontAnimationIndex;
    _itemProvider.draggableWidget
        .removeAt(_itemProvider.draggableWidget.indexOf(item));
    _editorProvider.fontFamilyController = PageController(
      initialPage: item.fontFamily,
      viewportFraction: .1,
    );

    /// create new text item
    controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
  }

  @override
  void dispose() {
    _chewieController?.videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
