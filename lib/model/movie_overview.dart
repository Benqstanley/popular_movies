/// Objects of this type contain the overview of a movie,
/// (the information retrieved from search/discover calls)

class MovieOverview {
  final String title;
  final String description;
  final int id;
  final double popularity;
  final int voteCount;
  final double voteAverage;
  final String posterPath;

  MovieOverview({
    this.popularity,
    this.voteCount,
    this.voteAverage,
    this.title,
    this.id,
    this.description,
    this.posterPath,
  });

  factory MovieOverview.fromJson(Map<String, dynamic> json) {
    print(json);
    return MovieOverview(
      popularity: json.containsKey("popularity")
          ? double.tryParse(json["popularity"].toString())
          : 0.0,
      title: json.containsKey("title") ? json["title"] : "",
      description: json.containsKey("overview") ? json["overview"] : "",
      voteAverage: json.containsKey("vote_average")
          ? double.tryParse(json["vote_average"].toString())
          : 0,
      voteCount: json.containsKey("vote_count") ? json["vote_count"] : 0,
      id: json.containsKey("id") ? json["id"] : 0,
      posterPath: json.containsKey("poster_path") ? "https://image.tmdb.org/t/p/w185" + json["poster_path"] : "",
    );
  }

  @override
  String toString() {
    return """{title: $title,\nid: $id,\nvoteCount: $voteCount, \nvoteAverage: $voteAverage,\npopularity: $popularity}""";
  }
}
