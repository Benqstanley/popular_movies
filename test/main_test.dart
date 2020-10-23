import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/main.dart';
import 'package:popular_movies/ui/custom_progress_indicator.dart';
import 'package:popular_movies/ui/movie_details_page.dart';
import 'package:popular_movies/ui/movie_list_page.dart';
import 'package:popular_movies/ui/resources.dart';

import 'api/mock_tmdb_api.dart';
import 'bloc/mock_popular_movies_bloc.dart';

void main() {
  setUp(() {
    GetIt.I.registerSingleton<BaseCacheManager>(DefaultCacheManager());
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.success());
  });

  tearDown(() {
    GetIt.I<PopularMoviesBloc>()?.close();
    GetIt.I.reset();
  });

  /// Upon running the app a query is fired to fetch popular movies
  /// When one of the resulting tiles is tapped the user is taken to the
  /// Movie Details Page for the associated movie.
  /// The user can then navigate back to the Movie List Page

  testWidgets('PopularMoviesApp List Test', (WidgetTester tester) async {
    GetIt.I.registerSingleton<PopularMoviesBloc>(
        MockPopularMoviesBloc.successfulLoad());
    await tester.pumpWidget(PopularMoviesApp());
    expect(find.byType(MovieListPage), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsWidgets);
    await tester.tap(find.byType(ListTile).first);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(MovieDetailsPage), findsOneWidget);
    await tester.pump(Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    //The first movie in the mocked response
    expect(find.text("2067"), findsWidgets);
    expect(find.byType(CustomProgressIndicator), findsOneWidget);
  });

  testWidgets('PopularMoviesApp Popular Failure', (WidgetTester tester) async {
    GetIt.I.registerSingleton<PopularMoviesBloc>(
        MockPopularMoviesBloc.failedLoad());
    await tester.pumpWidget(PopularMoviesApp());
    expect(find.byType(MovieListPage), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsNothing);
    expect(find.text(Resources.failedToLoadPopularMovies), findsOneWidget);
  });

  /// Upon running the app a query is fired to fetch popular movies
  /// When one of the resulting tiles is tapped the user is taken to the
  /// Movie Details Page for the associated movie.
  /// The user can then navigate back to the Movie List Page

  testWidgets('PopularMoviesApp Search List Test', (WidgetTester tester) async {
    GetIt.I.registerSingleton<PopularMoviesBloc>(
        MockPopularMoviesBloc.successfulSearch());
    await tester.pumpWidget(PopularMoviesApp());
    expect(find.byType(MovieListPage), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsWidgets);
    await tester.showKeyboard(find.byType(TextField));
    await tester.enterText(find.byType(TextField), "Jack Reacher");
    expect(find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        widget.onSubmitted("Jack Reacher");
        return true;
      }
      return false;
    }), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('PopularMoviesApp Search Failure', (WidgetTester tester) async {
    GetIt.I.registerSingleton<PopularMoviesBloc>(
        MockPopularMoviesBloc.failedSearch());
    await tester.pumpWidget(PopularMoviesApp());
    expect(find.byType(MovieListPage), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsWidgets);
    await tester.showKeyboard(find.byType(TextField));
    await tester.enterText(find.byType(TextField), "Jack Reacher");
    expect(find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        widget.onSubmitted("Jack Reacher");
        return true;
      }
      return false;
    }), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsNothing);
    expect(find.text(Resources.failedToFindSearchResults), findsOneWidget);
  });

  /// Attempt to use non-mocked bloc
  /// Upon running the app a query is fired to fetch popular movies
  /// When one of the resulting tiles is tapped the user is taken to the
  /// Movie Details Page for the associated movie.
  /// The user can then navigate back to the Movie List Page

  testWidgets('Real Bloc', (WidgetTester tester) async {
    GetIt.I.registerSingleton<PopularMoviesBloc>(
        PopularMoviesBloc(InitialState()));
    await tester.pumpWidget(PopularMoviesApp());
    expect(find.byType(MovieListPage), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsWidgets);
  });
}
