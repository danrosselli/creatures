import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:console/console.dart';
import 'package:console/curses.dart';

class GameWindow extends Window {
  Timer? timer;
  List<Creature> creatures = [];

  // constructor
  GameWindow() : super('Creatures');

  @override
  void draw() {
    super.draw();
    //creature.draw(row: row, column: col);
    for (var creature in creatures) {
      creature.run();

      // change direction randomically
      if (Random().nextInt(2) == 0) {
        creature.turnClockwise();
      } else {
        creature.turnCounterClockwise();
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
      creatures[0].turnCounterClockwise();
    });

    Keyboard.bindKey('right').listen((_) {
      creatures[0].turnClockwise();
    });

    Console.hideCursor();

    // create creatures
    for (int i = 0; i < 10; i++) {
      creatures.add(Creature());
    }

    // start loop
    timer = Timer.periodic(Duration(milliseconds: 100), (t) => draw());
  }
}

class Creature {
  int row = Console.rows ~/ 2;
  int column = Console.columns ~/ 2;

  final List<int> _row = [];
  final List<int> _column = [];
  /*
         0
       7   1
      6  +  2
       5   3
         4      
  */
  int direction = Random().nextInt(8); // start random direction

  var pen1 = TextPen();
  var pen2 = TextPen();
  var pen3 = TextPen();

  Creature() {
    pen1.white();
    pen1.text('0');
    pen2.lightGray();
    pen2.text('O');
    pen3.gray();
    pen3.text('O');
    _row.add(row);
    _column.add(column);
  }

  draw() {
    if (row != _row[0] || column != _column[0]) {
      _row.insert(0, row);
      if (_row.length > 3) _row.removeLast();
      _column.insert(0, column);
      if (_column.length > 3) _column.removeLast();
    }

    // head
    Console.moveCursor(row: _row[0], column: _column[0]);
    pen1.print();

    // body
    if (_row.length > 1 && _column.length > 1) {
      Console.moveCursor(row: _row[1], column: _column[1]);
      pen2.print();
    }

    // tail
    if (_row.length > 2 && _column.length > 2) {
      Console.moveCursor(row: _row[2], column: _column[2]);
      pen3.print();
    }
  }

  run() {
    avoidObstacle();
    switch (direction) {
      case 0:
        row -= 1;
        break;
      case 1:
        row -= 1;
        column += 1;
        break;
      case 2:
        column += 1;
        break;
      case 3:
        row += 1;
        column += 1;
        break;
      case 4:
        row += 1;
        break;
      case 5:
        row += 1;
        column -= 1;
        break;
      case 6:
        column -= 1;
        break;
      case 7:
        row -= 1;
        column -= 1;
        break;
    }
    draw();
  }

  turnClockwise() {
    if (direction == 7) {
      direction = 0;
    } else {
      direction += 1;
    }
  }

  turnCounterClockwise() {
    if (direction == 0) {
      direction = 7;
    } else {
      direction -= 1;
    }
  }

  avoidObstacle() {
    if (row == 2) {
      if (direction == 0) direction = 4;
      if (direction == 1) direction = 3;
      if (direction == 7) direction = 5;
    }
    if (row == Console.rows - 1) {
      if (direction == 4) direction = 0;
      if (direction == 3) direction = 1;
      if (direction == 5) direction = 7;
    }
    if (column == 1) {
      if (direction == 6) direction = 2;
      if (direction == 7) direction = 1;
      if (direction == 5) direction = 3;
    }
    if (column == Console.columns) {
      if (direction == 2) direction = 6;
      if (direction == 1) direction = 7;
      if (direction == 3) direction = 5;
    }
  }
}

void main() {
  var window = GameWindow();
  window.display();
}
