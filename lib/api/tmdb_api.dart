import 'dart:convert';

import 'package:http/http.dart';
import 'package:popular_movies/model/movie_overview.dart';

class TMDBAPI {
  static final String _apiKey = "4ff9d08260ed338797caa272d7df35dd";
  static final String dataLookup = "http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&page=1&api_key=4ff9d08260ed338797caa272d7df35dd";


  TMDBAPI();


  Future<List<MovieOverview>> fetchPopularMovies(int pageNumber) async {
    pageNumber = pageNumber ?? 1;
    try {
      final response = await get(
          "http://api.themoviedb.org/3/discover/movie"
              "?sort_by=popularity.desc&page=$pageNumber&api_key=$_apiKey");
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        if (jsonMap.containsKey("results")) {
          return (jsonMap["results"] as List<dynamic>).map<MovieOverview>((
              movieMap) {
            return MovieOverview.fromJson(movieMap);
          }).toList();
        }
      }
      print('error');
      return null;
    }catch (error){
      return null;
    }
  }

/*  Future<Map<String, dynamic>> fetchMovieDetails(int id) async {
    final response =
        await get("https://api.themoviedb.org/3/movie/$id?api_key=$_apiKey");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }*/

  Future<List<MovieOverview>> search(String searchTerm) async {
    final response = await get(
        "https://api.themoviedb.org/3/search/"
            "movie?api_key=$_apiKey&language=en-US&query=${_prepareSearchTerm(searchTerm)}&page=1&include_adult=false");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = json.decode(response.body);
      if (jsonMap.containsKey("results")) {
        return (jsonMap["results"] as List<dynamic>).map<MovieOverview>((
            movieMap) {
          return MovieOverview.fromJson(movieMap);
        }).toList();
      }
    }
    return null;
  }

  String _prepareSearchTerm(String searchTerm) {
    return searchTerm.trim().replaceAll(" ", "%20");
  }
}
