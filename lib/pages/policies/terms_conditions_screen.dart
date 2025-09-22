import 'package:flutter/material.dart';
import 'package:waseembrayani/models/policies_model.dart';
import 'package:waseembrayani/service/policies_service.dart';

/// Terms & Conditions Screen
/// - Fetches terms & conditions from backend (Supabase via PoliciesService)
/// - Displays the text dynamically
/// - Handles loading, error, and empty states
class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  /// Step 1: Create instance of PoliciesService to fetch policies
  final PoliciesService _policiesService = PoliciesService();

  /// Step 2: Define Future that holds list of PoliciesModel
  /// Initialize with an empty list future
  late Future<List<PoliciesModel>> futurePolicies = Future.value([]);

  @override
  void initState() {
    super.initState();

    /// Step 3: Fetch policies data on screen initialization
    _intilizeData();
  }

  /// Step 4: Assign fetched policies to futurePolicies
  void _intilizeData() async {
    try {
      setState(() {
        // Fetch policies (terms & conditions will be part of the response)
        futurePolicies = _policiesService.fetchPolicies();
      });
    } catch (e) {
      // Print error if something goes wrong
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
          "Terms & Conditions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// Step 6: Scrollable body to handle long terms text
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          /// Step 7: FutureBuilder to handle async data (loading/error/success)
          child: FutureBuilder(
            future: futurePolicies,
            builder: (context, snapshot) {
              /// Step 7.1: Show loading while waiting for response
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Loading...'));
              }

              /// Step 7.2: Handle error state
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              /// Step 7.3: Handle empty data
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No found any terms & condition'));
              }

              /// Step 7.4: Display terms & conditions text from first item
              return Text(snapshot.data!.first.termsConditions);
            },
          ),
        ),
      ),
    );
  }
}
