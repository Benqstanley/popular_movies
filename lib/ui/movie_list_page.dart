import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/bloc/movie_events.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/main.dart';
import 'package:popular_movies/model/movie_overview.dart';
import 'package:popular_movies/ui/movie_details_page.dart';
import 'package:popular_movies/ui/resources.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  double _scrollPosition;
  final TextEditingController searchValueController = TextEditingController();
  MovieState previousState;
  MovieState currentState;
  List<MovieOverview> movies;

  //This variable will only be used for larger screens;
  MovieOverview selectedMovie;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Resources.title),
      ),
      body: BlocBuilder<PopularMoviesBloc, MovieState>(
        cubit: GetIt.I<PopularMoviesBloc>(),
        builder: (context, state) {
          previousState = currentState;
          currentState = state;
          if (state is ErrorState) {
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorDescription),
                InkWell(
                  child: Text(
                    Resources.tapHereToTryAgain,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onTap: () {
                    GetIt.I<PopularMoviesBloc>().add(state.offendingEvent);
                  },
                ),
                Container(height: 16),
                if (state.hasResults)
                  InkWell(
                    child: Text(
                      Resources.showWhatWeHave,
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      GetIt.I<PopularMoviesBloc>().add(ShowWhatWeHaveEvent());
                    },
                  ),
              ],
            ));
          } else if (state is LoadedState) {
            if (_scrollPosition != null && previousState is ErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                _scrollController.jumpTo(_scrollPosition);
              });
            }
            movies = state.movies;
            return buildBody();
          } else if (state is InitialState) {
            GetIt.I<PopularMoviesBloc>().add(FetchEvent(1));
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    _scrollPosition = max(_scrollController.offset - _scrollThreshold, 0);
    if (maxScroll - currentScroll <= _scrollThreshold &&
        currentState is LoadedState) {
      GetIt.I<PopularMoviesBloc>()
          .add(FetchEvent((currentState as LoadedState).currentPage + 1));
    }
  }

  Color determineColor(double score) {
    ColorTween redYellow = ColorTween(
      begin: Colors.red,
      end: Colors.yellow,
    );
    ColorTween yellowGreen =
        ColorTween(begin: Colors.yellow, end: Colors.green);
    if (score < 5) {
      return redYellow.lerp(score / 5);
    } else {
      return yellowGreen.lerp((score - 5) / 5);
    }
  }

  Widget movieItem(MovieOverview overview) {
    return ListTile(
      title: Text(
        overview.title,
        style: TextStyle(fontSize: 16 * Resources.scaleFactor),
      ),
      trailing: Icon(Icons.arrow_right),
      leading: CircleAvatar(
        backgroundColor: determineColor(overview.voteAverage),
        child: Text(
          "${overview.voteAverage}",
          style: TextStyle(
            fontSize: 16 * Resources.scaleFactor,
            color: Colors.black,
          ),
        ),
      ),
      onTap: () {
        Resources.isSmall
            ? PopularMoviesApp.router.navigateTo(context, Resources.detailsPath,
                routeSettings: RouteSettings(arguments: overview))
            : setState(() {
                selectedMovie = overview;
              });
      },
    );
  }

  Widget buildSearchArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (searchString) {
                if (searchString != null && searchString.isNotEmpty)
                  GetIt.I<PopularMoviesBloc>().add(SearchEvent(searchString));
              },
              decoration: InputDecoration(
                  hintText: Resources.searchHint,
                  icon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      searchValueController.clear();
                      GetIt.I<PopularMoviesBloc>().add(ShowWhatWeHaveEvent());
                    },
                  )),
              controller: searchValueController,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Resources.isSmall ?? true
        ? buildMovieListBody()
        : Row(
            children: [
              Container(
                child: buildMovieListBody(),
                width: MediaQuery.of(context).size.width / 3,
              ),
              Expanded(
                child: MovieDetailsPage(
                  key: UniqueKey(),
                  selectedMovie: selectedMovie ?? movies?.first,
                ),
              )
            ],
          );
  }

  Widget buildMovieListBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        buildSearchArea(),
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, position) {
              if (position >= movies.length) return BottomLoadingIndicator();
              return movieItem(movies[position]);
            },
            separatorBuilder: (context, position) {
              return Divider(
                color: Colors.grey,
              );
            },
            itemCount: (currentState as LoadedState).maxReached
                ? movies.length
                : movies.length + 1,
          ),
        )
      ],
    );
  }
}

class BottomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
