import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_cubit.dart';

class UserInfoScreen extends StatefulWidget {
  final String topic;
  final String details;
  const UserInfoScreen({super.key, required this.topic, required this.details});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetitionCubit(),
      child: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Kullanıcı Bilgileri'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Ad Soyad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Adres',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
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
                            () =>
                                context.read<PetitionCubit>().generatePetition(
                                  topic: widget.topic,
                                  details: widget.details,
                                  fullName: fullNameController.text,
                                  address: addressController.text,
                                  phone: phoneController.text,
                                  context: context,
                                ),
                        child: const Text('Dilekçeyi Oluştur'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
