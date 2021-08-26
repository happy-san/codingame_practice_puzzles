import 'package:test/test.dart';
import 'package:codingame_practice_puzzles/easy/graffiti_on_the_fence/solution.dart';

void main() {
  group('Section', () {
    late Section section;

    setUp(() {
      section = Section(start: 6, end: 9);
    });

    test('has a start field', () {
      expect(section.start, equals(6));
    });
    test('has an end field', () {
      expect(section.end, equals(9));
    });
    test('has a contains method', () {
      expect(section.contains(Section(start: 6, end: 9)), isTrue);
      expect(section.contains(Section(start: 6, end: 7)), isTrue);
      expect(section.contains(Section(start: 8, end: 9)), isTrue);

      expect(section.contains(Section(start: 4, end: 9)), isFalse);
      expect(section.contains(Section(start: 6, end: 20)), isFalse);
      expect(section.contains(Section(start: 4, end: 20)), isFalse);
    });
    test('has an overlaps method', () {
      expect(section.overlaps(Section(start: 9, end: 10)), isTrue);
      expect(section.overlaps(Section(start: 3, end: 6)), isTrue);

      expect(section.overlaps(Section(start: 8, end: 10)), isTrue);
      expect(section.overlaps(Section(start: 3, end: 7)), isTrue);

      expect(section.overlaps(Section(start: 7, end: 8)), isTrue);

      expect(section.overlaps(Section(start: 10, end: 11)), isFalse);
      expect(section.overlaps(Section(start: 3, end: 5)), isFalse);
    });
    test('has a tryMerge method', () {
      final mergedSection = section.tryMerge(Section(start: 5, end: 7));

      expect(mergedSection.start, equals(5));
      expect(mergedSection.end, equals(9));
    });
    test('has a compareTo method', () {
      expect(section.compareTo(Section(start: 7, end: 8)), 0);
      expect(section.compareTo(Section(start: 6, end: 9)), 0);

      expect(section.compareTo(Section(start: 3, end: 4)), 1);

      expect(section.compareTo(Section(start: 10, end: 11)), -1);
    });

    test('tryMerge method throws if sections not mergeable', () {
      expect(() {
        section.tryMerge(Section(start: 0, end: 1));
      }, throwsArgumentError);
      expect(() {
        section.tryMerge(Section(start: 10, end: 11));
      }, throwsArgumentError);
    });
  });

  group('compileReports function', () {
    test('adds reported section to the previous compiled list', () {
      expect(
          compileReports([], Section(start: 6, end: 9)),
          orderedEquals(
            [Section(start: 6, end: 9)],
          ));
      expect(
          compileReports(
              [Section(start: 6, end: 9)], Section(start: 0, end: 1)),
          orderedEquals(
            [Section(start: 0, end: 1), Section(start: 6, end: 9)],
          ));
      expect(
          compileReports(
              [Section(start: 6, end: 9)], Section(start: 10, end: 11)),
          orderedEquals(
            [Section(start: 6, end: 9), Section(start: 10, end: 11)],
          ));
    });
    test('merges the overlapping reported sections', () {
      expect(
          compileReports(
              [Section(start: 6, end: 9)], Section(start: 9, end: 11)),
          orderedEquals(
            [Section(start: 6, end: 11)],
          ));
      expect(
          compileReports([
            Section(start: 3, end: 5),
            Section(start: 6, end: 9),
            Section(start: 10, end: 11),
          ], Section(start: 6, end: 11)),
          orderedEquals(
            [Section(start: 3, end: 5), Section(start: 6, end: 11)],
          ));
      expect(
          compileReports([
            Section(start: 6, end: 7),
            Section(start: 8, end: 9),
            Section(start: 10, end: 11),
          ], Section(start: 7, end: 10)),
          orderedEquals(
            [Section(start: 6, end: 11)],
          ));
      expect(
          compileReports([
            Section(start: 6, end: 7),
            Section(start: 8, end: 9),
            Section(start: 10, end: 11),
          ], Section(start: 1, end: 20)),
          orderedEquals(
            [Section(start: 1, end: 20)],
          ));
    });
  });

  test(
      'getInsertionIndex function returns the index around where a report should be inserted',
      () {
    expect(getInsertionIndex([], Section(start: 6, end: 9)), equals(0));
    expect(
        getInsertionIndex(
            [Section(start: 6, end: 9)], Section(start: 0, end: 1)),
        equals(0));
    expect(
        getInsertionIndex([
          Section(start: 0, end: 1),
          Section(start: 6, end: 9),
          Section(start: 15, end: 16),
        ], Section(start: 10, end: 11)),
        equals(1));
  });

  test('unpaintedSections function returns list of unpainted Sections', () {
    expect(unpaintedSections(10, []), equals([Section(start: 0, end: 10)]));
    expect(unpaintedSections(10, [Section(start: 1, end: 5)]),
        orderedEquals([Section(start: 0, end: 1), Section(start: 5, end: 10)]));
    expect(
        unpaintedSections(
            10, [Section(start: 1, end: 5), Section(start: 6, end: 9)]),
        orderedEquals([
          Section(start: 0, end: 1),
          Section(start: 5, end: 6),
          Section(start: 9, end: 10)
        ]));

    expect(unpaintedSections(10, [Section(start: 0, end: 10)]), equals([]));
  });
}
