class UserInfoState {
  final String fullName;
  final String address;
  final String phone;
  final String tc;
  final bool isValid;

  UserInfoState({
    required this.fullName,
    required this.address,
    required this.phone,
    required this.tc,
    required this.isValid,
  });

  UserInfoState copyWith({
    String? fullName,
    String? address,
    String? phone,
    String? tc,
    bool? isValid,
  }) {
    return UserInfoState(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      tc: tc ?? this.tc,
      isValid: isValid ?? this.isValid,
    );
  }
}
