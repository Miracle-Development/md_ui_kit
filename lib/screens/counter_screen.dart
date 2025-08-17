import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({
    super.key,
    required this.title,
    this.enabled = true,
  });

  final String title;
  final bool enabled;

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.help),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    icon: const Icon(Icons.book),
                    title: const Text('Counter Page'),
                    content: const Text('This is a simple counter page.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Кнопка нажата вот столько раз:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: widget.enabled
            ? FloatingActionButton(
                heroTag: 'FAB',
                onPressed: _incrementCounter,
                tooltip: 'Увеличить счетчик',
                child: const Icon(Icons.add),
              )
            : null,
      );
}
