import 'package:bloc_test/bloc_test.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';

import '../api/mock_tmdb_api.dart';

class MockPopularMoviesBloc extends MockBloc<MovieState>
    implements PopularMoviesBloc {
  MockPopularMoviesBloc();

  factory MockPopularMoviesBloc.loadedState() {
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

  factory MockPopularMoviesBloc.searchState() {
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
}
