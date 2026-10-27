import '/config/response/status.dart';
import '/domain/failures/network/network_failure.dart';

class ApiResponse<T> {
  ApiResponse(this.status, this.data, this.error);

  ApiResponse.initial(this.initial) : status = Status.initial;

  ApiResponse.loading() : status = Status.loading;

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.error(this.error) : status = Status.error;
  late T initial;
  late Status status;
  late T data;
  late NetworkFailure error;
}
