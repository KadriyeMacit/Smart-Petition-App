import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_petition_app/cubit/petition_cubit.dart';

class PetitionResultScreen extends StatelessWidget {
  final String petitionText;

  const PetitionResultScreen({super.key, required this.petitionText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oluşturulan Dilekçe'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  petitionText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('PDF Olarak Kaydet'),
                    onPressed:
                        () => context.read<PetitionCubit>().exportPDF(
                          petitionText,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Paylaş'),
                    onPressed: () => Share.share(petitionText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
