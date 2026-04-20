abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

class RegisterLoading extends RegisterStates {}
class RegisterLoaded extends RegisterStates {}

class RegisterSuccess extends RegisterStates {
  final String token;
  RegisterSuccess(this.token);
}

class RegisterError extends RegisterStates {
  final String message;
  RegisterError(this.message);
}