import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int currentPage = 0;
  final Key key = UniqueKey();

  PopularMoviesBloc(MovieState initialState) : super(initialState);

  factory PopularMoviesBloc.factory(MovieState initialState) {
    PopularMoviesBloc bloc = PopularMoviesBloc(initialState);
    return bloc;
  }

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchEvent) {
      if(event?.pageNumber != null && event.pageNumber > currentPage) {
        List<MovieOverview> nextPage =
        await TMDBAPI.instance().fetchPopularMovies(
          event.pageNumber,
        );
        popularMovies.addAll(nextPage);
        currentPage = event.pageNumber;
      }
      yield LoadedState(
        movies: popularMovies,
        currentPage: currentPage,
      );
    }else if(event is SearchEvent){
      searchResults =
      await TMDBAPI.instance().search(
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
