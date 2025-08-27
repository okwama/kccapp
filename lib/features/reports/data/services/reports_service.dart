import 'package:dio/dio.dart';
import '../models/feedback_report_model.dart';
import '../models/product_availability_report_model.dart';
import '../models/visibility_report_model.dart';
import '../models/show_of_shelf_report_model.dart';
import '../models/product_expiry_report_model.dart';

class ReportsService {
  final Dio _dio;

  ReportsService(this._dio);

  Future<Map<String, dynamic>> submitFeedbackReport(
      FeedbackReportModel report) async {
    try {
      final response = await _dio.post('/reports', data: {
        'type': 'FEEDBACK',
        'journeyPlanId': report.journeyPlanId,
        'clientId': report.clientId,
        'userId': report.userId,
        'comment': report.comment,
      });

      return response.data;
    } catch (e) {
      print('❌ Error submitting feedback report: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitProductAvailabilityReport(
      ProductAvailabilityReportModel report) async {
    try {
      final response = await _dio.post('/reports', data: {
        'type': 'PRODUCT_AVAILABILITY',
        'journeyPlanId': report.journeyPlanId,
        'clientId': report.clientId,
        'userId': report.userId,
        'productName': report.productName,
        'productId': report.productId,
        'quantity': report.quantity,
      });

      return response.data;
    } catch (e) {
      print('❌ Error submitting product availability report: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitVisibilityReport(
      VisibilityReportModel report) async {
    try {
      final response = await _dio.post('/reports', data: {
        'type': 'VISIBILITY_ACTIVITY',
        'journeyPlanId': report.journeyPlanId,
        'clientId': report.clientId,
        'userId': report.userId,
        'comment': report.comment,
        // TODO: Add photo upload when implemented
      });

      return response.data;
    } catch (e) {
      print('❌ Error submitting visibility report: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitShowOfShelfReport(
      ShowOfShelfReportModel report) async {
    try {
      final response = await _dio.post('/reports', data: {
        'type': 'SHOW_OF_SHELF',
        'journeyPlanId': report.journeyPlanId,
        'clientId': report.clientId,
        'userId': report.userId,
        'productName': report.productName,
        'productId': report.productId,
        'totalItemsOnShelf': report.totalItemsOnShelf,
        'companyItemsOnShelf': report.companyItemsOnShelf,
        'comments': report.comments,
      });

      return response.data;
    } catch (e) {
      print('❌ Error submitting show of shelf report: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitProductExpiryReport(
      ProductExpiryReportModel report) async {
    try {
      final response = await _dio.post('/reports', data: {
        'type': 'PRODUCT_EXPIRY',
        'journeyPlanId': report.journeyPlanId,
        'clientId': report.clientId,
        'userId': report.userId,
        'productName': report.productName,
        'productId': report.productId,
        'quantity': report.quantity,
        'expiryDate': report.expiryDate?.toIso8601String(),
        'batchNumber': report.batchNumber,
        'comments': report.comments,
      });

      return response.data;
    } catch (e) {
      print('❌ Error submitting product expiry report: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getReportsByJourneyPlan(
      int journeyPlanId) async {
    try {
      final response = await _dio.get('/reports/journey-plan/$journeyPlanId');
      return List<Map<String, dynamic>>.from(response.data['reports'] ?? []);
    } catch (e) {
      print('❌ Error fetching reports for journey plan: $e');
      return [];
    }
  }
}
