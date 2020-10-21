import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movies/bloc/movie_states.dart';
import 'package:popular_movies/bloc/popular_movies_bloc.dart';
import 'package:popular_movies/model/movie_overview.dart';

class MovieListPage extends StatelessWidget {
  Widget buildMovieListBody(List<MovieOverview> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        ListView.builder(itemBuilder: (context, position) {
          return Text(movies[position].name);
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<PopularMoviesBloc, MovieState>(
        builder: (context, state) {
          if (state is ErrorState) {
            return Center(child: Text("There has been a problem"));
          } else if (state is LoadedState) {
            return buildMovieListBody(state.movies);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        buildWhen: (oldState, currentState) {
          if (oldState is LoadedState && currentState is LoadedState) {
            return oldState.movies.length < currentState.movies.length;
          } else if (currentState is ErrorState && oldState is LoadedState) {
            return false;
          }
          return false;
        },
      ),
    );
  }
}
