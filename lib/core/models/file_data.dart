class FileData {
  final List<int>? stream;
  final String? path;
  final String name;
  final double size;
  final String? extension;

  FileData({
    required this.stream,
    required this.extension,
    required this.size,
    required this.name,
    required this.path,
  });
}
