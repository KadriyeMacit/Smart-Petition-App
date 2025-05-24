import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit()
    : super(
        UserInfoState(
          fullName: '',
          address: '',
          phone: '',
          tc: '',
          isValid: false,
        ),
      );

  void updateFullName(String name) {
    emit(state.copyWith(fullName: name));
    _validate();
  }

  void updateAddress(String address) {
    emit(state.copyWith(address: address));
    _validate();
  }

  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone));
  }

  void updateTc(String tc) {
    emit(state.copyWith(tc: tc));
    _validate();
  }

  void _validate() {
    final isValid =
        state.fullName.trim().isNotEmpty &&
        state.address.trim().isNotEmpty &&
        state.tc.trim().isNotEmpty;
    emit(state.copyWith(isValid: isValid));
  }
}
