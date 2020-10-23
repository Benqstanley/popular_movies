import 'package:equatable/equatable.dart';
import 'package:popular_movies/bloc/movie_events.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/model/movie_overview.dart';

/// States that the [PopularMoviesBloc] will provide to the UI.

abstract class MovieState extends Equatable {}

class ErrorState extends MovieState {
  final String errorDescription;
  final MovieEvent offendingEvent;
  final bool hasResults;

  ErrorState(
    this.errorDescription,
    this.offendingEvent, {
    this.hasResults = true,
  });

  @override
  List<Object> get props => [errorDescription];
}

class LoadedState extends MovieState {
  final List<MovieOverview> movies;
  final int currentPage;
  final bool maxReached;

  LoadedState({
    this.movies = const [],
    this.currentPage,
    this.maxReached = false,
  });

  @override
  List<Object> get props => [currentPage];
}

class LoadingState extends MovieState {
  @override
  List<Object> get props => [];
}

class InitialState extends MovieState {
  @override
  List<Object> get props => [];
}
