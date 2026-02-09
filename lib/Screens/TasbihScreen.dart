import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({Key? key}) : super(key: key);

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  String _selectedDhikr = "SubhanAllah";
  List<Map<String, dynamic>> _history = []; // History List

  final List<String> _dhikrList = [
    "SubhanAllah",
    "Alhamdulillah",
    "Allahu Akbar",
    "La ilaha illallah",
    "Astaghfirullah",
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _saveToHistory() {
    if (_counter > 0) {
      _history.insert(0,
          {'dhikr': _selectedDhikr, 'count': _counter, 'time': DateTime.now()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kPrimary,
      appBar: AppBar(
        title: Text("Digital Tasbih",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header / Dhikr Selector
          Container(
            height: 160,
            decoration: BoxDecoration(
                color: Constants.kPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 5))
                ]),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/Tasbeeh.jpg',
                      fit: BoxFit.cover,
                      color: Constants.kPrimary.withOpacity(0.5),
                      colorBlendMode: BlendMode.overlay,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Select Dhikr",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Color(0xff004B40), // Dark Green
                            value: _selectedDhikr,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            onChanged: (String? newValue) {
                              setState(() {
                                // Save current session before switching
                                _saveToHistory();
                                _selectedDhikr = newValue!;
                                _counter = 0; // Reset
                              });
                            },
                            items: _dhikrList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  // Display Counter
                  Text(
                    "$_counter",
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Constants.kGold, // Changed to Gold
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Counts",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70, // Changed to white70
                    ),
                  ),
                  SizedBox(height: 30),

                  // Counter Button
                  GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Constants.kGold,
                            Color(0xffFFD700)
                          ], // Gold Gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Constants.kGold.withOpacity(0.4),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.touch_app,
                            color: Constants.kPrimary,
                            size: 70), // Icon is Green
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Reset Button Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          mini: true,
                          heroTag: "btn1",
                          onPressed: _resetCounter,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.refresh, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // History List
                  if (_history.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Recent Sessions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Constants.kGold,
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final item = _history[index];
                        return ListTile(
                          leading: Icon(Icons.history, color: Colors.white54),
                          title: Text(
                            item['dhikr'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text("Completed: ${item['count']} times",
                              style: TextStyle(color: Colors.white70)),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
