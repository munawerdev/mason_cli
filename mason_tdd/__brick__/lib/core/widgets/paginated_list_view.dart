import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

/// A reusable paginated list view widget that handles infinite scrolling
/// and loading more functionality automatically.
///
/// Usage:
/// ```dart
/// PaginatedListView<T>(
///   items: data.items,
///   isLoadingMore: state.isLoadingMore,
///   onRefresh: () => cubit.refresh(),
///   onLoadMore: () => cubit.loadMore(),
///   itemBuilder: (context, item, index) => YourItemWidget(item: item),
///   loadingWidget: const CircularProgressIndicator(),
/// )
/// ```
class PaginatedListView<T> extends StatefulWidget {
  /// List of items to display
  final List<T> items;

  /// Whether currently loading more items
  final bool isLoadingMore;

  /// Callback when more items should be loaded
  final VoidCallback onLoadMore;

  /// Callback when list is refreshed (pull to refresh)
  final Future<void> Function()? onRefresh;

  /// Builder for individual list items
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Widget to show at bottom when loading more
  final Widget? loadingWidget;

  /// Scroll controller for the list (optional)
  final ScrollController? scrollController;

  /// Threshold distance from bottom to trigger load more (default: 200)
  final double loadMoreThreshold;

  /// Whether to show loading indicator at bottom
  final bool showLoadingIndicator;

  /// Padding around the list
  final EdgeInsetsGeometry? padding;

  /// Physics for the scroll view
  final ScrollPhysics? physics;

  /// Whether the list should shrink wrap
  final bool shrinkWrap;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.isLoadingMore,
    required this.itemBuilder,
    required this.onLoadMore,
    this.onRefresh,
    this.loadingWidget,
    this.scrollController,
    this.loadMoreThreshold = 200.0,
    this.showLoadingIndicator = true,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _scrollController;
  bool _hasTriggeredLoadMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - widget.loadMoreThreshold) {
      if (!widget.isLoadingMore && !_hasTriggeredLoadMore) {
        _hasTriggeredLoadMore = true;
        widget.onLoadMore();
      }
    } else {
      _hasTriggeredLoadMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount =
        widget.items.length +
        (widget.showLoadingIndicator && widget.isLoadingMore ? 1 : 0);

    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= widget.items.length) {
            // Show loading indicator at bottom
            return widget.loadingWidget ??
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
          }

          return widget.itemBuilder(context, widget.items[index], index);
        },
      ),
    );
  }
}

/// A paginated grid view widget for displaying items in a grid layout
class PaginatedGridView<T> extends StatefulWidget {
  /// List of items to display
  final List<T> items;

  /// Whether currently loading more items
  final bool isLoadingMore;

  /// Callback when more items should be loaded
  final VoidCallback onLoadMore;

  /// Callback when list is refreshed (pull to refresh)
  final Future<void> Function()? onRefresh;

  /// Builder for individual grid items
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Number of cross-axis items
  final int crossAxisCount;

  /// Ratio of cross-axis to main-axis extent
  final double childAspectRatio;

  /// Spacing between children
  final double crossAxisSpacing;

  /// Spacing between children in main axis
  final double mainAxisSpacing;

  /// Widget to show at bottom when loading more
  final Widget? loadingWidget;

  /// Scroll controller for the grid (optional)
  final ScrollController? scrollController;

  /// Threshold distance from bottom to trigger load more (default: 200)
  final double loadMoreThreshold;

  /// Whether to show loading indicator at bottom
  final bool showLoadingIndicator;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  /// Physics for the scroll view
  final ScrollPhysics? physics;

  /// Whether the grid should shrink wrap
  final bool shrinkWrap;

  const PaginatedGridView({
    super.key,
    required this.items,
    required this.isLoadingMore,
    required this.itemBuilder,
    required this.crossAxisCount,
    required this.onLoadMore,
    this.onRefresh,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.loadingWidget,
    this.scrollController,
    this.loadMoreThreshold = 200.0,
    this.showLoadingIndicator = true,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  State<PaginatedGridView<T>> createState() => _PaginatedGridViewState<T>();
}

class _PaginatedGridViewState<T> extends State<PaginatedGridView<T>> {
  late ScrollController _scrollController;
  bool _hasTriggeredLoadMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - widget.loadMoreThreshold) {
      if (!widget.isLoadingMore && !_hasTriggeredLoadMore) {
        _hasTriggeredLoadMore = true;
        widget.onLoadMore();
      }
    } else {
      _hasTriggeredLoadMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount =
        widget.items.length +
        (widget.showLoadingIndicator && widget.isLoadingMore ? 1 : 0);

    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: GridView.builder(
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= widget.items.length) {
            // Show loading indicator at bottom
            return widget.loadingWidget ??
                const Center(child: CircularProgressIndicator.adaptive());
          }

          return widget.itemBuilder(context, widget.items[index], index);
        },
      ),
    );
  }
}
