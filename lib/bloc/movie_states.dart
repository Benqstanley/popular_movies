
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/model/movie_overview.dart';

/// States that the [PopularMoviesBloc] will provide to the UI.

abstract class MovieState {}

class ErrorState extends MovieState {
  final String errorDescription;

  ErrorState(this.errorDescription);
}

class LoadedState extends MovieState {
  final List<MovieOverview> movies;
  final int currentPage;

  LoadedState({this.movies = const [], this.currentPage,});
}

class LoadingState extends MovieState {

}

class InitialState extends MovieState {

}