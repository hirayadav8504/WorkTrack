import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../requestscreens/lunchbreak.dart';
import '../requestscreens/paidleave.dart';
import '../requestscreens/sickleave.dart';
import '../requestscreens/wfhform.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _timeString;
  late String _dateString;
  Timer? _timer;

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');

    _timeString = "${two(now.hour)}:${two(now.minute)}";

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    _dateString =
        "${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingStream = FirebaseFirestore.instance
        .collection("requests")
        .where("status", isEqualTo: "Pending")
        .snapshots();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4facfe), Color(0xff43e97b)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * .92,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                      color: Colors.black.withOpacity(.12),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    /// TOP BAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.menu_rounded, size: 26),
                        Text(
                          "Hey Hira",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xffeef2ff),
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// TIME
                    Text(
                      _timeString,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// DATE
                    Text(
                      _dateString,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// STATUS CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xfff1f5f9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Signed in · Office",

                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: pendingStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox();

                        final count = snapshot.data!.docs.length;

                        if (count == 0) return const SizedBox();

                        return Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Pending Requests : $count",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 26),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          backgroundColor: const Color(0xff111827),
                        ),
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          final uid = user!.uid;

                          final today = DateTime.now();
                          final date =
                              "${today.day}-${today.month}-${today.year}";

                          final docRef = FirebaseFirestore.instance
                              .collection("attendance")
                              .doc("${uid}_$date");

                          if (!isLoggedIn) {
                            /// CHECK IN
                            await docRef.set({
                              "userId": uid,
                              "email": user.email,
                              "status": "IN",
                              "time": Timestamp.now(),
                              "date": date,
                            });
                          } else {
                            /// CHECK OUT
                            await docRef.update({
                              "status": "OUT",
                              "logoutTime": Timestamp.now(),
                            });
                          }

                          setState(() {
                            isLoggedIn = !isLoggedIn;
                          });
                        },
                        child: Text(
                          isLoggedIn ? "CHECK-IN" : "CHECK-OUT",
                          style: const TextStyle(
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// CARDS ROW 1
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LunchBreakForm(),
                              ),
                            ),
                            child: const _ActionCard(
                              icon: Icons.restaurant_menu,
                              title: "LUNCH",
                              subtitleTop: "Start Break",
                              subtitleBottom: "End Break",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WfhFormScreen(),
                              ),
                            ),
                            child: const _ActionCard(
                              icon: Icons.home_outlined,
                              title: "WFH",
                              subtitleTop: "Request",
                              subtitleBottom: "Work From Home",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// CARDS ROW 2
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SickLeaveForm(),
                              ),
                            ),
                            child: const _ActionCard(
                              icon: Icons.medical_services,
                              title: "SICK",
                              subtitleTop: "Request",
                              subtitleBottom: "Sick Leave",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PaidLeaveForm(),
                              ),
                            ),
                            child: const _ActionCard(
                              icon: Icons.currency_rupee,
                              title: "PAID",
                              subtitleTop: "Request",
                              subtitleBottom: "Paid Leave",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= CARD WIDGET =================
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitleTop;
  final String? subtitleBottom;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitleTop,
    this.subtitleBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xfff9fafb),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            subtitleTop,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),

          if (subtitleBottom != null)
            Text(subtitleBottom!, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
