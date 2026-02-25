import 'package:flutter/material.dart';

import '../Request_Models/request_model.dart';
import '../Request_Models/request_store.dart';

class LunchBreakForm extends StatefulWidget {
  const LunchBreakForm({super.key});

  @override
  State<LunchBreakForm> createState() => _LunchBreakFormState();
}

class _LunchBreakFormState extends State<LunchBreakForm> {
  final _formKey = GlobalKey<FormState>();

  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  bool agree = false;

  final reasonController = TextEditingController();

  int get totalMinutes {
    if (fromTime == null || toTime == null) return 0;
    final from = fromTime!.hour * 60 + fromTime!.minute;
    final to = toTime!.hour * 60 + toTime!.minute;
    return to - from;
  }

  Future pickTime(bool isFrom) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        isFrom ? fromTime = time : toTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lunch Break Request")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              /// From Time
              ListTile(
                title: Text(fromTime == null
                    ? "From Time"
                    : fromTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => pickTime(true),
              ),

              /// To Time
              ListTile(
                title: Text(toTime == null
                    ? "To Time"
                    : toTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => pickTime(false),
              ),

              SizedBox(height: 10),
              Text("Total Duration: $totalMinutes minutes"),

              SizedBox(height: 20),

              /// Reason
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: "Reason (optional)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              /// Declaration
              CheckboxListTile(
                title: Text("I will resume work on time"),
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

                  if(fromTime == null || toTime == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select time")),
                    );
                    return;
                  }

                  if (!agree) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please accept declaration")),
                    );
                    return;
                  }

                  /// ADD REQUEST TO GLOBAL LIST
                  employeeRequests.add(
                    RequestModel(
                      title: "Lunch Break",
                      date: "${fromTime!.format(context)} → ${toTime!.format(context)}",
                      description: reasonController.text.isEmpty
                          ? "Lunch break requested"
                          : reasonController.text,
                    ),
                  );

                  /// SUCCESS MESSAGE
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lunch break request submitted")),
                  );

                  Navigator.pop(context);
                },
                child: Text("Submit Lunch Break Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
