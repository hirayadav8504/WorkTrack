import 'package:flutter/material.dart';

import '../Request_Models/request_model.dart';
import '../Request_Models/request_store.dart';

class SickLeaveForm extends StatefulWidget {
  const SickLeaveForm({super.key});

  @override
  State<SickLeaveForm> createState() => _SickLeaveFormState();
}

class _SickLeaveFormState extends State<SickLeaveForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? fromDate;
  DateTime? toDate;
  bool agree = false;

  final reasonController = TextEditingController();

  int get totalDays {
    if (fromDate == null || toDate == null) return 0;
    return toDate!.difference(fromDate!).inDays + 1;
  }

  Future pickDate(bool isFrom) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        if (isFrom) {
          fromDate = date;
        } else {
          toDate = date;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sick Leave Request")),
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
                onTap: () => pickDate(true),
              ),

              /// To Date
              ListTile(
                title: Text(toDate == null
                    ? "To Date"
                    : toDate.toString().split(" ")[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => pickDate(false),
              ),

              SizedBox(height: 10),
              Text("Total Days: $totalDays"),

              SizedBox(height: 20),

              /// Reason
              TextFormField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Reason for Sick Leave",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter reason";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              /// Declaration
              CheckboxListTile(
                title: Text("I confirm the above information is correct"),
                value: agree,
                onChanged: (val) {
                  setState(() {
                    agree = val ?? false;
                  });
                },
              ),

              SizedBox(height: 20),

              /// Submit Button
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  if (!agree) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please confirm declaration")),
                    );
                    return;
                  }

                  if(fromDate == null || toDate == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select dates")),
                    );
                    return;
                  }

                  /// ADD REQUEST TO GLOBAL LIST
                  employeeRequests.add(
                    RequestModel(
                      title: "Sick Leave",
                      date: "${fromDate.toString().split(" ")[0]} → ${toDate.toString().split(" ")[0]}",
                      description: reasonController.text,
                    ),
                  );

                  /// SUCCESS MESSAGE
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sick Leave request submitted")),
                  );

                  Navigator.pop(context);
                },
                child: Text("Submit Sick Leave Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
