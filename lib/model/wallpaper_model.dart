class WallpaperModel {
  late String photographer;
  // ignore: non_constant_identifier_names
  late String photographer_url;
  // ignore: non_constant_identifier_names
  late int photographer_id;
  SrcModel src;

  WallpaperModel(
      {required this.photographer,
      // ignore: non_constant_identifier_names
      required this.photographer_id,
      // ignore: non_constant_identifier_names
      required this.photographer_url,
      required this.src});

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      src: SrcModel.fromMap(jsonData['src']),
      photographer: jsonData['photographer'],
      photographer_id: jsonData['photographer_id'],
      photographer_url: jsonData['photographer_url'],
    );
  }
}

class SrcModel {
  late String original;
  late String portrait;
  late String small;

  SrcModel(
      {required this.original, required this.portrait, required this.small});

  factory SrcModel.fromMap(Map<String, dynamic> srcJson) {
    return SrcModel(
      original: srcJson['original'],
      portrait: srcJson['portrait'],
      small: srcJson['small'],
    );
  }
}
