import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/main.dart';
import 'package:popular_movies/ui/movie_details_page.dart';
import 'package:popular_movies/ui/movie_list_page.dart';

import 'api/mock_tmdb_api.dart';
import 'bloc/mock_popular_movies_bloc.dart';

void main() {
  setUp(() {
    GetIt.I.registerSingleton<PopularMoviesBloc>(
        MockPopularMoviesBloc.loadedState());
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.success());
  });

  tearDown((){
    GetIt.I<PopularMoviesBloc>()?.close();
  });



  testWidgets('PopularMoviesApp List Test', (WidgetTester tester) async {
    await tester.pumpWidget(PopularMoviesApp());
    expect(find.byType(MovieListPage), findsOneWidget);
    await tester.pump(Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsWidgets);
  });
}
