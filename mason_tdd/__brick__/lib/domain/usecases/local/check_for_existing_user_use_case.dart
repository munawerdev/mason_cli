import 'package:fpdart/fpdart.dart';

import '/data/datasources/user/user_data_sources.dart';
import '/data/models/user/user_info_store_model.dart';
import '/domain/failures/local/existing_user_failure.dart';
import '/domain/repositories/local/local_storage_base_api_service.dart';
import '../../failures/local/get_local_storage_failure.dart';

class CheckForExistingUserUseCase {
  CheckForExistingUserUseCase(this._userDataSources, this._localStorageRepository);
  final UserDataSources _userDataSources;
  final LocalStorageBaseApiService _localStorageRepository;

  Future<Either<ExistingUserFailure, UserInfoStoreModel>> execute() {
    return _localStorageRepository.getUserData().then(
      (Either<GetLocalStorageFailure, UserInfoStoreModel> value) => value.fold(
        (GetLocalStorageFailure l) => left(ExistingUserFailure(error: l.error)),
        (UserInfoStoreModel localUserInfoStoreModel) {
          if (localUserInfoStoreModel.accessToken.isNotEmpty) {
            _userDataSources.setUserDataSources(userInfoStoreModel: localUserInfoStoreModel);
            return right(localUserInfoStoreModel);
          }
          return left(ExistingUserFailure(error: "User doesn't exist "));
        },
      ),
    );
  }
}
