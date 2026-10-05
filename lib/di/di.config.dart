// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../data/datasources/api_service.dart' as _i630;
import '../domain/repositories/random_advice_repository.dart' as _i747;
import '../repositories/random_advice_repository_impl.dart' as _i1050;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i519.Client>(() => registerModule.client);
    gh.singleton<_i630.ApiService>(
      () => _i630.ApiService(client: gh<_i519.Client>()),
    );
    gh.lazySingleton<_i747.RandomAdviceRepository>(
      () =>
          _i1050.RandomAdviceRepositoryImpl(apiService: gh<_i630.ApiService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
