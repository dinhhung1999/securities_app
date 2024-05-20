

import 'package:injectable/injectable.dart';
import 'package:securities_app/domain/entities/entities_model.dart';

abstract class Repository {
  Future<EntitiesModel> getData();
}