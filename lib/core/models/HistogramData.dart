class HistogramData {
  final String x;
  final String y;
  final String name;

  HistogramData({required this.x, required this.y, required this.name});

  factory HistogramData.fromJSON(Map map) => HistogramData(
      x: '${map['x'] ?? 0}',
      y: '${map['y'] ?? 0}',
      name: '${map['name'] ?? ''}');

  toJSON() => {"x": x, "y": y, 'name': name};
}