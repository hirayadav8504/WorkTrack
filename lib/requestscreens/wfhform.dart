import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Request_Models/request_model.dart';
import '../Request_Models/request_store.dart';

class WfhFormScreen extends StatefulWidget {
  const WfhFormScreen({super.key});

  @override
  State<WfhFormScreen> createState() => _WfhFormScreenState();
}

class _WfhFormScreenState extends State<WfhFormScreen> {
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController reason = TextEditingController();

  Future<void> selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  ///  FINAL SUBMIT FUNCTION (LOCAL + FIREBASE)
  ///
  Future<void> submitRequest() async {

    if(startDate.text.isEmpty || endDate.text.isEmpty || reason.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {

      ///  CURRENT USER
      final uid = FirebaseAuth.instance.currentUser!.uid;

      ///  SAVE TO FIRESTORE
      await FirebaseFirestore.instance.collection("requests").add({
        "title": "WFH",
        "startDate": startDate.text,
        "endDate": endDate.text,
        "reason": reason.text,
        "status": "Pending",
        "userId": uid,
        "createdAt": Timestamp.now(),
      });

      ///  SAVE LOCALLY FOR LIST UI
      employeeRequests.add(
        RequestModel(
          title: "Work From Home",
          date: "${startDate.text} → ${endDate.text}",
          description: reason.text,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WFH request submitted")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("WFH Request Form"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: startDate,
              readOnly: true,
              onTap: () => selectDate(startDate),
              decoration: InputDecoration(
                labelText: "Start Date",
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: endDate,
              readOnly: true,
              onTap: () => selectDate(endDate),
              decoration: InputDecoration(
                labelText: "End Date",
                suffixIcon: const Icon(Icons.calendar_month),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: reason,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Reason for WFH",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}