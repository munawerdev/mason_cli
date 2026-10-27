import 'package:fpdart/fpdart.dart';

import '/core/constants/global.dart';
import '/data/datasources/theme/theme_data_source.dart';
import '/domain/failures/theme/update_theme_failure.dart';
import '/domain/repositories/local/local_storage_base_api_service.dart';
import '../../failures/local/set_local_storage_failure.dart';

class UpdateThemeUseCase {
  UpdateThemeUseCase(this._themeStore, this._localStorageRepository);
  final ThemeDataSources _themeStore;
  final LocalStorageBaseApiService _localStorageRepository;

  Future<Either<UpdateThemeFailure, bool>> execute(bool isDarkTheme) {
    _themeStore.setTheme(isDarkTheme);
    return _localStorageRepository
        .setBool(key: GlobalConstants.themeKey, value: isDarkTheme)
        .then(
          (Either<SetLocalStorageFailure, bool> value) => value.fold(
            (SetLocalStorageFailure l) => left(UpdateThemeFailure(error: l.error)),
            (bool r) => right(true),
          ),
        );
  }
}
