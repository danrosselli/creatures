import 'dart:io';
import 'dart:async';
//import 'dart:math';
import 'package:console/console.dart';
import 'package:console/curses.dart';
import 'package:neural/neural.dart';
import 'worm.dart';

class GameWindow extends Window {
  Timer? timer;
  List<Worm> worms = [];

  // Instantiate neural network
  Network neuralNetwork = Network(input: 20, hidden: [15], output: 2);

  // constructor
  GameWindow() : super('Creatures');

  // game loop
  @override
  void draw() {
    super.draw();

    for (var worm in worms) {
      worm.run();

      // use neural network to find better path
      // create input for nn from all worms
      List<double> input = [];
      for (var w in worms) {
        input.add(w.row / Console.rows);
        input.add(w.column / Console.columns);
      }

      List<double> output = neuralNetwork.forward(input);

      int r = (output[0] * Console.rows).round();
      int c = (output[1] * Console.columns).round();

      //Console.moveCursor(row: 2, column: 0);
      //print(
      //    'input: $input | output: $output | ${worm.row} | ${worm.row / Console.rows} | ${((worm.row / Console.rows) * Console.rows).round()}   ');

      worm.pursuitTarget(r, c);
      /*
      cohesion: function(neighboors)
      {
        var sum = new Vector(0,0);
        var count = 0;
        for (var i in neighboors)
        {
          if (neighboors[i] != this)// && !neighboors[i].special)
          {
            sum.add(neighboors[i].location);
            count++;
          }
        }	
        sum.div(count);

        return sum;
      }
      var targetX = function(creature){
        var cohesion = creature.cohesion(world.creatures);
        return cohesion.x / world.width;
      }

      var targetY = function(creature){
        var cohesion = creature.cohesion(world.creatures);
        return cohesion.y / world.height;
      }

      var targetAngle = function(creature){
        var alignment = creature.align(world.creatures);
        return (alignment.angle() + Math.PI) / (Math.PI*2);
      }
      */
      // learn
      List<double> target = [worm.row / Console.rows, worm.column / Console.columns];
      neuralNetwork.backward(target, 0.5);
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
