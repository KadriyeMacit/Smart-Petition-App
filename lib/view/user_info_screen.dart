import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_cubit.dart';
import 'package:smart_petition_app/cubit/user_info_cubit.dart';
import 'package:smart_petition_app/cubit/user_info_state.dart';

class UserInfoScreen extends StatelessWidget {
  final String topic;
  final String details;

  const UserInfoScreen({super.key, required this.topic, required this.details});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserInfoCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kullanıcı Bilgileri'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              BlocBuilder<UserInfoCubit, UserInfoState>(
                builder:
                    (context, state) => Column(
                      children: [
                        TextField(
                          onChanged:
                              context.read<UserInfoCubit>().updateFullName,
                          decoration: const InputDecoration(
                            labelText: 'Ad Soyad *',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged:
                              context.read<UserInfoCubit>().updateAddress,
                          decoration: const InputDecoration(
                            labelText: 'Adres *',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: context.read<UserInfoCubit>().updatePhone,
                          decoration: const InputDecoration(
                            labelText: 'Telefon Numarası (İsteğe Bağlı)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                state.isValid
                                    ? () {
                                      final user =
                                          context.read<UserInfoCubit>().state;
                                      context
                                          .read<PetitionCubit>()
                                          .generatePetition(
                                            topic: topic,
                                            details: details,
                                            fullName: user.fullName,
                                            address: user.address,
                                            phone: user.phone,
                                            context: context,
                                          );
                                    }
                                    : null,
                            child: const Text('Dilekçeyi Oluştur'),
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
