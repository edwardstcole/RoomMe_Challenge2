import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class MatchPage extends StatefulWidget {
  final Map<String, int> preferences;

  MatchPage({required this.preferences});
  
  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {

  List<Map<String, dynamic>> peopleList = [];

  List<Map<String, dynamic>> matchedResults = [];

  Map<String, dynamic> defaultPerson = {
    'name': 'Unknown',
  };

  @override
  void initState() {
    super.initState();
    loadPeopleDataFromAsset().then((data) {
      setState(() {
        peopleList = data;
        // Call the matching function when data is loaded
        performMatching();
      });
    });
  }

  Future<List<Map<String, dynamic>>> loadPeopleDataFromAsset() async {
    final String jsonString = await rootBundle.loadString('assets/people-data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }

  Future<void> performMatching({int retries = 3}) async {
    // Your generative AI API key
    String apiKey = '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';
    
    // Prepare the API request body
    List<String> preferences = ['sleep', 'cleanliness', 'study', 'social'];
    List<String> userPreferences = [widget.preferences['sleep'].toString(), widget.preferences['cleanliness'].toString(), widget.preferences['study'].toString(), widget.preferences['social'].toString()];
    List<String> candidates = [];

    for (var person in peopleList) {
      List<String> candidatePreferences = [];
      for (var pref in preferences) {
        candidatePreferences.add(person['preferences'][pref].toString());
      }
      candidates.add(candidatePreferences.join(' '));
    }
    String jsonString = await rootBundle.loadString('assets/people-data.json');

    String prompt = "User base: $jsonString \nMatch top 3 candidates from the list and give me back their names in a json array. Name the array 'names':\n";
    prompt += candidates.join('\n');
    print(prompt);

    // Make the API request
    var response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    //print(peopleList[0]['name']);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      // List<String> matches = data['choices'][0]['message']['content'].split('\n').sublist(1, 4);
      Map<String, dynamic> contentData = json.decode(data['choices'][0]['message']['content']);
    
    // Then extract the names list from this map
      List<String> matches = List<String>.from(contentData['names']);

      print(matches);
      // Extract and store matched people's data based on the match result
      matchedResults = matches.map((match) {
        // Assuming the match is just the name of the person, find the person in the original list
        return peopleList.firstWhere((person) => person['name'] == match, orElse: () => defaultPerson);

      }).toList();

      // Notify the framework to rebuild the widget with new data
      setState(() {});
    }
    else {
      print('API request failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matched Results"),
      ),
      body: ListView.builder(
        itemCount: matchedResults.length, // <-- Use matchedResults here
        itemBuilder: (context, index) {
          final person = matchedResults[index]; // <-- Use matchedResults here
          return ListTile(
            title: Text(person['name']),
            // ... (display other matched data)
          );
        },
      ),
    );
  }
}
