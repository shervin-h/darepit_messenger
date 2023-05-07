class AppConstant {
  /// Project API keys:
  /// Your API is secured behind an API gateway which requires an API Key for every request.
  /// You can use the keys below to use Supabase client libraries.
  /// This key is safe to use in a browser if you have enabled Row Level Security for your tables and configured policies.
  static const String anonPublicApiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpjcWF1cWNhaG1kZW5ydnB2cm1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzgwMjc2NTksImV4cCI6MTk5MzYwMzY1OX0.PJitvSRadPWNpPg7ipdT60Js7XXMRMPvLX1X8hKIVOo';

  /// API Settings
  static const String projectURL = 'https://zcqauqcahmdenrvpvrmb.supabase.co';


  static const List<String> availableRooms = [];


  /////////////////////////////////////
  ///////// Settings Section //////////
  /////////////////////////////////////
  static const List<String> wallpaperNames = [
    'wallpaper_1.jpg',
    'wallpaper_2.jpg',
    'wallpaper_3.jpg',
  ];
}