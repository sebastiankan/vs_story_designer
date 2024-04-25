import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/colors.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/font_family.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/gradients.dart';
import 'package:vs_story_designer/vs_story_designer.dart';

class ControlNotifier extends ChangeNotifier {
  String _giphyKey = '';
  String get giphyKey => _giphyKey;
  set giphyKey(String key) {
    _giphyKey = key;
    notifyListeners();
  }

  String get folderName => _folderName;
  set folderName(String key) {
    _folderName = key;
    notifyListeners();
  }

  ThemeType? _themeType;
  ThemeType get themeType => _themeType!;
  set themeType(ThemeType key) {
    _themeType = key;
    notifyListeners();
  }

  String _folderName = "";

  int _gradientIndex = Random().nextInt(50);
  int get gradientIndex => _gradientIndex;
  set gradientIndex(int index) {
    _gradientIndex = index;
    notifyListeners();
  }

  bool _isTextEditing = false;
  bool get isTextEditing => _isTextEditing;
  set isTextEditing(bool val) {
    _isTextEditing = val;
    notifyListeners();
  }

  bool _isPainting = false;
  bool get isPainting => _isPainting;
  set isPainting(bool painting) {
    _isPainting = painting;
    notifyListeners();
  }

  List<FontType>? _fontList = AppFonts.fontFamilyListENUM;
  List<FontType>? get fontList => _fontList;
  set fontList(List<FontType>? fonts) {
    _fontList = fonts;
    notifyListeners();
  }

  bool _isCustomFontList = false;
  bool get isCustomFontList => _isCustomFontList;
  set isCustomFontList(bool key) {
    _isCustomFontList = key;
    notifyListeners();
  }

  List<List<Color>>? _gradientColors = gradientBackgroundColors;
  List<List<Color>>? get gradientColors => _gradientColors;
  set gradientColors(List<List<Color>>? color) {
    _gradientColors = color;
    notifyListeners();
  }

  Widget? _middleBottomWidget;
  Widget? get middleBottomWidget => _middleBottomWidget;
  set middleBottomWidget(Widget? widget) {
    _middleBottomWidget = widget;
    notifyListeners();
  }

  Future<bool>? _exitDialogWidget;
  Future<bool>? get exitDialogWidget => _exitDialogWidget;
  set exitDialogWidget(Future<bool>? widget) {
    _exitDialogWidget = widget;
    notifyListeners();
  }

  List<Color>? _colorList = defaultColors;
  List<Color>? get colorList => _colorList;
  set colorList(List<Color>? value) {
    _colorList = value;
    notifyListeners();
  }

  String _mediaPath = '';
  String get mediaPath => _mediaPath;
  set mediaPath(String media) {
    _mediaPath = media;
    notifyListeners();
  }

  bool _isPhotoFilter = false;
  bool get isPhotoFilter => _isPhotoFilter;
  set isPhotoFilter(bool filter) {
    _isPhotoFilter = filter;
    notifyListeners();
  }

  bool _isRenderingWidget = false;
  bool get isRenderingWidget => _isRenderingWidget;
  set isRenderingWidget(bool rendering) {
    _isRenderingWidget = rendering;
    notifyListeners();
  }

  bool _enableTextShadow = true;
  bool get enableTextShadow => _enableTextShadow;
  set enableTextShadow(bool filter) {
    _enableTextShadow = filter;
    notifyListeners();
  }

  ControlNotifier() {}

  // fromJson constructor
  ControlNotifier.fromJson(Map<String, dynamic> json) {
    _giphyKey = json['giphyKey'] ?? '';
    _folderName = json['folderName'] ?? '';
    _themeType = _parseThemeType(json['themeType']);
    _gradientIndex = json['gradientIndex'] ?? Random().nextInt(50);
    _isTextEditing = json['isTextEditing'] ?? false;
    _isPainting = json['isPainting'] ?? false;
    _fontList = _parseFontList(json['fontList']);
    _isCustomFontList = json['isCustomFontList'] ?? false;
    _gradientColors = _parseGradientColors(json['gradientColors']);
    _mediaPath = json['mediaPath'];
    // Add other fields as needed
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'mediaPath': _mediaPath,
      'gradientColor':
          _gradientColors?[_gradientIndex].map((color) => color.value).toList()
      // Add other fields as needed
    };
  }

  // Helper method to parse ThemeType enum from int value
  ThemeType _parseThemeType(int? index) {
    return index != null
        ? ThemeType.values[index]
        : ThemeType.light; // Set a default value if needed
  }

// Helper method to parse FontType enum list from List<int> value
  List<FontType>? _parseFontList(List<int>? indices) {
    return indices?.map((index) => FontType.values[index]).toList();
  }

  // Helper method to parse gradient colors list from List<List<int>> value
  List<List<Color>>? _parseGradientColors(List<List<int>>? colorValues) {
    return colorValues
        ?.map(
            (colors) => colors.map((colorValue) => Color(colorValue)).toList())
        .toList();
  }
}
