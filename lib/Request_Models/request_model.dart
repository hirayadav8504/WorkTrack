class RequestModel {
  final String title;
  final String date;
  final String status;
  final String description;

  RequestModel({
    required this.title,
    required this.date,
    required this.description,
    this.status = "Pending",

  });
}