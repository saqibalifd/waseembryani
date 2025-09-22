import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/models/policies_model.dart';

class PoliciesService {
  // Create a Supabase client instance for querying the database
  final supabaseClient = Supabase.instance.client;

  // ========================= FETCH POLICIES =========================
  // Function to fetch all policies from 'policies' table in Supabase
  Future<List<PoliciesModel>> fetchPolicies() async {
    try {
      // Step 1: Query Supabase 'policies' table and fetch all rows
      final response = await supabaseClient.from('policies').select();

      // Step 2: Convert the fetched data (List of JSON maps) into List<PoliciesModel>
      return (response as List)
          .map((json) => PoliciesModel.fromJson(json)) // map JSON → model
          .toList(); // return as list of models
    } catch (e) {
      // Step 3: On any error, return empty list instead of crashing
      return [];
    }
  }
}
