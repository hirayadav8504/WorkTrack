import 'package:flutter/material.dart';
import '../Request_Models/request_model.dart';


class RequestDetailScreen extends StatelessWidget {
  final RequestModel request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {

    Color statusColor;
    switch(request.status){
      case "Approved":
        statusColor = Colors.green;
        break;
      case "Rejected":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Details"),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4facfe), Color(0xff43e97b)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                request.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text("Date: ${request.date}"),
              const SizedBox(height: 8),

              Text("Reason: ${request.description}"),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text("Status: "),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}