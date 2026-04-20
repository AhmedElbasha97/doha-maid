// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/data/datasources/storage_local_data_source.dart';
import '../../../../core/services/auth_services.dart';
import '../../../home/presentation/home_screen.dart';
import '../../data/auth_model.dart';
import 'log_in_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool showPassword = true;
  void resetState() {
    emit( LoginInitial()); // or reload data as needed
  }
  showingPassword(){
    showPassword = !showPassword;
    emit(LoginInitial());
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      AuthModel? authData = await AuthServices(ApiService()).loggingIn(email, password);
      if (authData == null|| authData.success == false) {
        emit(LoginError(authData?.message ?? "Login failed. Try again"));
        return;
      }else  {
        // Save token to storage
         await StorageLocalDataSource.instance.setUserToken(authData.data!.token!);
         emit(LoginSuccess(authData.data!.token!));

        // Navigate to the home screen

         Navigator.pushAndRemoveUntil(
           context,
           MaterialPageRoute(builder: (_) => const HomeScreen(),    settings: const RouteSettings(name: "HomeScreen"),
           ),
               (route) => false,
         );

        return;
      }



    } catch (e) {
      emit(LoginError("Login failed. Try again"));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
