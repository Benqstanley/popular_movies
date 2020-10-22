class Resources{
  static String get searchHint => "Search for a Movie";
  static String get rating => "Rating: ";
  static String get votesHeader => "Votes:";


  static double get posterWidth => 184;
  static double get posterHeight => 278;

  static String formatProgress(double input){
    StringBuffer formatStringBuffer = StringBuffer(input.toString())
      ..write("000");
    String formattedString =
        formatStringBuffer.toString().substring(0, 4) + "%";
    return formattedString;
  }
}