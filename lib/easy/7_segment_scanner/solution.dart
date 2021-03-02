import 'dart:io';

const map = const <String, String>{
  '''
 _ 
| |
|_|
''': '0',
  '''
   
  |
  |
''': '1',
  '''
 _ 
 _|
|_ 
''': '2',
  '''
 _ 
 _|
 _|
''': '3',
  '''
   
|_|
  |
''': '4',
  '''
 _ 
|_ 
 _|
''': '5',
  '''
 _ 
|_ 
|_|
''': '6',
  '''
 _ 
  |
  |
''': '7',
  '''
 _ 
|_|
|_|
''': '8',
  '''
 _ 
|_|
 _|
''': '9',
};

void main() {
  final line1 = stdin.readLineSync(),
      line2 = stdin.readLineSync(),
      line3 = stdin.readLineSync();

  var number = '';

  for (var i = 0; i < line1.length; i += 3) {
    number += map['''
${line1.substring(i, i + 3)}
${line2.substring(i, i + 3)}
${line3.substring(i, i + 3)}
'''];
  }

  print(number);
}
