import 'package:dio/dio.dart';
import '/core/network/api_constants.dart';
import '/core/network/api_result.dart';
import '/core/network/dio_client.dart';

class LookupsRepository {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResult<Map<String, dynamic>>> getAllLookups() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.allLookups);
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> getListFilterLookups() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.listFilterLookups);
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<List<dynamic>>> getGovernorates() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.governorates);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getDistrictsByGovernorate(
    int governorateId,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.districtsByGovernorate(governorateId),
      );
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getVillagesByDistrict(int districtId) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.villagesByDistrict(districtId),
      );
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getRegionsByVillage(int villageId) async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.regionsByVillage(villageId));
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getRealEstatesByRegion(int regionId) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.realEstatesByRegion(regionId),
      );
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getUnitsByRealEstate(
    int realEstateId,
  ) async {
    return safeApiCall(() async {
      final response = await _dio.get(
        ApiConstants.unitsByRealEstate(realEstateId),
      );
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getDeclarationTypes() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.declarationTypes);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getPropertyTypes() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.propertyTypes);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getTaxpayerTypes() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.taxpayerTypes);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getApplicantRoles() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.applicantRoles);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getRealEstateFloors() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.realEstateFloors);
      return _asList(response.data);
    });
  }

  Future<ApiResult<Map<String, dynamic>>> getIndustrialFacilityLookups() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.industrialFacilityLookups);
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<Map<String, dynamic>>> getProductionFacilityLookups() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.productionFacilityLookups);
      return response.data as Map<String, dynamic>;
    });
  }

  Future<ApiResult<List<dynamic>>> getStarRatings() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.starRatings);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getExploitationTypes() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.exploitationTypes);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getViewTypes() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.viewTypes);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getHotelCategories() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.hotelCategories);
      return _asList(response.data);
    });
  }

  Future<ApiResult<List<dynamic>>> getClaimStatuses() async {
    return safeApiCall(() async {
      final response = await _dio.get(ApiConstants.claimStatus);
      return _asList(response.data);
    });
  }

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey('data')) {
      final inner = data['data'];
      if (inner is List) return inner;
    }
    return [];
  }
}
