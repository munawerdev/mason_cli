import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/response/api_response.dart';
import '/config/response/status.dart';

/// Ultra-simplified pagination mixin - Reusable for any API
///
/// Usage:
/// ```dart
/// class MyCubit extends Cubit<MyState> with PaginationMixin {
///   Future<void> loadMore() async {
///     await loadMoreData<MyDataModel>(
///       fetchData: (page, limit) async {
///         final response = await networkRepository.get<Map<String, dynamic>>(
///           url: AppUrl.test,
///           queryParams: {'limit': limit.toString(), 'skip': page.toString()},
///         );
///         return response.fold(
///           (l) => ApiResponse.error(l),
///           (r) => ApiResponse.completed(TestModel.fromJson(r)),
///         );
///       },
///       mergeData: (current, new) => current.copyWith(items: [...current.items, ...new.items]),
///       getCurrentCount: (data) => data.items.length,
///       getTotalCount: (data) => data.total,
///     );
///   }
/// }
/// ```
mixin PaginationMixin<S> on Cubit<S> {
  /// Ultra-simplified loadMore with minimal required parameters
  Future<void> loadMoreData<TData>({
    required Future<ApiResponse<TData>> Function(int page, int limit) fetchData,
    required TData Function(TData current, TData newData) mergeData,
    required int Function(TData) getCurrentCount,
    required int Function(TData) getTotalCount,
    int limit = 10,
  }) async {
    // Get current state and data
    final dynamic currentState = state as dynamic;
    final TData currentData = currentState.response.data as TData;
    final bool isLoadingMore = currentState.isLoadingMore as bool;

    // Early return if loading or no more data
    if (isLoadingMore || getCurrentCount(currentData) >= getTotalCount(currentData)) {
      return;
    }

    // Set loading
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final ApiResponse<TData> response = await fetchData(getCurrentCount(currentData), limit);

      if (response.status == Status.completed) {
        final TData mergedData = mergeData(currentData, response.data);
        emit(
          currentState.copyWith(response: ApiResponse.completed(mergedData), isLoadingMore: false),
        );
      } else {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}
