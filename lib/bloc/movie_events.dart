import 'package:popular_movies/bloc/popular_movies_bloc.dart';

/// Events that will be used to trigger api calls. They will carry the
/// requisite information to [PopularMoviesBloc].

abstract class MovieEvent {}

class FetchEvent extends MovieEvent {
  final int pageNumber;

  FetchEvent(this.pageNumber);
}

class SearchEvent extends MovieEvent {
  final String searchQuery;

  SearchEvent(this.searchQuery);
}

class ShowWhatWeHaveEvent extends MovieEvent{

}