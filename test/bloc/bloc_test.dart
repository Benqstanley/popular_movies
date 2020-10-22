import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/movie_events.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';

import '../api/mock_tmdb_api.dart';

void main() {
  PopularMoviesBloc bloc;
  setUp((){
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.success());
    bloc = PopularMoviesBloc(InitialState());
  });

  tearDown((){
    GetIt.I.reset();
    bloc?.close();
  });

  test("Bloc test: Fetch Popular Movies", () async {
    bloc = PopularMoviesBloc(InitialState());
    bloc.add(FetchEvent(1));
    var state = await bloc.first;
    expect(state, LoadedState(currentPage: 1));
    expect((state as LoadedState).movies.length, 20);
    verify(GetIt.I<TMDBAPI>().fetchPopularMovies(any));
  });

  test("Bloc test: Fetch Popular Movies", () async {
    bloc = PopularMoviesBloc(InitialState());
    bloc.add(SearchEvent("Jack Reacher"));
    var state = await bloc.first;
    expect(state is LoadedState, true);
    expect((state as LoadedState).movies.length, 2);
    verify(GetIt.I<TMDBAPI>().search(any));
  });


}