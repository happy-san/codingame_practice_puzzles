import 'dart:io';
import 'dart:math';

class Section {
  final int start;
  final int end;

  const Section({required this.start, required this.end});

  Section expand({int? start, int? end}) => Section(
        start: start == null ? this.start : min(start, this.start),
        end: end == null ? this.end : max(end, this.end),
      );

  bool contains(Section other) => start <= other.start && end >= other.end;

  bool overlaps(Section other) => start <= other.end && end >= other.start;

  Section tryMerge(Section other) => contains(other)
      ? this
      : overlaps(other)
          ? Section(start: min(start, other.start), end: max(end, other.end))
          : throw ArgumentError();

  /// Compares this Section object to [other], returning zero if the sections
  /// overlap.
  ///
  /// Returns a negative value if this Section is to left of [other] and returns
  /// a positive value otherwise (when this is to right of [other]).
  int compareTo(Section other) {
    if (overlaps(other)) {
      return 0;
    }

    if (end < other.start) {
      return -1;
    } else {
      return 1;
    }
  }

  @override
  bool operator ==(other) =>
      identical(this, other) || other is Section && contains(other);

  @override
  String toString() => '($start, $end)';
}

int getInsertionIndex(List<Section> reports, Section report) {
  var start = 0, end = reports.length - 1, mid = (start + end) ~/ 2;
  while (start <= end) {
    switch (report.compareTo(reports[mid])) {
      // Overlap
      case 0:
        return mid;

      // Discard right half
      case -1:
        end = mid - 1;
        break;

      // Discard left half
      case 1:
        start = mid + 1;
        break;
    }

    mid = (start + end) ~/ 2;
  }

  return mid;
}

List<Section> compileReports(List<Section> reports, Section report) {
  if (reports.isEmpty) {
    return reports..add(report);
  }

  final insertionIndex = getInsertionIndex(reports, report);
  Section merged;
  try {
    merged = report.tryMerge(reports[insertionIndex]);
  } on ArgumentError {
    return reports
      ..insert(
          (report.compareTo(reports[insertionIndex]) < 0)
              ? insertionIndex
              : insertionIndex + 1,
          report);
  }

  final left = _mergeNeighbours(reports, merged, insertionIndex);
  final right = _mergeNeighbours(reports, merged, insertionIndex, false);

  if (left == right) {
    reports.removeAt(left);
  } else {
    reports.removeRange(left, right + 1);
  }

  return reports..insert(left, merged);
}

int _mergeNeighbours(List<Section> reports, Section merged, int startingIndex,
    [bool mergeToLeft = true]) {
  var i = startingIndex;
  while (true) {
    try {
      merged = merged.tryMerge(reports[mergeToLeft ? i - 1 : i + 1]);
      mergeToLeft ? i-- : i++;
    } catch (e) {
      if (e is ArgumentError || e is RangeError) {
        break;
      } else {
        rethrow;
      }
    }
  }
  return i;
}

List<Section> unpaintedSections(
    int fenceLength, List<Section> paintedSections) {
  if (paintedSections.isEmpty) {
    return [Section(start: 0, end: fenceLength)];
  }

  var unpainted = <Section>[];
  if (paintedSections.first.start != 0) {
    unpainted.add(Section(start: 0, end: paintedSections.first.start));
  }
  for (var i = 0; i < paintedSections.length - 1; i++) {
    unpainted.add(Section(
        start: paintedSections[i].end, end: paintedSections[i + 1].start));
  }
  if (paintedSections.last.end != fenceLength) {
    unpainted.add(Section(start: paintedSections.last.end, end: fenceLength));
  }

  return unpainted;
}

String readLineSync() => stdin.readLineSync() ?? '';

void main() {
  final L = int.parse(readLineSync()), N = int.parse(readLineSync());

  var paintedSections = <Section>[];
  for (var i = 0; i < N; i++) {
    final input = readLineSync().split(' ').map((i) => int.parse(i));

    paintedSections = compileReports(
        paintedSections, Section(start: input.first, end: input.last));
  }
  stderr.writeln('Painted Sections: $paintedSections');

  final unpainted = unpaintedSections(L, paintedSections);
  if (unpainted.isEmpty) {
    print('All painted');
  } else {
    unpainted
        .map((section) => '${section.start} ${section.end}')
        .forEach(print);
  }
}
