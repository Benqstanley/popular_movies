
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
  PopularMoviesBloc(MovieState initialState) : super(initialState);

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    switch(event.runtimeType){
      case FetchEvent:
        var nextPage = await TMDBAPI.instance().fetchPopularMovies((event as FetchEvent).pageNumber);
        popularMovies.addAll(nextPage);
        yield LoadedState(popularMovies);
        break;
    }
  }
}



