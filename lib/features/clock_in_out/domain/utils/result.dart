// Simple Result pattern for clock-in/out feature
abstract class Result<T> {
  const Result();
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  T? get data => isSuccess ? (this as Success<T>).data : null;
  String? get error => isFailure ? (this as Failure<T>).error : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);
}
