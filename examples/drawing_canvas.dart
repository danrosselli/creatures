import 'dart:math';
import 'dart:io';
import 'package:console/console.dart';

void main() {
  var canvas = DrawingCanvas(120, 120);
  Keyboard.init();

  Keyboard.bindKey('up').listen((_) {
    print('Up.');
  });

  int x = 0;
  int y = 0;

  void draw() {
    canvas.set(x, y);

    x += Random().nextInt(3) - 1;
    y += Random().nextInt(3) - 1;
    if (x > canvas.width || x < 0) x = 0;
    if (y > canvas.height || y < 0) y = 0;

    print(canvas.frame());

    //Console.moveCursor(row: x, column: y);
    //print('o');
  }

  void clear() {
    Console.eraseDisplay(1);
    canvas.clear();
  }

  bool exit = false;
  Keyboard.bindKey(KeyCode.SPACE).listen((k) {
    exit = true;
  });

  while (!exit) {
    clear();
    draw();
    sleep(const Duration(milliseconds: 106));
  }
}
