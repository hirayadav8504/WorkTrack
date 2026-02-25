import 'package:flutter/material.dart';
import '../Request_Models/request_model.dart';
import '../Request_Models/request_store.dart';
import '../requestscreens/request_detail_screen.dart';


class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<RequestModel> requests = employeeRequests;

    Color getStatusColor(String status){
      switch(status){
        case "Approved":
          return Colors.green;
        case "Rejected":
          return Colors.red;
        default:
          return Colors.orange;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
        centerTitle: true,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4facfe), Color(0xff43e97b)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: requests.isEmpty
            ? const Center(
          child: Text(
            "No requests yet",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index){

            final req = requests[index];
            final color = getStatusColor(req.status);


            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RequestDetailScreen(request: req),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0,6),
                      color: Colors.black.withOpacity(.06),
                    )
                  ],
                ),
                child: Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.assignment_outlined, color: color),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            req.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            req.date,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),

                          Text(
                            req.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        req.status,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}