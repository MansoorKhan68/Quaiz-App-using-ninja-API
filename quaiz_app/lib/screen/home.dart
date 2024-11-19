import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quaiz_app/utils/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // create list for random words
  List<String> option = [];
  // variables for quaiz
  String? question, answer;
  // future function to get api response
 Future<void> fetchQuaiz(String category) async {
  try {
    // Make API request
    final response = await http.get(
      Uri.parse("https://api.api-ninjas.com/v1/trivia?category=$category"),
      headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': APIKEY,
      },
    );

    // Log status and response body
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      print('Parsed Data: $jsonData');
      
      if (jsonData.isNotEmpty) {
        Map<String, dynamic> quaiz = jsonData[0];
        question = quaiz['question'];
        answer = quaiz['answer'];
        print('Question: $question');
        print('Answer: $answer');
      }

      setState(() {});
    } else {
      print('Error: API call failed with status ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}


  // random api function
Future<void> restOption() async {
  try {
    // Make API request
    final response = await http.get(
      Uri.parse("https://api.api-ninjas.com/v1/randomword"),
      headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': APIKEY,
      },
    );

    // Log status and response body
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('Parsed Data: $jsonData');

      if (jsonData.isNotEmpty) {
        // Extract word
        String word = jsonData["word"].toString();
        
        // Add word only if it's not already in the list
        if (!option.contains(word)) {
          option.add(word);
          print('Added word: $word');
        }

        // If less than 3 options, call the method again
        if (option.length < 3)  {
          await restOption();
        } else {
          print('Final Options: $option');
        }
      }
      setState(() {});
    } else {
      print('Error: API call failed with status ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}



  bool music = true,
      geography = false,
      fooddrink = false,
      sciencenature = false,
      environment = false,
      entertainment = false;
  // use init to automatically add the rest option
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restOption();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.purple,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Music Button
                        _buildButton("Music", music, () {
                          setState(() {
                            music = true;
                            geography = false;
                            fooddrink = false;
                            sciencenature = false;
                            environment = false;
                            entertainment = false;
                          });
                        }),
                        const SizedBox(width: 10),

                        // Geography Button
                        _buildButton("Geography", geography, () {
                          setState(() {
                            music = false;
                            geography = true;
                            fooddrink = false;
                            sciencenature = false;
                            environment = false;
                            entertainment = false;
                          });
                        }),
                        const SizedBox(width: 10),

                        // Food & Drink Button
                        _buildButton("Fooddrink", fooddrink, () {
                          setState(() {
                            music = false;
                            geography = false;
                            fooddrink = true;
                            sciencenature = false;
                            environment = false;
                            entertainment = false;
                          });
                        }),
                        const SizedBox(width: 10),

                        // Science & Nature Button
                        _buildButton("Sciencenature", sciencenature, () {
                          setState(() {
                            music = false;
                            geography = false;
                            fooddrink = false;
                            sciencenature = true;
                            environment = false;
                            entertainment = false;
                          });
                        }),
                        const SizedBox(width: 10),

                        // Environment Button
                        _buildButton("Environment", environment, () {
                          setState(() {
                            music = false;
                            geography = false;
                            fooddrink = false;
                            sciencenature = false;
                            environment = true;
                            entertainment = false;
                          });
                        }),
                        const SizedBox(width: 10),

                        // Entertainment Button
                        _buildButton("Entertainment", entertainment, () {
                          setState(() {
                            music = false;
                            geography = false;
                            fooddrink = false;
                            sciencenature = false;
                            environment = false;
                            entertainment = true;
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.02),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "who was the midnight rider ?",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _optionButton("Bill Gates", context),
                        _optionButton("Bilgates", context),
                        _optionButton("Bilgates", context),
                        _optionButton("Bilgates", context),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  // Helper function to create each button
  Widget _buildButton(String text, bool isSelected, VoidCallback onPressed) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.orange : Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Reusable button for question options

Widget _optionButton(String text, BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(
      MediaQuery.of(context).size.width * 0.02,
    ),
    child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.12,
        child: OutlinedButton(
            onPressed: () {},
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: const TextStyle(fontSize: 18),
            ))),
  );
}
