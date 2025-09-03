import '../datasources/notices_remote_data_source.dart';
import '../models/notice.dart';

abstract class NoticesRepository {
  Future<List<Notice>> getNotices({int? countryId});
  Future<Notice> getNoticeById(int id);
}

class NoticesRepositoryImpl implements NoticesRepository {
  final NoticesRemoteDataSource _remoteDataSource;

  NoticesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Notice>> getNotices({int? countryId}) async {
    try {
      return await _remoteDataSource.getNotices(countryId: countryId);
    } catch (e) {
      throw Exception('Failed to get notices: $e');
    }
  }

  @override
  Future<Notice> getNoticeById(int id) async {
    try {
      return await _remoteDataSource.getNoticeById(id);
    } catch (e) {
      throw Exception('Failed to get notice: $e');
    }
  }
}

