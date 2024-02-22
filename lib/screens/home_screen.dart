import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notry_app/global_variables.dart';
import 'package:notry_app/screens/customer_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _leadsFuture;
  late TextEditingController _searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _leadsFuture = fetchLeads();
  }

  Future<List<dynamic>> fetchLeads() async {
    final response = await http.post(
      Uri.parse('https://api.thenotary.app/lead/getLeads'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'notaryId': '643074200605c500112e0902',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['leads'];
    } else {
      throw Exception('Failed to load leads');
    }
  }

  List<dynamic> _filterLeads(List<dynamic> leads, String filter) {
    return leads.where((lead) {
      final firstName = lead['firstName'] as String;
      final lastName = lead['lastName'] as String;
      final fullName = '$firstName $lastName'.toLowerCase();
      return fullName.contains(filter.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          width: 100,
          height: 100,
        ),
        backgroundColor: Colors.white10,
        surfaceTintColor: Colors.white70,
        elevation: 10,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Customer List",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                !isSearching
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.black87,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
          isSearching
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Name',
                      hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Col.blue,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Col.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            isSearching = false;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54)),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                )
              : SizedBox(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _leadsFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final filteredLeads =
                      _filterLeads(snapshot.data!, _searchController.text);
                  if (filteredLeads.isEmpty) {
                    return Center(child: Text('No Such Customers'));
                  }
                  return ListView.builder(
                    itemCount: filteredLeads.length,
                    itemBuilder: (BuildContext context, int index) {
                      final lead = filteredLeads[index];
                      final initials = '${lead['firstName'][0]}'.toUpperCase();
                      return ListTile(
                        minVerticalPadding: 15,
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Col.blue,
                          child: Text(
                            initials,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        title: Text(
                          '${lead['firstName']} ${lead['lastName']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'City: ${lead['city']} ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            Text(
                              "Mail: ${lead['email']}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeadDetailsScreen(
                                      lead: lead,
                                      initials: initials,
                                    )),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
