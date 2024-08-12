import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScrollViewScreen(),
    );
  }
}

class ScrollViewScreen extends StatefulWidget {
  const ScrollViewScreen({super.key});

  @override
  _ScrollViewScreenState createState() => _ScrollViewScreenState();
}

class _ScrollViewScreenState extends State<ScrollViewScreen> {
  final ScrollController _scrollController = ScrollController();
  int _savedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_saveLastFullyVisibleItem);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_saveLastFullyVisibleItem);
    _scrollController.dispose();
    super.dispose();
  }

  void _saveLastFullyVisibleItem() {
    double viewportHeight = _scrollController.position.viewportDimension;
    double offset = _scrollController.offset;

    int lastFullyVisibleIndex = (offset + viewportHeight) ~/ 200;

    setState(() {
      _savedIndex =
          lastFullyVisibleIndex - 1; // Save the last fully visible item
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom ScrollView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(item: _savedIndex),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  height: 200.0, // Each item has a height of 200 pixels
                  color: index.isEven ? Colors.blue[100] : Colors.blue[300],
                  child: Center(
                    child: Text(
                      'Item $index',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }
} 


class ItemDetailScreen extends StatelessWidget {
  final int item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item $item'),
      ),
      body: Center(
        child: Text('You saved Item $item'),
      ),
    );
  }
}
