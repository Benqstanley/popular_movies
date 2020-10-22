import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';

import '../api/mock_tmdb_api.dart';
import '../bloc/mock_popular_movies_bloc.dart';

void main (){
  setUp((){
    GetIt.I.registerSingleton<PopularMoviesBloc>(
        MockPopularMoviesBloc.loadedState());
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.success());
  });

  tearDown((){});
}