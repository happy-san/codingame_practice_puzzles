import 'dart:io';

void main() {
  // Map of <EXT, MT>
  var map = <String, String>{};
  String EXT; // file extension
  String MT; // MIME type

  List inputs;
  var N = int.parse(stdin
      .readLineSync()); // Number of elements which make up the association table.
  var Q =
      int.parse(stdin.readLineSync()); // Number Q of file names to be analyzed.
  for (var i = 0; i < N; i++) {
    inputs = stdin.readLineSync().split(' ');
    EXT = inputs[0];
    MT = inputs[1];
    map[EXT.toLowerCase()] = MT;
  }
  for (var i = 0; i < Q; i++) {
    var FNAME = stdin.readLineSync(); // One file name per line.

    // List separated by '.'
    var list = FNAME.contains('.') ? FNAME.split('.').toList() : null;
    // Last element of [list] is file extension.
    if (map.containsKey(list?.last?.toLowerCase())) {
      print(map[list.last.toLowerCase()]);
    } else {
      print('UNKNOWN');
    }
  }
}
