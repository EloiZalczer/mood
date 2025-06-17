class YearMonth {
  final int year;
  final int month;

  const YearMonth({required this.year, required this.month});

  @override
  bool operator ==(Object other) {
    return other is YearMonth && other.year == year && other.month == month;
  }

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() {
    return "YearMonth($year-$month)";
  }
}
