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
      appBar: AppBar(title: Text(selectedMovie.title),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 8,
              ),
              CachedNetworkImage(
                imageUrl: selectedMovie.posterPath,
                placeholder: (context, string) {
                  return SizedBox(
                    width: 184,
                    height: 278,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              Container(height: 16),
              Text(
                selectedMovie.title,
                style: TextStyle(fontSize: 30),
              ),
              Container(height: 50),
              Text(
                selectedMovie.description,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
