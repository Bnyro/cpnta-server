String formatTime(String dateStr) {
  var date = DateTime.parse(dateStr);
  return date.toString().split(".").first;
}
