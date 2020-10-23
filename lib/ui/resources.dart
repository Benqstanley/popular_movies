class Resources{
  static String get searchHint => "Search for a Movie";
  static String get rating => "Rating: ";
  static String get votesHeader => "Votes:";


  static String get failedToLoadPopularMovies => "Failed To Load Popular Movies";
  static String get failedToFindSearchResults => "Failed To Load Search Results";
  static String get tapHereToTryAgain => "Tap Here To Try Again";

  static double get posterWidth => 184;
  static double get posterHeight => 278;

  static double scaleFactor = 1.0;
  static bool isSmall = true;

  static String formatProgress(double input){
    StringBuffer formatStringBuffer = StringBuffer(input.toString())
      ..write("000");
    String formattedString =
        formatStringBuffer.toString().substring(0, 4) + "%";
    return formattedString;
  }
}