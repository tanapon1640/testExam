import 'package:flutter/material.dart';
import 'package:projectofsgn/view/widgets/custom_app_bar.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<Map<String, dynamic>> currentMockData = [];
  Map<String, dynamic> mockDataSets = {};

  @override
  void initState() {
    super.initState();
    loadMockData();
  }

  Future<void> loadMockData() async {
    final String response = await rootBundle.loadString(
      'assets/mock_status_data.json',
    );
    final data = json.decode(response);
    setState(() {
      mockDataSets = data;
      currentMockData = List<Map<String, dynamic>>.from(
        mockDataSets["applicationSubmitted"],
      );
    });
  }

  final List<Map<String, dynamic>> mockData = [
    {
      "title": "Application Submitted",
      "status": "Pass",
      "date": "10 May 2025, 10:42 PM",
    },
    {
      "title": "Initial Review",
      "status": "Pass",
      "date": "11 May 2025, 10:42 PM",
    },
    {
      "title": "Document Verification",
      "status": "In progress",
      "date": "12 May 2025, 10:42 PM",
    },
    {"title": "Final Approval", "status": "Pending", "date": ""},
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pass':
        return Colors.green;
      case 'in progress':
        return Colors.yellow;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String getSubtitle(Map<String, dynamic> item) {
    if (item['status'].toLowerCase() == 'pass') {
      return item['date'] ?? '';
    } else if (item['status'].toLowerCase() == 'in progress') {
      return 'In progress';
    } else {
      return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Status Tracking'),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 221, 234, 245),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LTR Visa Application",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "#LTR-22345",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: 3,
                      height: 280,
                      decoration: const BoxDecoration(color: Colors.grey),
                    ),
                    Column(
                      children:
                          currentMockData.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                bottom: 40,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    width: 23,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getStatusColor(item['status']),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['title'] ?? ''),
                                      Text(getSubtitle(item)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentMockData = List<Map<String, dynamic>>.from(
                        mockDataSets["applicationSubmitted"],
                      );
                    });
                  },
                  child: const Text("Test Status Application Submitted Done"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentMockData = List<Map<String, dynamic>>.from(
                        mockDataSets["initialReview"],
                      );
                    });
                  },
                  child: const Text("Test Status Initial Review Done"),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentMockData = List<Map<String, dynamic>>.from(
                        mockDataSets["documentVerification"],
                      );
                    });
                  },
                  child: const Text("Test Status Document Verification Done"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentMockData = List<Map<String, dynamic>>.from(
                        mockDataSets["finalApproval"],
                      );
                    });
                  },
                  child: const Text("Test Status Final Approval Done"),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
