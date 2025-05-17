import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_cubit.dart';
import 'package:smart_petition_app/cubit/petition_state.dart';

class PetitionScreen extends StatefulWidget {
  const PetitionScreen({super.key});

  @override
  State<PetitionScreen> createState() => _PetitionScreenState();
}

class _PetitionScreenState extends State<PetitionScreen> {
  final topicController = TextEditingController();
  final inputController = TextEditingController();
  final otherTopicController = TextEditingController();

  final List<String> topics = [
    'Yol bakım talebi',
    'Sokak lambası arızası',
    'Park ihtiyacı',
    'Çöp toplama şikayeti',
    'Hayvan barınağı desteği',
    'Gürültü şikayeti',
    'Diğer',
  ];

  String? selectedTopic;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetitionCubit, PetitionState>(
      builder: (context, state) {
        final cubit = context.read<PetitionCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Akıllı Dilekçe Oluşturucu'),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
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
                        value: selectedTopic,
                        items:
                            topics.map((topic) {
                              return DropdownMenuItem(
                                value: topic,
                                child: Text(topic),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTopic = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Dilekçe Konusu',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (selectedTopic == 'Diğer')
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
                          onPressed:
                              () => cubit.generatePetition(
                                selectedTopic == 'Diğer'
                                    ? otherTopicController.text
                                    : selectedTopic ?? '',
                                inputController.text,
                              ),
                          icon: const Icon(Icons.smart_toy_outlined),
                          label: const Text('AI ile Dilekçe Oluştur'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<PetitionCubit, PetitionState>(
                    builder: (context, state) {
                      if (state is PetitionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PetitionGenerated) {
                        return Container(
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
                              Text(
                                '📄 Oluşturulan Dilekçe:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    state.petitionText,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  icon: const Icon(
                                    Icons.picture_as_pdf_outlined,
                                  ),
                                  label: const Text('PDF Olarak Kaydet'),
                                  onPressed:
                                      () => cubit.exportPDF(state.petitionText),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text('Henüz bir dilekçe oluşturulmadı.'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
