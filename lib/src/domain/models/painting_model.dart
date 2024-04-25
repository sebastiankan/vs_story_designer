import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/painting_type.dart';

class PaintingModel {
  List<PointVector> points;
  double size;
  double thinning;
  double smoothing;
  bool isComplete;
  Color lineColor;
  double streamline;
  bool simulatePressure;
  PaintingType paintingType;

  PaintingModel(
    this.points,
    this.size,
    this.thinning,
    this.smoothing,
    this.isComplete,
    this.lineColor,
    this.streamline,
    this.simulatePressure,
    this.paintingType,
  );

  // Constructor from JSON
  PaintingModel.fromJson(Map<String, dynamic> json)
      : points = (json['points'] as List<dynamic>)
            .map((point) => PointVector(
                  point["x"],
                  point["y"],
                  point["pressure"],
                ))
            .toList(),
        size = json['size'],
        thinning = json['thinning'],
        smoothing = json['smoothing'],
        isComplete = json['isComplete'],
        lineColor = Color(json['lineColor']),
        streamline = json['streamline'],
        simulatePressure = json['simulatePressure'],
        paintingType = PaintingType.values[json['paintingType']];

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'points': points
          .map((point) =>
              {"x": point.x, "y": point.y, "pressure": point.pressure})
          .toList(),
      'size': size,
      'thinning': thinning,
      'smoothing': smoothing,
      'isComplete': isComplete,
      'lineColor': lineColor.value,
      'streamline': streamline,
      'simulatePressure': simulatePressure,
      'paintingType': paintingType.index,
    };
  }
}
