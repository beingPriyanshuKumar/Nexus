import '../api/api_service.dart';
import '../models/club_model.dart';

class ClubsRepository {
  final ApiService _api = ApiService();

  /// Fetch all clubs from the API
  Future<List<ClubModel>> getClubs() async {
    try {
      final res = await _api.getClubs();
      if (res.data is List) {
        return (res.data as List)
            .map((json) => ClubModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('[ClubsRepo] Error fetching clubs: $e');
      return [];
    }
  }
}
