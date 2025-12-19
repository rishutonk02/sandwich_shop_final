import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandwich_shop/firebase_example.dart';

class FirebaseOrdersScreen extends StatelessWidget {
  const FirebaseOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final example = FirebaseExample();
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: example.ordersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('No orders yet'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              final item = d['item'] ?? 'unknown';
              final created = d['created_at'] ?? '';
              final uid = d['uid'] ?? '';
              return ListTile(
                title: Text(item.toString()),
                subtitle: Text('by $uid • $created'),
              );
            },
          );
        },
      ),
    );
  }
}
