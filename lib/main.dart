import 'package:flutter/material.dart';
import 'match.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      home: MyFormPage(),
    );
  }
}

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  Gender _selectedGender = Gender.male;
  int? _age;
  Map<String, int> _preferences = {};
  String _selectedRoomType = 'Single'; // Set initial value here
  String _location = '';
  int? _idealRoommates;
  String _hometown = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save the form data to a database or elsewhere
      print('Name: $_name');
      print('Gender: $_selectedGender');
      print('Age: $_age');
      print('Preferences: $_preferences');
      print('Room Type: $_selectedRoomType');
      print('Location: $_location');
      print('Ideal Roommates: $_idealRoommates');
      print('Hometown: $_hometown');

      // Navigate to the page where your match will be shown
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchPage(preferences: _preferences)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cole's Onboarding"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              // All the fields of the form

              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<Gender>(
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Text(gender.toString()),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final int age = int.tryParse(value) ?? 0;
                    if (age < 18) {
                      return 'Please enter a valid age (must be at least 18)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.tryParse(value!) ?? 0;
                  },
                ),
                SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextFormFieldPreference(
                      title: 'Sleep',
                      onChanged: (value) {
                        setState(() {
                          _preferences['sleep'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextFormFieldPreference(
                      title: 'Cleanliness',
                      onChanged: (value) {
                        setState(() {
                          _preferences['cleanliness'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextFormFieldPreference(
                      title: 'Study',
                      onChanged: (value) {
                        setState(() {
                          _preferences['study'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextFormFieldPreference(
                      title: 'Social',
                      onChanged: (value) {
                        setState(() {
                          _preferences['social'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedRoomType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRoomType = newValue!;
                    });
                  },
                  items: ['Single', 'Double'].map((roomType) {
                    return DropdownMenuItem<String>(
                      value: roomType,
                      child: Text(roomType),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Room Type'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _location = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Ideal Number of Roommates (1-3)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ideal number of roommates';
                    }
                    final int idealRoommates = int.tryParse(value) ?? 0;
                    if (idealRoommates < 0 || idealRoommates > 3) {
                      return 'Please enter a valid number of roommates (between 0 and 3)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _idealRoommates = int.tryParse(value!) ?? 0;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Hometown'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your hometown';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _hometown = value!;
                  },
                ),
                SizedBox(height: 24.0),

                // Submit button, will only work if fields are filled out correctly

                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Gender {
  male,
  female,
  other,
}

class TextFormFieldPreference extends StatefulWidget {
  final String title;
  final ValueChanged<String> onChanged;

  TextFormFieldPreference({required this.title, required this.onChanged});

  @override
  _TextFormFieldPreferenceState createState() => _TextFormFieldPreferenceState();
}

class _TextFormFieldPreferenceState extends State<TextFormFieldPreference> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title, style: TextStyle(fontSize: 16)),
        SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: '1 to 10'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              final int number = int.tryParse(value) ?? 0;
              if (number < 1 || number > 10) {
                return 'Please enter a number between 1 and 10';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _value = value;
                widget.onChanged(_value);
              });
            },
          ),
        ),
      ],
    );
  }
}
