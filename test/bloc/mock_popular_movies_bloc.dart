import 'package:bloc_test/bloc_test.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/ui/resources.dart';

import '../api/mock_tmdb_api.dart';

class MockPopularMoviesBloc extends MockBloc<MovieState>
    implements PopularMoviesBloc {
  MockPopularMoviesBloc();

  factory MockPopularMoviesBloc.successfulLoad() {
    MockPopularMoviesBloc mockBloc = MockPopularMoviesBloc();
    whenListen(
        mockBloc,
        Stream.fromIterable([
          InitialState(),
          LoadedState(
            movies: MockTMBDAPI.discoverList,
            currentPage: 1,
          )
        ]));
    return mockBloc;
  }

  factory MockPopularMoviesBloc.failedLoad() {
    MockPopularMoviesBloc mockBloc = MockPopularMoviesBloc();
    whenListen(
        mockBloc,
        Stream.fromIterable([
          InitialState(),
          ErrorState(Resources.failedToLoadPopularMovies),
        ]));
    return mockBloc;
  }

  factory MockPopularMoviesBloc.successfulSearch() {
    MockPopularMoviesBloc mockBloc = MockPopularMoviesBloc();
    Stream<MovieState> stream = Stream.fromFutures([
      Future.delayed(Duration(milliseconds: 100), () => InitialState()),
      Future.delayed(
          Duration(milliseconds: 200),
          () => LoadedState(
                movies: MockTMBDAPI.discoverList,
                currentPage: 1,
              )),
      Future.delayed(
          Duration(milliseconds: 300),
          () => LoadedState(
                movies: MockTMBDAPI.searchList,
                currentPage: 1,
              ))
    ]);
    whenListen(mockBloc, stream);
    return mockBloc;
  }

  factory MockPopularMoviesBloc.failedSearch() {
    MockPopularMoviesBloc mockBloc = MockPopularMoviesBloc();
    Stream<MovieState> stream = Stream.fromFutures([
      Future.delayed(Duration(milliseconds: 100), () => InitialState()),
      Future.delayed(
          Duration(milliseconds: 200),
          () => LoadedState(
                movies: MockTMBDAPI.discoverList,
                currentPage: 1,
              )),
      Future.delayed(Duration(milliseconds: 300),
          () => ErrorState(Resources.failedToFindSearchResults))
    ]);
    whenListen(mockBloc, stream);
    return mockBloc;
  }
}
