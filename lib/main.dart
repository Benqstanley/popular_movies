import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/model/movie_details.dart';
import 'package:popular_movies/model/movie_overview.dart';
import 'package:popular_movies/ui/movie_details_page.dart';
import 'package:popular_movies/ui/movie_list_page.dart';

import 'bloc/movie_states.dart';
import 'bloc/popular_movies_bloc.dart';

void main() {
  GetIt.I
      .registerSingleton<PopularMoviesBloc>(PopularMoviesBloc.factory(InitialState()));
  runApp(PopularMoviesApp());
}

class PopularMoviesApp extends StatefulWidget {
  static FluroRouter router;

  @override
  _PopularMoviesAppState createState() => _PopularMoviesAppState();
}

class _PopularMoviesAppState extends State<PopularMoviesApp> {
  _PopularMoviesAppState() {
    FluroRouter router = FluroRouter();
    router.define("/movie", handler: Handler(handlerFunc: (context, params) {
      return MovieDetailsPage(
        selectedMovie: context.settings.arguments as MovieOverview,
      );
    }));
    router.define("/", handler: Handler(handlerFunc: (context, params) {
      return MovieListPage();
    }));
    PopularMoviesApp.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MovieListPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void printWrapped(Object toPrint) {
    printWrappedString(toPrint.toString());
  }

  void printWrappedString(String toPrint) {
    if (toPrint.length > 175) {
      print(toPrint.substring(0, 175));
      printWrappedString(toPrint.substring(175));
    } else {
      print(toPrint);
    }
  }

  void _incrementCounter() async {
    printWrapped((await TMDBAPI.instance().fetchPopularMovies(1)));
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
