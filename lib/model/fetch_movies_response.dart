import 'package:popular_movies/model/movie_overview.dart';

class FetchMoviesResponse {
  final List<MovieOverview> popularMovies;
  final int total;

  FetchMoviesResponse({
    this.popularMovies,
    this.total,
  });
}
