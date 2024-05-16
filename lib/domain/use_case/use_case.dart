

import 'package:securities_app/application.dart';
import 'package:securities_app/domain/entities/entities_model.dart';
import 'package:securities_app/domain/repository/repository.dart';

class UseCase {
  final Repository _repository = sl.get();

  Future<EntitiesModel> fetchData() {
    return _repository.getData();
  }
}