import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_movies/bloc/movie_events.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/main.dart';
import 'package:popular_movies/model/movie_overview.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final TextEditingController searchValueController = TextEditingController();
  MovieState currentState;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
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
      title: Text(overview.title),
      trailing: Icon(Icons.arrow_right),
      leading: CircleAvatar(
        backgroundColor: determineColor(overview.voteAverage),
        child: Text(
          "${overview.voteAverage}",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      onTap: () {
        PopularMoviesApp.router.navigateTo(context, "/movie",
            routeSettings: RouteSettings(arguments: overview));
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
                  hintText: "Search for a Movie",
                  icon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      searchValueController.clear();
                      GetIt.I<PopularMoviesBloc>().add(FetchEvent(
                          (currentState as LoadedState).currentPage));
                    },
                  )),
              controller: searchValueController,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMovieListBody(List<MovieOverview> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Movies"),
      ),
      body: BlocBuilder<PopularMoviesBloc, MovieState>(
        cubit: GetIt.I<PopularMoviesBloc>(),
        builder: (context, state) {
          currentState = state;
          if (state is ErrorState) {
            return Center(child: Text(state.errorDescription));
          } else if (state is LoadedState) {
            return buildMovieListBody(state.movies);
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
