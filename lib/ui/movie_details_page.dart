import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_details.dart';
import 'package:popular_movies/model/movie_overview.dart';
import 'package:popular_movies/ui/custom_progress_indicator.dart';

/// I could utilize the BloC pattern here to retrieve the selected movie.
/// However, I wanted to toy with the argument structure that Fluro enables
/// so I will pass the [MovieDetails] object via the router.

class MovieDetailsPage extends StatefulWidget {
  final MovieOverview selectedMovie;

  const MovieDetailsPage({
    Key key,
    @required this.selectedMovie,
  }) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedMovie.title),
      ),
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
                imageUrl: widget.selectedMovie.posterPath,
                placeholder: (context, string) {
                  return SizedBox(
                    width: 184,
                    height: 278,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              Container(height: 16),
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 1500),
                  builder: (context, progress, child) {
                    StringBuffer progressStringBuffer = StringBuffer(
                        (progress * widget.selectedMovie.voteAverage * 10)
                            .toString())
                      ..write("000");
                    String progressString =
                        progressStringBuffer.toString().substring(0, 4) + "%";
                    return Row(
                      children: [
                        Text(
                          "Rating: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: CustomProgressIndicator(
                            progress: progress,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          progressString,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }),
              Text(
                widget.selectedMovie.title,
                style: TextStyle(fontSize: 30),
              ),
              Container(height: 50),
              Text(
                widget.selectedMovie.description,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
