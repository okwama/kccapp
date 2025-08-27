import 'package:dio/dio.dart';
import '../models/notice.dart';

abstract class NoticesRemoteDataSource {
  Future<List<Notice>> getNotices({int? countryId});
  Future<Notice> getNoticeById(int id);
}

class NoticesRemoteDataSourceImpl implements NoticesRemoteDataSource {
  final Dio _dio;

  NoticesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Notice>> getNotices({int? countryId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (countryId != null) {
        queryParams['countryId'] = countryId;
      }

      final response = await _dio.get('/notices', queryParameters: queryParams);

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          // If API returns wrapped response with data property
          if (response.data.containsKey('data') &&
              response.data['data'] is List) {
            final noticesList = response.data['data'] as List;
            return noticesList
                .where((item) => item is Map<String, dynamic>)
                .map((noticeJson) =>
                    Notice.fromJson(noticeJson as Map<String, dynamic>))
                .toList();
          } else {
            // If API returns single object, wrap it in a list
            return [Notice.fromJson(response.data)];
          }
        } else if (response.data is List) {
          // If API returns direct array of notices
          final noticesList = response.data as List;
          return noticesList
              .where((item) => item is Map<String, dynamic>)
              .map((noticeJson) =>
                  Notice.fromJson(noticeJson as Map<String, dynamic>))
              .toList();
        } else {
          print('⚠️ Unexpected response format: ${response.data.runtimeType}');
          print('⚠️ Response data: ${response.data}');
          return []; // Return empty list instead of throwing
        }
      } else {
        throw Exception('Failed to load notices: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Network error in getNotices: $e');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Notice> getNoticeById(int id) async {
    try {
      final response = await _dio.get('/notices/$id');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          // If API returns wrapped response with data property
          if (response.data.containsKey('data')) {
            return Notice.fromJson(response.data['data']);
          } else {
            return Notice.fromJson(response.data);
          }
        } else {
          print(
              '⚠️ Unexpected response format for notice $id: ${response.data.runtimeType}');
          print('⚠️ Response data: ${response.data}');
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load notice: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Network error in getNoticeById: $e');
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
