import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_details.dart';
import 'package:popular_movies/model/movie_overview.dart';

/// I could utilize the BloC pattern here to retrieve the selected movie.
/// However, I wanted to toy with the argument structure that Fluro enables
/// so I will pass the [MovieDetails] object via the router.

class MovieDetailsPage extends StatelessWidget {
  final MovieOverview selectedMovie;

  const MovieDetailsPage({
    Key key,
    @required this.selectedMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //CachedNetworkImage(imageUrl: selectedMovie.detailsPageUrl),
            Text(selectedMovie.title),
            Text(selectedMovie.description),
          ],
        ),
      ),
    );
  }
}
