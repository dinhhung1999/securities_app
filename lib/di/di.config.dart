// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/datasources/remote/api_service.dart' as _i3;
import '../data/repository_impl/repository_impl.dart' as _i6;
import '../domain/repository/repository.dart' as _i5;
import '../global/navigator/navigation/navigation.dart' as _i7;
import '../global/navigator/navigation/navigation_impl.dart' as _i8;
import '../global/socket/socket_data_center.dart' as _i4;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.ApiService>(() => _i3.ApiService());
  gh.lazySingleton<_i4.SocketDataCenter>(() => _i4.SocketDataCenter());
  gh.factory<_i5.Repository>(() => _i6.RepositoryImpl());
  gh.lazySingleton<_i7.Navigation>(() => _i8.NavigationImpl());
  return getIt;
}
