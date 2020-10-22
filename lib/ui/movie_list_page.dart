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

  Widget movieItem(MovieOverview overview) {
    return ListTile(
      title: Text(overview.title),
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        PopularMoviesApp.router.navigateTo(context, "/movie", routeSettings: RouteSettings(
          arguments: overview
        ));
      },
    );
  }

  Widget buildMovieListBody(List<MovieOverview> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, position) {
              if (position >= movies.length) return BottomLoadingIndicator();
              return movieItem(movies[position]);
            },
            itemCount: movies.length + 1,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<PopularMoviesBloc, MovieState>(
        cubit: GetIt.I<PopularMoviesBloc>(),
        builder: (context, state) {
          currentState = state;
          if (state is ErrorState) {
            return Center(child: Text("There has been a problem"));
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
    print('building Bottom Loader');
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
