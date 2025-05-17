import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_topic_cubit.dart';
import 'package:smart_petition_app/cubit/petition_topic_state.dart';
import 'package:smart_petition_app/view/user_info_screen.dart';

class PetitionScreen extends StatelessWidget {
  PetitionScreen({super.key});

  final inputController = TextEditingController();
  final otherTopicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetitionTopicCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Akıllı Dilekçe Oluşturucu'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<PetitionTopicCubit, PetitionTopicState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: state.selectedTopic,
                          items:
                              state.topics
                                  .map(
                                    (topic) => DropdownMenuItem(
                                      value: topic,
                                      child: Text(topic),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            context
                                .read<PetitionTopicCubit>()
                                .updateSelectedTopic(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Dilekçe Konusu',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (state.selectedTopic == 'Diğer')
                          TextField(
                            controller: otherTopicController,
                            decoration: const InputDecoration(
                              labelText: 'Lütfen konuyu belirtiniz',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: inputController,
                          decoration: const InputDecoration(
                            labelText: 'Kısa Açıklama',
                            hintText: 'Detayları giriniz...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              final selected =
                                  state.selectedTopic == 'Diğer'
                                      ? otherTopicController.text
                                      : state.selectedTopic ?? '';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => UserInfoScreen(
                                        topic: selected,
                                        details: inputController.text,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.smart_toy_outlined),
                            label: const Text('Devam Et'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
