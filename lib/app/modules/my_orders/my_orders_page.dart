import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Text("No orders yet.",
                  style: GoogleFonts.poppins(fontSize: 16)),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;

              //final orderTime = (data['timestamp'] as Timestamp?)?.toDate();
              DateTime orderTime;
              if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
                orderTime = (data['timestamp'] as Timestamp).toDate();
              } else {
                orderTime = DateTime.now(); // Fallback or show 'Pending...'
              }

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['productTitle'],
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Quantity: ${data['quantity']}',
                          style: GoogleFonts.poppins()),
                      Text('Total: \$${data['total']}',
                          style: GoogleFonts.poppins()),
                      Text(
                          'Ordered on: ${DateFormat.yMMMd().add_jm().format(orderTime)}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
