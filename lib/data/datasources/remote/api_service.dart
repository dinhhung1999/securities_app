
import 'package:securities_app/data/dto/entities_dto.dart';
import 'package:securities_app/domain/entities/entities_model.dart';
import 'package:securities_app/global/network/rest_client.dart';

class ApiService extends RestClient {
  ApiService({required super.url});

  Future<EntitiesModel> getData() async {
    final response = await dio.get('path');
    return EntitiesDto();
  }

}
