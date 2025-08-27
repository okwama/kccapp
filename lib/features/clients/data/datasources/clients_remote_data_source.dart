import 'package:dio/dio.dart';
import '../models/client_model.dart';
import '../models/clients_response.dart';

// Helper function to safely parse client data
ClientModel _safeParseClient(Map<String, dynamic> json) {
  try {
    return ClientModel.fromJson(json);
  } catch (e) {
    print('⚠️ Client parsing error: $e');
    print('⚠️ Problematic JSON: $json');

    // If parsing fails, try to create with default values for required fields
    return ClientModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? 'Unknown Client',
      address: json['address']?.toString(),
      latitude:
          json['latitude'] is num ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : null,
      balance:
          json['balance'] is num ? (json['balance'] as num).toDouble() : 0.0,
      email: json['email']?.toString(),
      regionId: json['region_id'] ?? json['regionId'] ?? 1,
      region: json['region']?.toString() ?? 'Unknown Region',
      routeId: json['route_id'] ?? json['routeId'],
      routeName:
          json['route_name']?.toString() ?? json['routeName']?.toString(),
      contact: json['contact']?.toString(),
      taxPin: json['tax_pin']?.toString() ?? json['taxPin']?.toString(),
      location: json['location']?.toString(),
      status: json['status'] ?? 1,
      clientType: json['client_type'] ?? json['clientType'],
      outletAccount: json['outlet_account'] ?? json['outletAccount'],
      countryId: json['countryId'] ?? 1,
      addedBy: json['added_by'] ?? json['addedBy'],
      addedByUser: null, // Skip complex object parsing for now
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

abstract class ClientsRemoteDataSource {
  Future<List<ClientModel>> getClients({
    int page = 1,
    int limit = 20,
    String? search,
    int? regionId,
    int? routeId,
  });

  Future<ClientModel> getClient(int id);
  Future<List<ClientModel>> searchClients(String query);
  Future<List<ClientModel>> getClientsByRoute(int routeId);
  Future<List<ClientModel>> getClientsByRegion(int regionId);
}

class ClientsRemoteDataSourceImpl implements ClientsRemoteDataSource {
  final Dio _dio;

  ClientsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ClientModel>> getClients({
    int page = 1,
    int limit = 20,
    String? search,
    int? regionId,
    int? routeId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (regionId != null) {
        queryParams['regionId'] = regionId;
      }

      if (routeId != null) {
        queryParams['routeId'] = routeId;
      }

      final response = await _dio.get(
        '/clients',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          // If API returns wrapped response with pagination
          final clientsResponse = ClientsResponse.fromJson(response.data);
          return clientsResponse.data;
        } else if (response.data is List) {
          // If API returns direct array of clients
          final clientsList = response.data as List;
          return clientsList
              .where((item) => item is Map<String, dynamic>)
              .map((clientJson) =>
                  _safeParseClient(clientJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  @override
  Future<ClientModel> getClient(int id) async {
    try {
      final response = await _dio.get('/clients/$id');

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          // If API returns wrapped response
          if (response.data.containsKey('data')) {
            return _safeParseClient(response.data['data']);
          } else {
            return _safeParseClient(response.data);
          }
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load client');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  @override
  Future<List<ClientModel>> searchClients(String query) async {
    try {
      final response = await _dio.get(
        '/clients/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          // If API returns wrapped response with pagination
          final clientsResponse = ClientsResponse.fromJson(response.data);
          return clientsResponse.data;
        } else if (response.data is List) {
          // If API returns direct array of clients
          final clientsList = response.data as List;
          return clientsList
              .where((item) => item is Map<String, dynamic>)
              .map((clientJson) =>
                  _safeParseClient(clientJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to search clients');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  @override
  Future<List<ClientModel>> getClientsByRoute(int routeId) async {
    try {
      final response = await _dio.get('/clients/route/$routeId');

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          // If API returns wrapped response with pagination
          final clientsResponse = ClientsResponse.fromJson(response.data);
          return clientsResponse.data;
        } else if (response.data is List) {
          // If API returns direct array of clients
          final clientsList = response.data as List;
          return clientsList
              .where((item) => item is Map<String, dynamic>)
              .map((clientJson) =>
                  _safeParseClient(clientJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load clients by route');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  @override
  Future<List<ClientModel>> getClientsByRegion(int regionId) async {
    try {
      final response = await _dio.get('/clients/region/$regionId');

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          // If API returns wrapped response with pagination
          final clientsResponse = ClientsResponse.fromJson(response.data);
          return clientsResponse.data;
        } else if (response.data is List) {
          // If API returns direct array of clients
          final clientsList = response.data as List;
          return clientsList
              .where((item) => item is Map<String, dynamic>)
              .map((clientJson) =>
                  _safeParseClient(clientJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load clients by region');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
