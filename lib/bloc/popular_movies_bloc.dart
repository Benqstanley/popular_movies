import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/movie_events.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/model/movie_overview.dart';

/// This class responds to events to trigger api calls.
/// It maintains the results of those calls and passes that information to the UI
/// in the form of [MovieState]s

class PopularMoviesBloc extends Bloc<MovieEvent, MovieState> {
  List<MovieOverview> popularMovies = [];
  List<MovieOverview> searchResults = [];
  TMDBAPI tmdbapi;
  int currentPage = 0;
  bool fetchInProgress = false;
  final Key key = UniqueKey();

  void printKey() {
    print(key);
  }

  PopularMoviesBloc(MovieState initialState) : super(initialState);

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (tmdbapi == null) tmdbapi = GetIt.I<TMDBAPI>();
    if (event is FetchEvent) {
      if (event?.pageNumber != null &&
          event.pageNumber > currentPage &&
          !fetchInProgress) {
        print("current page is: $currentPage");
        print("Fetching: ${event.pageNumber}");
        fetchInProgress = true;
        print('about to wait');
        List<MovieOverview> nextPage = await tmdbapi.fetchPopularMovies(
          event.pageNumber,
        );
        print('done waiting');
        print(nextPage);
        fetchInProgress = false;
        if (nextPage.isNotEmpty) {
          print('yielding');
          popularMovies.addAll(nextPage);
          currentPage = event.pageNumber;
          yield LoadedState(
            movies: popularMovies,
            currentPage: currentPage,
          );
        }
      }

    } else if (event is SearchEvent) {
      searchResults = await tmdbapi.search(
        event.searchQuery,
      );
      yield LoadedState(
        movies: searchResults,
        maxReached: true,
      );
    }
    return;
  }
}
