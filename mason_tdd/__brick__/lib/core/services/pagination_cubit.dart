import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/response/api_response.dart';
import '/config/response/status.dart';

/// Ultra-simplified pagination mixin - Reusable for any API
///
/// Usage:
/// ```dart
/// class MyCubit extends Cubit<MyState> with PaginationMixin<MyState> {
///   Future<void> loadMore() async {
///     await loadMoreData<MyDataModel>(
///       fetchData: (page, limit) async {
///         final response = await networkRepository.get<Map<String, dynamic>>(
///           url: AppUrl.test,
///           queryParams: {
///             'limit': limit.toString(),
///             'skip': page.toString(),
///           },
///         );
///
///         return response.fold(
///           (l) => ApiResponse.error(l),
///           (r) => ApiResponse.completed(TestModel.fromJson(r)),
///         );
///       },
///       getCurrentData: (state) => state.response.data as MyDataModel,
///       getIsLoadingMore: (state) => state.isLoadingMore,
///       copyWithState: (
///         state, {
///         bool? isLoadingMore,
///         ApiResponse<MyDataModel>? response,
///       }) =>
///           state.copyWith(
///             response: response ?? state.response,
///             isLoadingMore: isLoadingMore ?? state.isLoadingMore,
///           ),
///       mergeData: (current, newData) => current.copyWith(
///         items: [...current.items, ...newData.items],
///       ),
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

    // Typed callbacks resolve dynamic property access.
    required TData Function(S state) getCurrentData,
    required bool Function(S state) getIsLoadingMore,
    required S Function(
      S state, {
      bool? isLoadingMore,
      ApiResponse<TData>? response,
    })
    copyWithState,

    int limit = 10,
  }) async {
    // Get current state and data
    final S currentState = state;
    final TData currentData = getCurrentData(currentState);
    final bool isLoadingMore = getIsLoadingMore(currentState);

    // Early return if loading or no more data
    if (isLoadingMore ||
        getCurrentCount(currentData) >= getTotalCount(currentData)) {
      return;
    }

    // Set loading
    emit(copyWithState(currentState, isLoadingMore: true));

    try {
      final ApiResponse<TData> response = await fetchData(
        getCurrentCount(currentData),
        limit,
      );

      if (response.status == Status.completed) {
        final TData mergedData = mergeData(currentData, response.data);

        emit(
          copyWithState(
            currentState,
            response: ApiResponse<TData>.completed(mergedData),
            isLoadingMore: false,
          ),
        );
      } else {
        emit(copyWithState(currentState, isLoadingMore: false));
      }
    } catch (e) {
      emit(copyWithState(currentState, isLoadingMore: false));
    }
  }
}
