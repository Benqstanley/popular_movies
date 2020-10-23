import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/model/movie_overview.dart';
import 'package:popular_movies/ui/movie_details_page.dart';
import 'package:popular_movies/ui/movie_list_page.dart';
import 'package:popular_movies/ui/resources.dart';

void main() {
  GetIt.I
      .registerSingleton<PopularMoviesBloc>(PopularMoviesBloc(InitialState()));
  GetIt.I.registerSingleton<TMDBAPI>(TMDBAPI());
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
      title: 'Popular Movies',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color.fromRGBO(248, 201, 114, 1)),
      home: SafeArea(child: Builder(builder: (context) {
        Resources.isSmall = MediaQuery.of(context).size.width < 600;
        Resources.scaleFactor = Resources.isSmall ? 1.0 : 1.5;
        return MovieListPage();
      })),
    );
  }
}
