import 'dart:io';
import 'package:console/console.dart';

void main() {
  Keyboard.init();
  Console.init();

  Keyboard.bindKey('q').listen((_) {
    print('quit');
    exit(0);
  });

  Keyboard.bindKey('down').listen((_) {
    print('Down.');
  });

  print('o');
}
