import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_cubit.dart';
import 'package:smart_petition_app/cubit/user_info_cubit.dart';
import 'package:smart_petition_app/cubit/user_info_state.dart';
import 'package:smart_petition_app/utils/app_assets.dart';
import 'package:smart_petition_app/utils/app_colors.dart';

class UserInfoScreen extends StatelessWidget {
  final String topic;
  final String details;

  const UserInfoScreen({super.key, required this.topic, required this.details});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserInfoCubit(),
      child: BlocProvider(
        create: (_) => PetitionCubit(),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        _buildLogo(context),
                        _UserInfoForm(),
                        const SizedBox(height: 32),
                        _UserInfoSubmitButton(topic: topic, details: details),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Image.asset(AppAssets.logo, height: size.height * .2),
      ),
    );
  }
}

class _UserInfoForm extends StatelessWidget {
  const _UserInfoForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder:
          (context, state) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: context.read<UserInfoCubit>().updateFullName,
                  decoration: InputDecoration(
                    labelText: 'Ad Soyad *',
                    hintText: 'Ad Soyadınızı giriniz...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: context.read<UserInfoCubit>().updateTc,
                  decoration: InputDecoration(
                    labelText: 'TC Kimlik No *',
                    hintText: 'TC Kimlik Numaranızı giriniz...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: context.read<UserInfoCubit>().updateAddress,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Adres *',
                    alignLabelWithHint: true,
                    hintText: 'Adresinizi giriniz...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: context.read<UserInfoCubit>().updatePhone,
                  decoration: InputDecoration(
                    labelText: 'Telefon Numarası (İsteğe Bağlı)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
    );
  }
}

class _UserInfoSubmitButton extends StatelessWidget {
  final String topic;
  final String details;
  const _UserInfoSubmitButton({required this.topic, required this.details});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder:
          (context, state) => SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed:
                  state.isValid
                      ? () {
                        final user = context.read<UserInfoCubit>().state;
                        context.read<PetitionCubit>().generatePetition(
                          topic: topic,
                          details: details,
                          fullName: user.fullName,
                          address: user.address,
                          phone: user.phone,
                          tc: user.tc,
                          context: context,
                        );
                      }
                      : null,
              label: const Text('Oluştur'),
              icon: const Icon(Icons.smart_toy_outlined),
            ),
          ),
    );
  }
}
