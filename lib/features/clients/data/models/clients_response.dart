import 'package:json_annotation/json_annotation.dart';
import 'client_model.dart';

part 'clients_response.g.dart';

@JsonSerializable()
class ClientsResponse {
  final List<ClientModel> data;
  final PaginationModel pagination;
  final bool success;

  const ClientsResponse({
    required this.data,
    required this.pagination,
    required this.success,
  });

  factory ClientsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return _$ClientsResponseFromJson(json);
    } catch (e) {
      // Handle missing or null fields gracefully
      return ClientsResponse(
        data: json['data'] is List
            ? (json['data'] as List)
                .where((item) => item is Map<String, dynamic>)
                .map((item) =>
                    ClientModel.fromJson(item as Map<String, dynamic>))
                .toList()
            : <ClientModel>[],
        pagination: json['pagination'] is Map<String, dynamic>
            ? PaginationModel.fromJson(
                json['pagination'] as Map<String, dynamic>)
            : const PaginationModel(
                total: 0, page: 1, limit: 20, totalPages: 0),
        success: json['success'] ?? false,
      );
    }
  }

  Map<String, dynamic> toJson() => _$ClientsResponseToJson(this);
}

@JsonSerializable()
class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$PaginationModelFromJson(json);
    } catch (e) {
      // Handle missing or null fields gracefully
      return PaginationModel(
        total: json['total'] ?? 0,
        page: json['page'] ?? 1,
        limit: json['limit'] ?? 20,
        totalPages: json['totalPages'] ?? 0,
      );
    }
  }

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
