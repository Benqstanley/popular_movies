import 'dart:convert';

import 'package:http/http.dart';
import 'package:popular_movies/model/fetch_movies_response.dart';
import 'package:popular_movies/model/movie_overview.dart';

class TMDBAPI {
  //TODO: Input your own api key
  static final String _apiKey = "ENTER API KEY HERE";

  TMDBAPI();

  Future<FetchMoviesResponse> fetchPopularMovies(int pageNumber) async {
    pageNumber = pageNumber ?? 1;
    try {
      final response = await get("http://api.themoviedb.org/3/discover/movie"
              "?sort_by=popularity.desc&page=$pageNumber&api_key=$_apiKey")
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        if (jsonMap.containsKey("results")) {
          return FetchMoviesResponse(
            popularMovies: (jsonMap["results"] as List<dynamic>)
                .map<MovieOverview>((movieMap) {
              return MovieOverview.fromJson(movieMap);
            }).toList(),
            total: jsonMap.containsKey("total_results")
                ? jsonMap["total_results"]
                : 0,
          );
        }
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  Future<List<MovieOverview>> search(String searchTerm) async {
    try {
      final response = await get("https://api.themoviedb.org/3/search/"
          "movie?api_key=$_apiKey&language=en-US&query=${_prepareSearchTerm(
          searchTerm)}&page=1&include_adult=false")
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        if (jsonMap.containsKey("results")) {
          return (jsonMap["results"] as List<dynamic>)
              .map<MovieOverview>((movieMap) {
            return MovieOverview.fromJson(movieMap);
          }).toList();
        }
      }
      return null;
    }catch (error){
      return null;
    }
  }

  String _prepareSearchTerm(String searchTerm) {
    return searchTerm.trim().replaceAll(" ", "%20");
  }
}
