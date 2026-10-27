import 'package:fpdart/fpdart.dart';

import '/core/constants/global.dart';
import '/data/datasources/theme/theme_data_source.dart';
import '/domain/failures/theme/get_theme_failure.dart';
import '/domain/repositories/local/local_storage_base_api_service.dart';
import '../../failures/local/get_local_storage_failure.dart';

class GetThemeUseCase {
  GetThemeUseCase(this._localStorageRepository, this._themeStore);
  final LocalStorageBaseApiService _localStorageRepository;
  final ThemeDataSources _themeStore;

  Future<Either<GetThemeFailure, Unit>> execute() => _localStorageRepository
      .getBool(key: GlobalConstants.themeKey)
      .then(
        (Either<GetLocalStorageFailure, bool> value) => value.fold(
          (GetLocalStorageFailure l) => left(GetThemeFailure(error: l.error)),
          (bool isDarkTheme) {
            _themeStore.setTheme(isDarkTheme);
            return right(unit);
          },
        ),
      );
}
