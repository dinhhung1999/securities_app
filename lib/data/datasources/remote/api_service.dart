
import 'package:injectable/injectable.dart';
import 'package:securities_app/application.dart';
import 'package:securities_app/config/app_config.dart';
import 'package:securities_app/data/dto/entities_dto.dart';
import 'package:securities_app/domain/entities/entities_model.dart';
import 'package:securities_app/global/network/networking_factory.dart';
import 'package:securities_app/global/network/rest_client.dart';

@injectable
class ApiService extends RestClient {
  ApiService() : super(
    dio: NetworkingFactory.createDio(
        baseUrl: sl.get<AppConfig>().config.baseUrl
    ),
  );

  Future<EntitiesModel> getData() async {
    final response = await dio.get('path');
    return EntitiesDto();
  }

}
