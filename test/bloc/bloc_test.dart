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
  setUp(() {
    bloc = PopularMoviesBloc(InitialState());
  });

  tearDown(() {
    bloc?.close();
    GetIt.I.reset();
  });

  test("Bloc test: Fetch Popular Movies", () async {
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.success());
    bloc.add(FetchEvent(1));
    var state = await bloc.first;
    expect(state, LoadedState(currentPage: 1));
    expect((state as LoadedState).movies.length, 20);
    verify(GetIt.I<TMDBAPI>().fetchPopularMovies(any));
  });

  test("Bloc test: Search Movies", () async {
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.success());
    bloc.add(SearchEvent("Jack Reacher"));
    var state = await bloc.first;
    expect(state is LoadingState, true);
    await Future.delayed(Duration(milliseconds: 100));
    expect(bloc.state is LoadedState, true);
    expect((bloc.state as LoadedState).movies.length, 2);
    verify(GetIt.I<TMDBAPI>().search(any));
  });

  test("Bloc test: Fetch Popular Movies, failure", () async {
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.failure());
    bloc.add(FetchEvent(1));
    var state = await bloc.first;
    expect(state is ErrorState, true);
    verify(GetIt.I<TMDBAPI>().fetchPopularMovies(any));
  });

  test("Bloc test: Search Movies, failure", () async {
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.failure());
    bloc.add(SearchEvent("Jack Reacher"));
    var state = await bloc.first;
    expect(state is LoadingState, true);
    await Future.delayed(Duration(milliseconds: 100));
    expect(bloc.state is ErrorState, true);
    verify(GetIt.I<TMDBAPI>().search(any));
  });

  test(
      "Bloc test: Fetch Popular Movies, show error after first load, then show old results",
      () async {
    GetIt.I.registerSingleton<TMDBAPI>(MockTMBDAPI.successOnce());
    bloc.add(FetchEvent(1));
    await Future.delayed(Duration(milliseconds: 100));

    expect(bloc.state, LoadedState(currentPage: 1));
    bloc.add(FetchEvent(2));
    await Future.delayed(Duration(milliseconds: 100));

    expect(bloc.state is ErrorState, true);
    bloc.add(ShowWhatWeHaveEvent());
    await Future.delayed(Duration(milliseconds: 100));

    expect(bloc.state is LoadedState, true);
    verify(GetIt.I<TMDBAPI>().fetchPopularMovies(any));
  });
}
