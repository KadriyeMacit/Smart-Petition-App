class UserInfoState {
  final String fullName;
  final String address;
  final String phone;
  final bool isValid;

  UserInfoState({
    required this.fullName,
    required this.address,
    required this.phone,
    required this.isValid,
  });

  UserInfoState copyWith({
    String? fullName,
    String? address,
    String? phone,
    bool? isValid,
  }) {
    return UserInfoState(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isValid: isValid ?? this.isValid,
    );
  }
}
