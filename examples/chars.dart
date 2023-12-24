import 'package:console/console.dart';

void main() {
  int page = 0;

  void draw() {
    int count = 0;
    int total = 120 * 30;
    int start = total * page;
    int end = total + (total * page);

    Console.eraseDisplay(1);
    for (int i = start; i < end; i++) {
      int column = count % 120;
      int row = count ~/ 120;

      Console.moveCursor(row: row, column: column);
      print(String.fromCharCode(i));
      count += 1;
    }
    int temp = 127995;
    print('page: $page, start: $start, end: $end | $temp');
  }

  Keyboard.bindKey(KeyCode.SPACE).listen((_) {
    page += 1;
    draw();
  });

  Keyboard.bindKey('s').listen((_) {
    print(
        '${String.fromCharCode(127995)}${String.fromCharCode(127996)}${String.fromCharCode(127997)}${String.fromCharCode(127999)}');
  });

  draw();
}
