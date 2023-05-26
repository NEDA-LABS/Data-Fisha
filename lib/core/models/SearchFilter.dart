class SearchFilter {
  final String name;
  final Function() onClick;
  final bool selected;
  // final dynamic Function(dynamic) onFilter;

  SearchFilter({
    required this.name,
    required this.onClick,
    // required this.onFilter,
    required this.selected,
  });
}
