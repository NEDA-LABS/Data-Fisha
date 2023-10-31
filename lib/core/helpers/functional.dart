// [(a->b),(c->d)] -> a -> d
Future Function(dynamic x) composeAsync(List<Function> fns) => (initialX) async {
  var currentX = initialX;
  final reversed = fns.reversed.toList();
  for (Function fn in reversed) {
    currentX = await fn(currentX);
  }
  return currentX;
};