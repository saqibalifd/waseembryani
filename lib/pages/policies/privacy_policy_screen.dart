import 'package:flutter/material.dart';
import 'package:waseembrayani/models/policies_model.dart';
import 'package:waseembrayani/service/policies_service.dart';

/// Privacy Policy Screen
/// - Fetches policies data from Supabase using PoliciesService
/// - Displays the privacy policy text dynamically
/// - Handles loading, error, and empty states
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  /// Step 1: Create instance of PoliciesService to fetch policies from backend
  final PoliciesService _policiesService = PoliciesService();

  /// Step 2: A Future that will hold list of PoliciesModel fetched from API
  /// Initialize with an empty list Future
  late Future<List<PoliciesModel>> futurePolicies = Future.value([]);

  @override
  void initState() {
    super.initState();

    /// Step 3: Call method to fetch policies when screen is initialized
    _intilizeData();
  }

  /// Step 4: Fetch data from PoliciesService and assign it to futurePolicies
  void _intilizeData() async {
    try {
      setState(() {
        // Assign fetched policies to futurePolicies
        futurePolicies = _policiesService.fetchPolicies();
      });
    } catch (e) {
      // Print error in case fetching fails
      print('error in intilizing data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Step 5: AppBar with centered title
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// Step 6: Body with scrollable content to handle long privacy policy text
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          /// Step 7: Use FutureBuilder to handle async data (loading, error, success)
          child: FutureBuilder(
            future: futurePolicies,
            builder: (context, snapshot) {
              /// Step 7.1: Show loading text while waiting for API response
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Loading...'));
              }

              /// Step 7.2: Show error if something went wrong
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              /// Step 7.3: Handle case when no data is found
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No found any privacy policy'));
              }

              /// Step 7.4: Show privacy policy text from first item
              return Text(snapshot.data!.first.privacyPolicy);
            },
          ),
        ),
      ),
    );
  }
}
