import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/model/movie_overview.dart';
import 'package:popular_movies/ui/custom_progress_indicator.dart';
import 'package:popular_movies/ui/resources.dart';

/// I could utilize the BloC pattern here to retrieve the selected movie.
/// However, I wanted to toy with the argument structure that Fluro enables
/// so I will pass the [MovieOverview] object via the router.

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

  double posterHeight = Resources.posterHeight;
  double posterWidth = Resources.posterWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MediaQuery.of(context).size.height < 600
            ? null
            : AppBar(
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
                  imageBuilder: (context, provider) {
                    provider
                        .resolve(ImageConfiguration())
                        .addListener(ImageStreamListener((info, value) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {
                          posterWidth = info.image.width * 1.0;
                          posterHeight = info.image.height * 1.0;
                        });
                      });
                    }));
                    return Container(
                        height: posterHeight,
                        width: posterWidth,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ]),
                        child: Image(
                          image: provider,
                        ));
                  },
                  imageUrl: widget.selectedMovie.posterPath,
                  placeholder: (context, string) {
                    return SizedBox(
                      height: posterHeight,
                      width: posterWidth,
                      child: Center(child: Text("Loading...")),
                    );
                  },
                  errorWidget: (context, string, ex) {
                    return SizedBox(
                      height: posterHeight,
                      width: posterWidth,
                      child: Center(
                        child: Text("Network Error"),
                      ),
                    );
                  },
                ),
                Container(height: 16),
                TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 1500),
                    builder: (context, progress, child) {
                      String progressString = Resources.formatProgress(
                          progress * widget.selectedMovie.voteAverage * 10);
                      return Column(
                        children: [
                          Text(
                            "${Resources.votesHeader} ${widget.selectedMovie.voteCount}",
                            style:
                                TextStyle(fontSize: 16 * Resources.scaleFactor),
                          ),
                          Container(
                            height: 4,
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  Resources.rating,
                                  style: TextStyle(
                                      fontSize: 16 * Resources.scaleFactor),
                                ),
                                Expanded(
                                  child: CustomProgressIndicator(
                                    height: 12,
                                    progress: progress *
                                        widget.selectedMovie.voteAverage /
                                        10,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  child: Text(
                                    progressString,
                                    style: TextStyle(
                                        fontSize: 16 * Resources.scaleFactor),
                                  ),
                                  width: 56 * Resources.scaleFactor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                Container(
                  height: 8,
                ),
                Text(
                  widget.selectedMovie.title,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                Container(height: 16),
                Text(
                  widget.selectedMovie.description,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
