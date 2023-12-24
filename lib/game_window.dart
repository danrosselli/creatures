import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:console/console.dart';
import 'package:console/curses.dart';
import 'worm.dart';

class GameWindow extends Window {
  Timer? timer;
  List<Worm> worms = [];

  // constructor
  GameWindow() : super('Creatures');

  // game loop
  @override
  void draw() {
    super.draw();
    //creature.draw(row: row, column: col);
    for (var worm in worms) {
      worm.run();

      // change direction randomically
      if (Random().nextInt(2) == 0) {
        worm.turnClockwise();
      } else {
        worm.turnCounterClockwise();
      }
    }
  }

  @override
  void initialize() {
    // quit game
    Keyboard.bindKeys(['q', 'Q']).listen((_) {
      close();
      Console.resetAll();
      Console.eraseDisplay();
      Console.showCursor();
      exit(0);
    });

    Keyboard.bindKey('down').listen((_) {
      //if (row < Console.rows - 1) row += 1;
    });

    Keyboard.bindKey('up').listen((_) {
      //if (row > 2) row -= 1;
    });

    Keyboard.bindKey('left').listen((_) {
      worms[0].turnCounterClockwise();
    });

    Keyboard.bindKey('right').listen((_) {
      worms[0].turnClockwise();
    });

    Console.hideCursor();

    // create worms
    for (int i = 0; i < 10; i++) {
      worms.add(Worm());
    }

    // start loop
    timer = Timer.periodic(Duration(milliseconds: 100), (t) => draw());
  }
}
