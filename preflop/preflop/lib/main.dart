import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GridScreen(),
    );
  }
}

class GridScreen extends StatefulWidget {
  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final GlobalKey _gridViewKey = GlobalKey();
  int tilesRow = 13;
  late int totalTiles = tilesRow * tilesRow;
  late int tilesSize = (MediaQuery.of(context).size.width / tilesRow).floor();
  late List<bool> _cellStates = List.generate(totalTiles, (index) => false);
  // late final DragStartBehavior dragStartBehavior;

  void _updateCellState(Offset globalPosition) {
    print("running _updateCellState");
    final RenderObject? gridViewRenderObject =
        _gridViewKey.currentContext?.findRenderObject();
    if (gridViewRenderObject != null) {
      final RenderBox gridViewRenderBox = gridViewRenderObject as RenderBox;
      final Offset localPosition =
          gridViewRenderBox.globalToLocal(globalPosition);
      int col = (localPosition.dx ~/ tilesSize).clamp(0, tilesRow - 1);
      print('col: $col');
      int row = (localPosition.dy ~/ tilesSize).clamp(0, tilesRow - 1);
      print('row: $row');
      int index = row * tilesRow + col;
      print('index: $index');
      _cellStates[index] = true;
      print('\n');

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag to Paint'),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            print('tst');
            _updateCellState(details.globalPosition);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              key: _gridViewKey,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: tilesRow,
              ),
              itemCount: totalTiles,
              itemBuilder: (context, index) {
                // bool test = _cellStates[index];
                // print('Index: $index: $test');
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: _cellStates[index] ? Colors.green : Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
