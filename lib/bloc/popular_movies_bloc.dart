import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/movie_events.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/model/fetch_movies_response.dart';
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
        fetchInProgress = true;
        FetchMoviesResponse response =
            await tmdbapi.fetchPopularMovies(event.pageNumber);
        List<MovieOverview> nextPage = response.popularMovies;
        fetchInProgress = false;
        if (nextPage != null && nextPage.isNotEmpty) {
          popularMovies.addAll(nextPage);
          currentPage = event.pageNumber;
          yield LoadedState(
            movies: popularMovies,
            currentPage: currentPage,
            maxReached: popularMovies.length >= response.total,
          );
        } else {
          yield ErrorState("Failed To Load Popular Movies");
        }
      }
    } else if (event is SearchEvent) {
      searchResults = await tmdbapi.search(
        event.searchQuery,
      );
      if (searchResults != null && searchResults.isNotEmpty) {
        yield LoadedState(
          movies: searchResults,
          maxReached: true,
        );
      } else {
        yield ErrorState("Failed To Find Search Results");
      }
    }
    return;
  }
}
