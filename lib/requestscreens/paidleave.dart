import 'package:flutter/material.dart';

import '../Request_Models/request_model.dart';
import '../Request_Models/request_store.dart';

class PaidLeaveForm extends StatefulWidget {
  const PaidLeaveForm({super.key});

  @override
  State<PaidLeaveForm> createState() => _PaidLeaveFormState();
}

class _PaidLeaveFormState extends State<PaidLeaveForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? fromDate;
  DateTime? toDate;
  final reasonController = TextEditingController();

  int get totalDays {
    if (fromDate == null || toDate == null) return 0;
    return toDate!.difference(fromDate!).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paid Leave Request")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              /// From Date
              ListTile(
                title: Text(fromDate == null
                    ? "From Date"
                    : fromDate.toString().split(" ")[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  fromDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    initialDate: DateTime.now(),
                  );
                  setState(() {});
                },
              ),

              /// To Date
              ListTile(
                title: Text(toDate == null
                    ? "To Date"
                    : toDate.toString().split(" ")[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  toDate = await showDatePicker(
                    context: context,
                    firstDate: fromDate ?? DateTime.now(),
                    lastDate: DateTime(2030),
                    initialDate: DateTime.now(),
                  );
                  setState(() {});
                },
              ),

              SizedBox(height: 10),
              Text("Total Days: $totalDays"),

              SizedBox(height: 20),

              /// Reason
              TextFormField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Reason for Paid Leave",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter reason";
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),

              /// Submit Button
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  if(fromDate == null || toDate == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select dates")),
                    );
                    return;
                  }

                  /// ADD REQUEST TO GLOBAL LIST
                  employeeRequests.add(
                    RequestModel(
                      title: "Paid Leave",
                      date: "${fromDate.toString().split(" ")[0]} → ${toDate.toString().split(" ")[0]}",
                      description: reasonController.text,
                    ),
                  );

                  /// SUCCESS MESSAGE
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Paid Leave request submitted")),
                  );

                  Navigator.pop(context);
                },
                child: Text("Submit Request"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
