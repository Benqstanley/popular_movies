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
}
