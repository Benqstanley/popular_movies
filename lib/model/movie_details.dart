/// Objects of this type contain the details for a queried movie.

class MovieDetails {
  final String detailsPageUrl;
  final String description;
  final double rating;
  final List<String> genres;
  final int id;

  MovieDetails({
    this.detailsPageUrl,
    this.description,
    this.rating,
    this.genres,
    this.id,
  });
}
