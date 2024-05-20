

import 'package:injectable/injectable.dart';
import 'package:securities_app/application.dart';
import 'package:securities_app/data/datasources/remote/api_service.dart';
import 'package:securities_app/domain/entities/entities_model.dart';
import 'package:securities_app/domain/repository/repository.dart';


@Injectable(as: Repository)
class RepositoryImpl implements Repository {
  final ApiService  _api = sl.get();

  @override
  Future<EntitiesModel> getData() {
    return _api.getData();
  }
}