import 'package:equatable/equatable.dart';

class ValidationResult<T> extends Equatable {
  final T data;
  final int status;
  final String errorMessage;

  const ValidationResult(this.data, this.status, this.errorMessage);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [data, status, errorMessage];
}
