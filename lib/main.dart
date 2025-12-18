import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Hello World App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    favorites.contains(current)
        ? favorites.remove(current)
        : favorites.add(current);
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordPair = appState.current;
    var isFavorite = appState.favorites.contains(appState.current);
    var likeIcon = isFavorite ? Icons.favorite : Icons.favorite_border;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(wordPair: wordPair),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () => appState.toggleFavorite(),
                  label: Text('Like'),
                  icon: Icon(likeIcon),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => appState.getNext(),
                  child: Text('Next'),
                ),
              ],
            ),
            SizedBox(height: 40),
            ...appState.favorites.map((favorite) => Text(favorite.asLowerCase)),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.wordPair});

  final WordPair wordPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          wordPair.asLowerCase,
          style: style,
          semanticsLabel: "${wordPair.first} ${wordPair.second}",
        ),
      ),
    );
  }
}
