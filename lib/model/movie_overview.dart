/// Objects of this type contain the overview of a movie,
/// (the information retrieved from search/discover calls)

class MovieOverview {
  final String name;
  final int id;
  final double popularity;
  final int voteCount;
  final double voteAverage;

  MovieOverview({
    this.popularity,
    this.voteCount,
    this.voteAverage,
    this.name,
    this.id,
  });

  factory MovieOverview.fromJson(Map<String, dynamic> json) {
    print(json);
    return MovieOverview();
  }
}
