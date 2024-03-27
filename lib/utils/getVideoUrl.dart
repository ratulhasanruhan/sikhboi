String getVideoID(String url) {
  url = url.replaceAll("https://www.youtube.com/watch?v=", "");
  url = url.replaceAll("https://m.youtube.com/watch?v=", "");
  return url;
}