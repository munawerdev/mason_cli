class Pagination {
  Pagination({
    required this.page,
    required this.limit,
    required this.currentRecords,
    required this.totalRecords,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] as int,
      limit: json['limit'] as int,
      currentRecords: json['currentRecords'] as int,
      totalRecords: json['totalRecords'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  final int page;
  final int limit;
  final int currentRecords;
  final int totalRecords;
  final int totalPages;

  Pagination copyWith({
    int? page,
    int? limit,
    int? currentRecords,
    int? totalRecords,
    int? totalPages,
  }) {
    return Pagination(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      currentRecords: currentRecords ?? this.currentRecords,
      totalRecords: totalRecords ?? this.totalRecords,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
