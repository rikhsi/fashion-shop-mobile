class BodyMeasurementsModel {
  final double? height;       // cm
  final double? weight;       // kg
  final double? chest;        // cm
  final double? waist;        // cm
  final double? hips;         // cm
  final double? shoulderWidth; // cm
  final double? armLength;    // cm
  final double? legLength;    // cm
  final double? neckCirc;     // cm
  final String? notes;

  const BodyMeasurementsModel({
    this.height,
    this.weight,
    this.chest,
    this.waist,
    this.hips,
    this.shoulderWidth,
    this.armLength,
    this.legLength,
    this.neckCirc,
    this.notes,
  });

  bool get isEmpty =>
      height == null &&
      weight == null &&
      chest == null &&
      waist == null &&
      hips == null &&
      shoulderWidth == null;

  BodyMeasurementsModel copyWith({
    double? height,
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? shoulderWidth,
    double? armLength,
    double? legLength,
    double? neckCirc,
    String? notes,
  }) {
    return BodyMeasurementsModel(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      shoulderWidth: shoulderWidth ?? this.shoulderWidth,
      armLength: armLength ?? this.armLength,
      legLength: legLength ?? this.legLength,
      neckCirc: neckCirc ?? this.neckCirc,
      notes: notes ?? this.notes,
    );
  }
}
