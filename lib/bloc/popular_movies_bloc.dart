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

  /* I developed this using flutter_bloc to get some experience with it,
     but I had never used it before, so I didn't think this method through very well,
     After giving it some thought the past few days, I think the changes
     I would make are as follows:

     Stream<MovieState> mapEventToState(MovieEvent event) async* {
          if(tmdbapi == null) tmdbapi = GetIt.I<TMDBAPI>();
          MovieState movieState;
          switch(event.runtimeType){
            case ShowWhatWeHaveEvent:
              yield await createdLoadedState();
              break;
            case SearchEvent:
              yield LoadingState();
              yield await createLoadedStateFromSearch();
              break;
            case FetchEvent:
              if(hasError) yield LoadingState;
              yield await createLoadedState();
              break;
          }
      }

      Where createLoadedState(MovieEvent event) and
      createLoadedStateFromSearch(MovieEvent event), create Loaded or Error
      States depending on the outcome of the Fetch or Search event respectively.
      This would greatly simplify this chunk of code, making it easier to read
      and debug in the future, and making it fit SRP.
  *
  * */

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
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
