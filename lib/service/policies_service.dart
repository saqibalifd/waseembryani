import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/policies_model.dart';

class PoliciesService {
  final supabaseClient = Supabase.instance.client;
  Future<List<PoliciesModel>> fetchPolicies() async {
    try {
      final response = await supabaseClient.from('policies').select();
      return (response as List)
          .map((json) => PoliciesModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
