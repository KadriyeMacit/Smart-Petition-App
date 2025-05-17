import 'package:flutter/material.dart';
import 'package:smart_petition_app/view/user_info_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akıllı Dilekçe Oluşturucu'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => UserInfoScreen(
                                    topic:
                                        selectedTopic == 'Diğer'
                                            ? otherTopicController.text
                                            : selectedTopic ?? '',
                                    details: inputController.text,
                                  ),
                            ),
                          ),
                      icon: const Icon(Icons.smart_toy_outlined),
                      label: const Text('Devam Et'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
