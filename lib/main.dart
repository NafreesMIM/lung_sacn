import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lung_scan_new/screens/settings_screen.dart';
import 'dart:convert'; // For json.decode()
// import 'dart:io'; // Not used, can be removed if not needed elsewhere

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp ());
}

class MyApp  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LungScan+',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[800],
          elevation: 0,
        ),
      ),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }
          return HomeScreen();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Added const constructor

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Optionally, navigate to the login/welcome screen after signing out
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your login screen
      //   (Route<dynamic> route) => false,
      // );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully signed out.')),
        );
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LungScan+'), // Added const
        actions: [
          // Settings Icon Button - NEW
          IconButton(
            icon: const Icon(Icons.settings), // Added const
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()), // Added const
              );
            },
          ),
          // Logout Icon Button
          IconButton(
            icon: const Icon(Icons.logout), // Added const
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration( // Added const
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00695C), Color(0xFF00897B)],
          ),
        ),
        child: Column( // This is the main Column that holds the two Expanded sections
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'lung-icon',
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.health_and_safety, // Added const
                            size: 80, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30), // Added const
                    const Text( // Added const
                      'LungScan+',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10), // Added const
                    const Text( // Added const
                      'Lung Cancer Risk Assessment',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(30), // Added const
                decoration: const BoxDecoration( // Added const
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                // --- Start of Correction ---
                child: SingleChildScrollView( // Added SingleChildScrollView here
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Assess your lung health in minutes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20), // Added const
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AssessmentScreen()), // Added const
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700],
                          padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 18), // Added const
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Row( // Added const
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.medical_services, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Start Assessment',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Added const for spacing between button and icons

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.history, color: Colors.teal), // Added const
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HistoryScreen()), // Added const
                            ),
                          ),
                          const SizedBox(width: 20), // Added const
                          IconButton(
                            icon:
                            const Icon(Icons.info_outline, color: Colors.teal), // Added const
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AwarenessScreen()), // Added const
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ), // --- End of Correction ---
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key); // Added const constructor

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Assessment History'),
          backgroundColor: Colors.teal[700], // Themed app bar
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 20),
                const Text(
                  'Sign In to View History',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your assessment history will be saved here once you log in.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to sign-in screen or prompt user to sign in
                    // For this example, we'll just show a message.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please navigate to the login screen to sign in.')),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment History'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('assessments')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading history: ${snapshot.error}'));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    const Text('No assessment history yet!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 10),
                    const Text(
                      'Complete your first assessment to track your lung health over time.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AssessmentScreen()), // Use const
                      ),
                      icon: const Icon(Icons.add_chart),
                      label: const Text('Take Your First Assessment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final Timestamp? firebaseTimestamp = data['timestamp'] as Timestamp?;
              final timestamp = firebaseTimestamp?.toDate() ?? DateTime.now();
              final prediction = (data['prediction'] as num?)?.toDouble() ?? 0.0; // Handle potential null or int
              final riskCategory = data['riskCategory'] as String? ?? 'N/A';
              final score = (prediction * 100).toInt(); // Assuming prediction is 0-1, convert to 0-100 score

              Color riskColor = _getRiskColor(riskCategory);

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3, // Slightly more elevation for better visual
                child: InkWell( // Use InkWell for tap animation
                  onTap: () => _showHistoryDetails(context, data, timestamp),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: riskColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: riskColor, width: 2),
                          ),
                          child: Center(
                            child: Text(
                                score.toString(),
                                style: TextStyle(
                                    color: riskColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_formatDate(timestamp)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Risk Level: $riskCategory',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    // You could use DateFormat('dd/MM/yyyy').format(date) from intl package for more robust formatting.
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Color _getRiskColor(String riskCategory) {
    switch (riskCategory) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey; // Fallback color
    }
  }

  void _showHistoryDetails(BuildContext context, Map<String, dynamic> data, DateTime timestamp) {
    final prediction = (data['prediction'] as num?)?.toDouble() ?? 0.0;
    final riskCategory = data['riskCategory'] as String? ?? 'N/A';
    final formData = data['data'] as Map<String, dynamic>? ?? {}; // Handle null formData gracefully
    final score = (prediction * 100).toInt(); // Consistent 0-100 score
    Color riskColor = _getRiskColor(riskCategory);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the modal to take full height if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7, // Start at 70% of screen height
        minChildSize: 0.5,
        maxChildSize: 0.95, // Allow to expand almost full screen
        expand: false, // Do not expand to full height initially
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            // No fixed height here, DraggableScrollableSheet manages it
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  'Assessment Details (${_formatDate(timestamp)})',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildDetailCard('Risk Score', score.toString(), Icons.assessment, riskColor),
                    const SizedBox(width: 15),
                    _buildDetailCard('Risk Category', riskCategory, Icons.label, riskColor), // Changed icon for category
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Submitted Data', // More appropriate title than 'Key Factors'
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded( // This is the crucial fix for the overflow!
                  child: SingleChildScrollView( // Allow scrolling for the factor list
                    controller: scrollController, // Link to DraggableScrollableSheet's controller
                    child: Column( // Use Column to hold the list of factors
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // --- PASS CONTEXT HERE ---
                      children: _buildFactorList(context, formData),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700], // Themed button
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Close', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon, Color cardColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.1), // Use riskColor for cards
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: cardColor.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: cardColor),
            const SizedBox(height: 5),
            Text(title, style: TextStyle(color: cardColor, fontSize: 13)), // Smaller font for title
            const SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cardColor)),
          ],
        ),
      ),
    );
  }

  // --- MODIFIED SIGNATURE: Added BuildContext context ---
  List<Widget> _buildFactorList(BuildContext context, Map<String, dynamic> formData) {
    // Keys to exclude from the detailed list (already displayed or not relevant for factor breakdown)
    const List<String> excludedKeys = ['userId', 'timestamp', 'prediction', 'riskCategory', 'data'];

    List<Widget> factorWidgets = [];

    // Sort formData keys for consistent display
    List<String> sortedKeys = formData.keys.toList()..sort();

    for (var key in sortedKeys) {
      if (excludedKeys.contains(key)) {
        continue; // Skip excluded keys
      }

      final value = formData[key];
      final MapEntry<String, String> displayInfo = _getDisplayValueAndLabel(key, value);

      factorWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align to top for multi-line values
            children: [
              Icon(Icons.circle, size: 8, color: Colors.teal[400]), // Smaller, subtler circle
              const SizedBox(width: 10),
              Expanded( // Use Expanded to handle long text
                child: RichText(
                  text: TextSpan(
                    // --- USING PASSED CONTEXT HERE ---
                    style: DefaultTextStyle.of(context).style.copyWith(fontSize: 15), // Inherit default text style
                    children: [
                      TextSpan(
                        text: '${displayInfo.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: displayInfo.value,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return factorWidgets;
  }

  // Helper to format key names and values for display
  MapEntry<String, String> _getDisplayValueAndLabel(String key, dynamic value) {
    // Convert snake_case to Title Case
    String label = key.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return '';
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    }).join(' ');

    String displayValue;

    if (key == 'gender') {
      displayValue = value == 1 ? 'Male' : 'Female';
    } else if (key == 'age') {
      displayValue = value?.toString() ?? 'N/A'; // Age is just the number
    } else if (value is int) {
      // For integer values from sliders, display as 'Level X'
      displayValue = 'Level $value';
    } else if (value is bool) {
      displayValue = value ? 'Yes' : 'No';
    } else {
      displayValue = value?.toString() ?? 'N/A';
    }

    return MapEntry(label, displayValue);
  }
}


class ResultScreen extends StatelessWidget {
  final int riskScore;
  final String riskCategory;
  final Map<String, dynamic> formData;

  const ResultScreen({Key? key, required this.riskScore, required this.riskCategory, required this.formData}) : super(key: key);

  // Corrected _launchMaps function to use proper Google Maps URL
  Future<void> _launchMaps(String placeName, String address, BuildContext context) async {
    // Encode the place name and address for the URL query
    final query = Uri.encodeComponent('$placeName, $address');
    // Using a more generic Google Maps search URL
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';

    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch Google Maps for query: $query. URL: $url');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Google Maps.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching maps: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening Google Maps: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color riskColor = riskCategory == 'High' ? Colors.red : riskCategory == 'Medium' ? Colors.orange : Colors.green;

    // At the top of your file, make sure to import the share_plus package:
// ;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality here using share_plus package
              final String shareText = 'My lung cancer risk level is "$riskCategory" with an assessment score of $riskScore. You can also assess your risk with this app!';
              Share.share(shareText);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: riskColor, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your Risk Level', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                    const SizedBox(height: 10),
                    Text(riskCategory, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: riskColor)),
                    const SizedBox(height: 10),
                    Text('Score: $riskScore', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Risk Factors Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildRiskFactor(
                    'Age',
                    formData['age']?.toString() ?? 'N/A',
                    // Scale age from 0-120 for progress bar
                    (formData['age']?.toDouble() ?? 0) / 120.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Gender',
                    formData['gender'] == 0 ? 'Male' : 'Female',
                    0.0, // No progress for binary gender
                    showProgressBar: false,
                  ),
                  _buildRiskFactor(
                    'Air Pollution',
                    'Level ${formData['air_pollution']}',
                    // Scale from 1-10
                    ((formData['air_pollution']?.toDouble() ?? 1) - 1) / 9.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Alcohol Use',
                    'Level ${formData['alcohol_use']}',
                    // Scale from 1-10
                    ((formData['alcohol_use']?.toDouble() ?? 1) - 1) / 9.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Dust Allergy',
                    'Level ${formData['dust_allergy']}',
                    // Scale from 1-7
                    ((formData['dust_allergy']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Occupational Hazards',
                    'Level ${formData['occupational_hazards']}',
                    // Scale from 1-7
                    ((formData['occupational_hazards']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Genetic Risk',
                    'Level ${formData['genetic_risk']}',
                    // Scale from 1-7
                    ((formData['genetic_risk']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Chronic Lung Disease',
                    'Level ${formData['chronic_lung_disease']}',
                    // Scale from 1-7
                    ((formData['chronic_lung_disease']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Balanced Diet',
                    'Level ${formData['balanced_diet']}',
                    // Scale from 1-7
                    ((formData['balanced_diet']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Obesity',
                    'Level ${formData['obesity']}',
                    // Scale from 1-7
                    ((formData['obesity']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Smoking',
                    'Level ${formData['smoking']}',
                    // Scale from 1-8
                    ((formData['smoking']?.toDouble() ?? 1) - 1) / 7.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Passive Smoker',
                    'Level ${formData['passive_smoker']}',
                    // Scale from 1-8
                    ((formData['passive_smoker']?.toDouble() ?? 1) - 1) / 7.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Chest Pain',
                    'Level ${formData['chest_pain']}',
                    // Scale from 1-7
                    ((formData['chest_pain']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Coughing of Blood',
                    'Level ${formData['coughing_of_blood']}',
                    // Scale from 1-9
                    ((formData['coughing_of_blood']?.toDouble() ?? 1) - 1) / 8.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Fatigue',
                    'Level ${formData['fatigue']}',
                    // Scale from 1-8
                    ((formData['fatigue']?.toDouble() ?? 1) - 1) / 7.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Weight Loss',
                    'Level ${formData['weight_loss']}',
                    // Scale from 1-7
                    ((formData['weight_loss']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Shortness of Breath',
                    'Level ${formData['shortness_of_breath']}',
                    // Scale from 1-9
                    ((formData['shortness_of_breath']?.toDouble() ?? 1) - 1) / 8.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Wheezing',
                    'Level ${formData['wheezing']}',
                    // Scale from 1-8
                    ((formData['wheezing']?.toDouble() ?? 1) - 1) / 7.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Swallowing Difficulty',
                    'Level ${formData['swallowing_difficulty']}',
                    // Scale from 1-6
                    ((formData['swallowing_difficulty']?.toDouble() ?? 1) - 1) / 5.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Clubbing of Finger Nails',
                    'Level ${formData['clubbing_of_finger_nails']}',
                    // Scale from 1-6
                    ((formData['clubbing_of_finger_nails']?.toDouble() ?? 1) - 1) / 5.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Frequent Cold',
                    'Level ${formData['frequent_cold']}',
                    // Scale from 1-7
                    ((formData['frequent_cold']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Dry Cough',
                    'Level ${formData['dry_cough']}',
                    // Scale from 1-7
                    ((formData['dry_cough']?.toDouble() ?? 1) - 1) / 6.0,
                    showProgressBar: true,
                  ),
                  _buildRiskFactor(
                    'Snoring',
                    'Level ${formData['snoring']}',
                    // Scale from 1-6
                    ((formData['snoring']?.toDouble() ?? 1) - 1) / 5.0,
                    showProgressBar: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Recommendations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ..._buildRecommendations(),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showNearbyFacilities(context),
                icon: const Icon(Icons.local_hospital),
                label: const Text('Find Nearby Health Facilities'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskFactor(String name, String value, double progressValue, {bool showProgressBar = true}) {
    // Determine color based on progress value. Higher value, more red/orange.
    Color color = Colors.green; // Default to green
    if (showProgressBar) {
      if (progressValue > 0.7) {
        color = Colors.red;
      } else if (progressValue > 0.4) {
        color = Colors.orange;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 8),
          if (showProgressBar) // Conditionally show progress bar
            LinearProgressIndicator(
              value: progressValue.clamp(0.0, 1.0), // Ensure value is between 0.0 and 1.0
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRecommendations() {
    List<Map<String, dynamic>> recommendations = [];

    if (riskCategory == 'High') {
      recommendations = [
        {'icon': Icons.medical_services, 'text': 'Consult a pulmonologist immediately'},
        {'icon': Icons.scanner, 'text': 'Schedule a low-dose CT scan'},
        {'icon': Icons.smoke_free, 'text': 'Quit smoking and avoid pollutants'},
        {'icon': Icons.monitor_heart, 'text': 'Monitor symptoms daily'},
      ];
    } else if (riskCategory == 'Medium') {
      recommendations = [
        {'icon': Icons.calendar_today, 'text': 'Get annual lung health checkups'},
        {'icon': Icons.air, 'text': 'Reduce exposure to air pollutants'},
        {'icon': Icons.assignment, 'text': 'Monitor symptoms regularly'},
        {'icon': Icons.warning, 'text': 'Be aware of any changes in symptoms'},
      ];
    } else {
      recommendations = [
        {'icon': Icons.fitness_center, 'text': 'Maintain healthy lifestyle'},
        {'icon': Icons.smoking_rooms, 'text': 'Avoid smoking and secondhand smoke'},
        {'icon': Icons.directions_run, 'text': 'Get regular exercise'},
        {'icon': Icons.nature_people, 'text': 'Spend time in clean air environments'},
      ];
    }

    return recommendations
        .map((item) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(item['icon'], color: Colors.teal[700]),
            const SizedBox(width: 15),
            Expanded(child: Text(item['text'], style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    ))
        .toList();
  }

  Future<void> _showNearbyFacilities(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled. Please enable them in settings.')),
        );
      }
      return;
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied. Please grant permission to find nearby facilities.')),
          );
        }
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied. Please enable them from app settings.')),
        );
      }
      return;
    }

    // Show loading indicator
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // DEBUG PRINT: User's current location
      debugPrint('User Current Location: Lat=${position.latitude}, Lng=${position.longitude}');
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
      return;
    }

    try {
      // --- SECURITY ALERT: API Key is exposed here! ---
      // For production, never hardcode your API key directly in client-side code.
      // Use a backend proxy or environment variables (with awareness of limitations).
      // The API key below is a placeholder and WILL NOT WORK.
      const apiKey = 'AIzaSyCXhCmNigBHqtdbglczrVi8xC-QcJce-9M'; // Replace with your ACTUAL API key
      const radius = 5000; // 5 km radius
      const type = 'hospital'; // Search for hospitals

      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
              'location=${position.latitude},${position.longitude}'
              '&radius=$radius'
              '&type=$type'
              '&key=$apiKey',
        ),
      );

      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Take up to 3 results to display
        final places = data['results'].take(3).toList();

        if (places.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No nearby health facilities found.')),
            );
          }
          return;
        }

        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) => Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    'Nearby Health Facilities',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Based on your current location',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      // FIX: Explicitly cast the mapped list to List<Widget>
                      children: places.map<Widget>((place) {
                        final facilityLat = place['geometry']['location']['lat'];
                        final facilityLng = place['geometry']['location']['lng'];
                        // DEBUG PRINT: Facility Location
                        debugPrint('Facility: ${place['name']} - Lat=$facilityLat, Lng=$facilityLng');

                        return _buildFacilityCard(
                          place['name'] ?? 'Unknown Facility',
                          _calculateDistance(
                            position.latitude,
                            position.longitude,
                            facilityLat,
                            facilityLng,
                          ),
                          place['vicinity'] ?? 'No address provided',
                          Icons.local_hospital,
                          context,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Close', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        throw Exception('Failed to load places: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching nearby facilities: $e')),
        );
      }
    }
  }

  String _calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLat, startLng, endLat, endLng,
    );
    // DEBUG PRINT: Raw distance calculation
    debugPrint('Calculating distance from ($startLat, $startLng) to ($endLat, $endLng)');
    debugPrint('Raw Distance in Meters: $distanceInMeters');

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} meters away';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km away';
    }
  }

  Widget _buildFacilityCard(String name, String distance, String details, IconData icon, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.teal[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.teal[700]),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(distance, style: TextStyle(color: Colors.teal[700])),
            const SizedBox(height: 5),
            Text(details, style: const TextStyle(fontSize: 14)),
          ],
        ),
        trailing: const Icon(Icons.directions, color: Colors.teal),
        onTap: () => _launchMaps(name, details, context),
      ),
    );
  }
}

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'age': null,
    'gender': 1, // 1 for Male, 2 for Female as per dataset
    'air_pollution': 1, // Default to min value from dataset range (1-10)
    'alcohol_use': 1, // Default to min value from dataset range (1-10)
    'dust_allergy': 1, // Now a slider, default to min value (1-7)
    'occupational_hazards': 1, // Now a slider, default to min value (1-7)
    'genetic_risk': 1, // Default to min value from dataset range (1-7)
    'chronic_lung_disease': 1, // Now a slider, default to min value (1-7)
    'balanced_diet': 1, // Default to min value from dataset range (1-7)
    'obesity': 1, // Default to min value from dataset range (1-7)
    'smoking': 1, // Now a slider, default to min value (1-8)
    'passive_smoker': 1, // Now a slider, default to min value (1-8)
    'chest_pain': 1, // Now a slider, default to min value (1-7)
    'coughing_of_blood': 1, // Now a slider, default to min value (1-9)
    'fatigue': 1, // Now a slider, default to min value (1-8)
    'weight_loss': 1, // Now a slider, default to min value (1-7)
    'shortness_of_breath': 1, // Now a slider, default to min value (1-9)
    'wheezing': 1, // Now a slider, default to min value (1-8)
    'swallowing_difficulty': 1, // Now a slider, default to min value (1-6)
    'clubbing_of_finger_nails': 1, // Now a slider, default to min value (1-6)
    'frequent_cold': 1, // Now a slider, default to min value (1-7)
    'dry_cough': 1, // Now a slider, default to min value (1-7)
    'snoring': 1, // Now a slider, default to min value (1-6)
  };

  int _currentStep = 0;
  final List<String> _genderOptions = ['Male', 'Female'];

  Interpreter? _interpreter; // TFLite model interpreter
  Map<String, dynamic>? _preprocessingInfo; // To store scaler means/stds and feature order

  @override
  void initState() {
    super.initState();
    _loadModelAndPreprocessingInfo();
  }

  @override
  void dispose() {
    _interpreter?.close(); // Close the interpreter when done
    super.dispose();
  }

  Future<void> _loadModelAndPreprocessingInfo() async {
    try {
      // Load TFLite model
      _interpreter = await Interpreter.fromAsset('assets/model/logistic_regression_model.tflite');
      debugPrint('Model loaded successfully!');

      // Load preprocessing info JSON
      final String jsonString = await rootBundle.loadString('assets/model/preprocessing_info.json');
      _preprocessingInfo = json.decode(jsonString);
      debugPrint('Preprocessing info loaded successfully!');
      // debugPrint('Preprocessing Info: $_preprocessingInfo'); // Uncomment to see loaded info for debugging

    } catch (e) {
      debugPrint('Failed to load model or preprocessing info: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading ML model or preprocessing info: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.teal[700]!,
          ),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            // Validate the current step's form before moving on
            if (_currentStep == 0 && !_formKey.currentState!.validate()) {
              return; // Stay on the current step if validation fails
            }
            if (_currentStep < 3) {
              setState(() => _currentStep += 1);
            } else {
              _submitForm(); // Submit form on the last step
            }
          },
          onStepCancel: () => setState(() => _currentStep = _currentStep > 0 ? _currentStep - 1 : 0),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep != 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Colors.teal),
                        ),
                        child: const Text('Back', style: TextStyle(color: Colors.teal)),
                      ),
                    ),
                  SizedBox(width: _currentStep != 0 ? 20 : 0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        _currentStep == 3 ? 'Submit' : 'Next',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Basic Information', style: TextStyle(fontSize: 18)),
              content: _buildBasicInfoStep(),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Health Factors', style: TextStyle(fontSize: 18)),
              content: _buildHealthFactorsStep(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Symptoms', style: TextStyle(fontSize: 18)),
              content: _buildSymptomsStep(),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Lifestyle', style: TextStyle(fontSize: 18)),
              content: _buildLifestyleStep(),
              isActive: _currentStep >= 3,
              state: _currentStep == 3 ? StepState.editing : StepState.indexed, // Set to editing for the current step
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Age', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter your age',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number, // Ensure numeric keyboard
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Age is required';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0 || int.parse(value) > 120) {
                // Assuming a reasonable max age for validation
                return 'Please enter a valid positive age (e.g., 1-120)';
              }
              return null;
            },
            onSaved: (value) => _formData['age'] = int.parse(value!), // Save as int
            initialValue: _formData['age']?.toString(), // Display current value if any
          ),
          const SizedBox(height: 25),
          const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
            ),
            value: _formData['gender'],
            items: _genderOptions.asMap().entries.map((entry) {
              int idx = entry.key;
              String gender = entry.value;
              return DropdownMenuItem<int>(
                value: idx + 1, // Map 'Male' to 1, 'Female' to 2 (consistent with dataset)
                child: Text(gender),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _formData['gender'] = newValue!; // Save selected int value
              });
            },
          ),
          const SizedBox(height: 25),
          const Text('Genetic Risk (1-7)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Slider(
            value: _formData['genetic_risk'].toDouble(),
            min: 1,
            max: 7,
            divisions: 6, // (max - min) for total divisions
            label: _formData['genetic_risk'].toString(),
            activeColor: Colors.teal,
            inactiveColor: Colors.teal[100],
            onChanged: (value) => setState(() => _formData['genetic_risk'] = value.toInt()), // Save as int
          ),
        ],
      ),
    );
  }

  Widget _buildHealthFactorsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chronic Conditions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              const Text('Chronic Lung Disease (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['chronic_lung_disease'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['chronic_lung_disease'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['chronic_lung_disease'] = value.toInt()),
              ),
              const Divider(),
              const Text('Obesity (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['obesity'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['obesity'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['obesity'] = value.toInt()), // Save as int
              ),
              const Divider(),
              const Text('Balanced Diet (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['balanced_diet'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['balanced_diet'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['balanced_diet'] = value.toInt()), // Save as int
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text('Exposure Risks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              const Text('Smoking (1-8)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['smoking'].toDouble(),
                min: 1,
                max: 8,
                divisions: 7,
                label: _formData['smoking'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['smoking'] = value.toInt()),
              ),
              const Divider(),
              const Text('Passive Smoker (1-8)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['passive_smoker'].toDouble(),
                min: 1,
                max: 8,
                divisions: 7,
                label: _formData['passive_smoker'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['passive_smoker'] = value.toInt()),
              ),
              const Divider(),
              const Text('Dust Allergy (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['dust_allergy'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['dust_allergy'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['dust_allergy'] = value.toInt()),
              ),
              const Divider(),
              const Text('Occupational Hazards (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['occupational_hazards'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['occupational_hazards'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['occupational_hazards'] = value.toInt()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Respiratory Symptoms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              const Text('Chest Pain (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['chest_pain'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['chest_pain'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['chest_pain'] = value.toInt()),
              ),
              const Divider(),
              const Text('Coughing of Blood (1-9)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['coughing_of_blood'].toDouble(),
                min: 1,
                max: 9,
                divisions: 8,
                label: _formData['coughing_of_blood'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['coughing_of_blood'] = value.toInt()),
              ),
              const Divider(),
              const Text('Shortness of Breath (1-9)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['shortness_of_breath'].toDouble(),
                min: 1,
                max: 9,
                divisions: 8,
                label: _formData['shortness_of_breath'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['shortness_of_breath'] = value.toInt()),
              ),
              const Divider(),
              const Text('Wheezing (1-8)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['wheezing'].toDouble(),
                min: 1,
                max: 8,
                divisions: 7,
                label: _formData['wheezing'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['wheezing'] = value.toInt()),
              ),
              const Divider(),
              const Text('Dry Cough (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['dry_cough'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['dry_cough'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['dry_cough'] = value.toInt()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text('Other Symptoms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              const Text('Fatigue (1-8)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['fatigue'].toDouble(),
                min: 1,
                max: 8,
                divisions: 7,
                label: _formData['fatigue'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['fatigue'] = value.toInt()),
              ),
              const Divider(),
              const Text('Weight Loss (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['weight_loss'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['weight_loss'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['weight_loss'] = value.toInt()),
              ),
              const Divider(),
              const Text('Swallowing Difficulty (1-6)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['swallowing_difficulty'].toDouble(),
                min: 1,
                max: 6,
                divisions: 5,
                label: _formData['swallowing_difficulty'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['swallowing_difficulty'] = value.toInt()),
              ),
              const Divider(),
              const Text('Clubbing of Finger Nails (1-6)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['clubbing_of_finger_nails'].toDouble(),
                min: 1,
                max: 6,
                divisions: 5,
                label: _formData['clubbing_of_finger_nails'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['clubbing_of_finger_nails'] = value.toInt()),
              ),
              const Divider(),
              const Text('Frequent Cold (1-7)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['frequent_cold'].toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _formData['frequent_cold'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['frequent_cold'] = value.toInt()),
              ),
              const Divider(),
              const Text('Snoring (1-6)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['snoring'].toDouble(),
                min: 1,
                max: 6,
                divisions: 5,
                label: _formData['snoring'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['snoring'] = value.toInt()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLifestyleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Environmental Factors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              const Text('Air Pollution Level (1-10)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['air_pollution'].toDouble(),
                min: 1,
                max: 10,
                divisions: 9, // (max - min) for total divisions
                label: _formData['air_pollution'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['air_pollution'] = value.toInt()), // Save as int
              ),
              const Divider(),
              const Text('Alcohol Use (1-10)', style: TextStyle(fontSize: 16)),
              Slider(
                value: _formData['alcohol_use'].toDouble(),
                min: 1,
                max: 10,
                divisions: 9, // (max - min) for total divisions
                label: _formData['alcohol_use'].toString(),
                activeColor: Colors.teal,
                inactiveColor: Colors.teal[100],
                onChanged: (value) => setState(() => _formData['alcohol_use'] = value.toInt()), // Save as int
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form data, triggering onSaved callbacks

      if (_interpreter == null || _preprocessingInfo == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ML model or preprocessing info not loaded. Please restart the app.')),
          );
        }
        return;
      }

      // Show loading indicator while predicting
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      }

      try {
        // Retrieve preprocessing info from the loaded JSON
        final List<String> featureOrder = List<String>.from(_preprocessingInfo!['feature_order']);
        final List<double> scalerMean = List<double>.from(_preprocessingInfo!['scaler_mean']);
        final List<double> scalerStd = List<double>.from(_preprocessingInfo!['scaler_std']);
        final Map<String, dynamic> intToLevelMapping = _preprocessingInfo!['int_to_level_mapping'];

        // Prepare input data according to feature_order and apply scaling
        final List<double> inputFeatures = [];
        for (int i = 0; i < featureOrder.length; i++) {
          final String featureName = featureOrder[i];
          double value;

          // Special handling for 'gender' based on assumed Python preprocessing
          // If 'gender' was mapped 1 (Male) -> 1.0, 2 (Female) -> 0.0 in Python.
          if (featureName.toLowerCase() == 'gender') {
            value = (_formData[featureName.toLowerCase()] == 1 ? 1.0 : 0.0); // If 1 (Male) -> 1.0, else 0.0
          } else {
            // Ensure the value is converted to double for consistent scaling
            if (_formData[featureName.toLowerCase()] is int) {
              value = (_formData[featureName.toLowerCase()] as int).toDouble();
            } else if (_formData[featureName.toLowerCase()] is double) {
              value = _formData[featureName.toLowerCase()] as double;
            } else {
              debugPrint('Warning: Unexpected type for feature $featureName: ${_formData[featureName.toLowerCase()].runtimeType}');
              value = 0.0; // Default or handle as appropriate for unexpected types
            }
          }

          // Apply StandardScaler transformation: (value - mean) / std
          // Handle potential division by zero for features with std of 0 (constant features)
          final double scaledValue = scalerStd[i] != 0 ? (value - scalerMean[i]) / scalerStd[i] : 0.0;
          inputFeatures.add(scaledValue);
        }

        // Ensure input is a List of Lists (batch size 1) as expected by TFLite interpreter
        final input = [inputFeatures];

        // Output tensor will hold the prediction probabilities for each class
        // Assuming 3 classes: Low, Medium, High. Shape will be [1, 3]
        final output = List<double>.filled(3, 0).reshape([1, 3]);

        // Run inference
        _interpreter!.run(input, output);

        if (mounted) {
          Navigator.pop(context); // Dismiss loading dialog after inference
        }

        final List<double> probabilities = output[0]; // Get the list of probabilities (e.g., [prob_low, prob_medium, prob_high])

        // Find the index of the maximum probability, which corresponds to the predicted class
        int predictedIndex = 0;
        double maxProbability = probabilities[0];
        for (int i = 1; i < probabilities.length; i++) {
          if (probabilities[i] > maxProbability) {
            maxProbability = probabilities[i];
            predictedIndex = i;
          }
        }

        // Get the predicted risk category using the stored mapping (e.g., "0":"Low", "1":"Medium", "2":"High")
        final String calculatedRiskCategory = intToLevelMapping[predictedIndex.toString()];

        // Calculate a simple risk score based on the highest probability (0-100)
        int calculatedRiskScore = (maxProbability * 100).toInt();

        // --- Firebase Firestore Saving ---
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('assessments').add({
            'userId': user.uid,
            'timestamp': FieldValue.serverTimestamp(), // Use Firestore's server timestamp for accuracy
            'prediction': maxProbability, // Store the raw probability
            'riskCategory': calculatedRiskCategory,
            'data': _formData, // Store the entire form data for detailed history/analysis
          });
          debugPrint('Assessment data saved to Firestore successfully!');
        } else {
          debugPrint('User not signed in, cannot save assessment to Firestore.');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please sign in to save assessment history.')),
            );
          }
        }
        // --- End of Firestore Saving ---

        // Navigate to the ResultScreen with the calculated risk details
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                riskScore: calculatedRiskScore,
                riskCategory: calculatedRiskCategory,
                formData: _formData, // Pass the original form data to ResultScreen if needed
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Dismiss loading dialog on error
          debugPrint('Error running inference or saving to Firestore: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error predicting risk or saving history: $e')),
          );
        }
      }
    }
  }
}


class AwarenessScreen extends StatefulWidget {
  const AwarenessScreen({super.key});

  @override
  State<AwarenessScreen> createState() => _AwarenessScreenState();
}

class _AwarenessScreenState extends State<AwarenessScreen> {
  final List<Map<String, dynamic>> facts = [
    {
      'title': 'Early Detection',
      'content': 'The 5-year survival rate for lung cancer is 56% when detected at an early stage compared to only 5% when diagnosed at a late stage. Early detection through screening can save lives.',
      'icon': Icons.visibility,
      'color': Colors.blue
    },
    {
      'title': 'Smoking Risks',
      'content': 'Smoking causes about 80-90% of lung cancer deaths. Even light smoking or exposure to secondhand smoke increases risk. Quitting at any age can significantly lower your risk.',
      'icon': Icons.smoking_rooms,
      'color': Colors.red
    },
    {
      'title': 'Radon Exposure',
      'content': 'Radon gas is the second leading cause of lung cancer after smoking. It\'s an invisible, odorless, radioactive gas that comes from the natural decay of uranium in soil. Testing your home for radon can help prevent exposure.',
      'icon': Icons.home,
      'color': Colors.orange
    },
    {
      'title': 'Screening Benefits',
      'content': 'Annual low-dose CT scans are recommended for high-risk individuals (e.g., heavy smokers) and can reduce lung cancer deaths by 20%. Discuss with your doctor if you qualify for screening.',
      'icon': Icons.medical_services,
      'color': Colors.green
    },
    {
      'title': 'Environmental Factors',
      'content': 'Exposure to asbestos, arsenic, chromium, and nickel in the workplace can increase lung cancer risk. Minimize exposure and use protective gear when necessary.',
      'icon': Icons.factory,
      'color': Colors.purple
    },
    {
      'title': 'Family History',
      'content': 'While not a direct cause, having a close relative (parent, sibling, child) who had lung cancer may increase your risk, even if you don\'t smoke.',
      'icon': Icons.family_restroom,
      'color': Colors.brown
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prevention & Awareness'),
        backgroundColor: Colors.teal[700], // Themed app bar
        foregroundColor: Colors.white, // White text on dark app bar
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Lung Cancer Facts',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal), // Enhanced style
          ),
          const SizedBox(height: 8), // Adjusted spacing
          Text(
            'Knowledge is your first defense against lung cancer',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]), // Slightly darker grey
          ),
          const SizedBox(height: 25), // Adjusted spacing
          ...facts.map((fact) => _buildFactCard(fact)).toList(),
          const SizedBox(height: 30),
          const Text(
            'Prevention Strategies',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal), // Enhanced style
          ),
          const SizedBox(height: 15),
          _buildPreventionSection(),
        ],
      ),
    );
  }

  Widget _buildFactCard(Map<String, dynamic> fact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5, // Increased elevation for a more prominent card
      child: Padding(
        padding: const EdgeInsets.all(18), // Slightly more padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 55, // Slightly larger icon container
                  height: 55,
                  decoration: BoxDecoration(
                    color: fact['color'].withOpacity(0.15), // Softer background
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(fact['icon'] as IconData,
                        color: fact['color'], size: 30), // Slightly larger icon
                  ),
                ),
                const SizedBox(width: 18), // Adjusted spacing
                Expanded( // Ensures title doesn't overflow
                  child: Text(
                    fact['title'],
                    style: const TextStyle(
                        fontSize: 20, // Slightly larger title
                        fontWeight: FontWeight.bold,
                        color: Colors.black87), // Darker text for better contrast
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              fact['content'],
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[800]), // Improved line height and color
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreventionTip(String text, IconData icon) {
    return Container(
      // The width is kept at 150 as it's designed for the Wrap layout
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal[200]!), // Slightly darker border
        boxShadow: [ // Added a subtle shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensure Row takes minimum space
        children: [
          Icon(icon, color: Colors.teal[700], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87), // Darker text
              overflow: TextOverflow.ellipsis, // Add ellipsis for long text if it still overflows (unlikely with Expanded)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreventionSection() {
    return Container(
      padding: const EdgeInsets.all(20), // More padding
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.teal[100]!), // Added a subtle border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reduce Your Risk',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]), // Larger, bolder
          ),
          const SizedBox(height: 18), // Adjusted spacing
          Wrap(
            spacing: 12, // Slightly increased spacing
            runSpacing: 18, // Slightly increased run spacing
            children: [
              _buildPreventionTip('Quit smoking', Icons.smoke_free),
              _buildPreventionTip('Test for radon', Icons.home),
              _buildPreventionTip('Avoid pollutants', Icons.air),
              _buildPreventionTip('Healthy diet', Icons.food_bank),
              _buildPreventionTip('Exercise regularly', Icons.directions_run),
              _buildPreventionTip('Protect at work', Icons.work),
              _buildPreventionTip('Regular checkups', Icons.medical_services),
              _buildPreventionTip('Limit alcohol', Icons.local_drink),
              _buildPreventionTip('Vaccination', Icons.vaccines), // Added more tips
              _buildPreventionTip('Know your family history', Icons.people),
            ],
          ),
          const SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // Construct a URL to open Google Maps searching for nearby hospitals/health centers
                final Uri url = Uri.parse('http://googleusercontent.com/maps.google.com/maps/search/hospitals+near+me');

                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch map application.')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white, // White text on teal button
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly less rounded corners
                elevation: 3, // Added elevation
              ),
              child: const Text('Find Nearby Centers', style: TextStyle(fontSize: 16)), // Adjusted font size
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    }
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00695C), Color(0xFF00897B)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'lung-icon',
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.health_and_safety,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'LungScan+',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _signIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () => _signUp(context),
                  child: Text(
                    'Create Account',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}