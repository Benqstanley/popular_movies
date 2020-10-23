import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/api/tmdb_api.dart';
import 'package:popular_movies/bloc/movie_events.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/model/fetch_movies_response.dart';
import 'package:popular_movies/model/movie_overview.dart';
import 'package:popular_movies/ui/resources.dart';

/// This class responds to events to trigger api calls.
/// It maintains the results of those calls and passes that information to the UI
/// in the form of [MovieState]s

class PopularMoviesBloc extends Bloc<MovieEvent, MovieState> {
  List<MovieOverview> popularMovies = [];
  List<MovieOverview> searchResults = [];
  TMDBAPI tmdbapi;
  int currentPage = 0;
  bool fetchInProgress = false;
  bool hasError = false;
  final Key key = UniqueKey();

  void printKey() {
    print(key);
  }

  PopularMoviesBloc(MovieState initialState) : super(initialState);

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    print(event);
    if (tmdbapi == null) tmdbapi = GetIt.I<TMDBAPI>();
    if (event is ShowWhatWeHaveEvent) {
      yield LoadedState(
        movies: popularMovies,
        currentPage: currentPage,
      );
      return;
    }
    if (hasError || event is SearchEvent) yield LoadingState();
    if (event is FetchEvent) {
      if (event?.pageNumber != null &&
          event.pageNumber > currentPage &&
          !fetchInProgress) {
        fetchInProgress = true;
        FetchMoviesResponse response =
            await tmdbapi.fetchPopularMovies(event.pageNumber);
        List<MovieOverview> nextPage = response?.popularMovies;
        fetchInProgress = false;
        if (nextPage != null && nextPage.isNotEmpty) {
          popularMovies.addAll(nextPage);
          currentPage = event.pageNumber;
          hasError = false;
          yield LoadedState(
            movies: popularMovies,
            currentPage: currentPage,
            maxReached: popularMovies.length >= response.total,
          );
          return;
        } else {
          hasError = true;
          yield ErrorState(
            Resources.failedToLoadPopularMovies,
            event,
            hasResults: popularMovies.isNotEmpty,
          );
          return;
        }
      }
    } else if (event is SearchEvent) {
      searchResults = await tmdbapi.search(
        event.searchQuery,
      );
      if (searchResults != null && searchResults.isNotEmpty) {
        hasError = false;
        yield LoadedState(
          movies: searchResults,
          maxReached: true,
        );
        return;
      } else {
        hasError = true;
        yield ErrorState(
          Resources.failedToFindSearchResults,
          event,
          hasResults: popularMovies.isNotEmpty,
        );
        return;
      }
    }
    return;
  }
}
