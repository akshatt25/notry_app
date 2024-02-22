import 'package:flutter/material.dart';
import 'package:notry_app/global_variables.dart';

class LeadDetailsScreen extends StatelessWidget {
  final String initials;
  final dynamic lead;

  const LeadDetailsScreen(
      {Key? key, required this.lead, required this.initials})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Col.blue,
              child: Text(
                initials,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Name: ${lead['firstName']} ${lead['lastName']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${lead['email']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'City: ${lead['city']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Bio: ${lead['bio']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Address: ${lead['invoiceAddress']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Due: ${lead['invoiceDueCount']}',
              style: TextStyle(fontSize: 16),
            ),
            // Add more lead details here as needed
          ],
        ),
      ),
    );
  }
}
