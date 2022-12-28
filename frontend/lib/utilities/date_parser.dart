String formatTime(String dateStr) {
  if (dateStr == "") return "";
  var date = DateTime.parse(dateStr);
  return date.toString().split(".").first;
}
