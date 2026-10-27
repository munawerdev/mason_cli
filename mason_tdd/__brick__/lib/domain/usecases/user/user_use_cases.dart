import 'package:fpdart/fpdart.dart';

import '/data/datasources/user/user_data_sources.dart';
import '/data/models/user/user_info_store_model.dart';
import '/domain/failures/network/network_failure.dart';
import '/domain/repositories/local/local_storage_base_api_service.dart';
import '../../failures/local/set_local_storage_failure.dart';

class UserUseCases {
  UserUseCases(this._userDataSources, this._localStorageRepository);
  final UserDataSources _userDataSources;
  final LocalStorageBaseApiService _localStorageRepository;
  Future<Either<NetworkFailure, UserInfoStoreModel>> execute({
    required Map<String, dynamic> userData,
  }) async => _localStorageRepository
      .setUserData(userInfoStoreModel: UserInfoStoreModel.fromJson(userData))
      .then(
        (Either<SetLocalStorageFailure, bool> value) => value.fold(
          (SetLocalStorageFailure l) => left(NetworkFailure(error: l.error)),
          (bool tokenRight) {
            _userDataSources.setUserDataSources(
              userInfoStoreModel: UserInfoStoreModel.fromJson(userData),
            );
            return right(UserInfoStoreModel.fromJson(userData));
          },
        ),
      );
}
