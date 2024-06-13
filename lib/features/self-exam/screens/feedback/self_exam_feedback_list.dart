import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelfExamFeedbackList extends StatelessWidget {
  const SelfExamFeedbackList({Key? key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Self-Exam Feedback History',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        elevation: 4,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('BSEFeedbacks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No feedback available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var feedback = snapshot.data!.docs[index];
              var feedbackUserId = feedback['userId'];
              var currentUserId = user?.uid;

              if (currentUserId != null && feedbackUserId == currentUserId) {
                var timestamp = feedback['timestamp'] != null
                    ? (feedback['timestamp'] as Timestamp).toDate()
                    : null;
                var formattedDate = timestamp != null
                    ? DateFormat('dd MMM yyyy').format(timestamp)
                    : 'Unknown';
                var changeType = feedback['changeType'] ?? 'Unknown';
                var location = feedback['location'] ?? 'Unknown';
                var duration = feedback['duration'] ?? 'Unknown';
                var isOnPeriod = feedback['isOnPeriod'] != null
                    ? (feedback['isOnPeriod'] ? 'Yes' : 'No')
                    : 'Unknown';
                var lastPeriodDate = feedback['lastPeriodDate'] != null
                    ? (feedback['lastPeriodDate'] as Timestamp).toDate()
                    : null;
                var formattedLastPeriodDate = lastPeriodDate != null
                    ? DateFormat('dd MMM yyyy').format(lastPeriodDate)
                    : 'Unknown';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          changeType,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Location: $location',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Duration: $duration',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'On Period: $isOnPeriod',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Last Period Date: $formattedLastPeriodDate',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Recorded Date: $formattedDate',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Return an empty container if userID doesn't match
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
