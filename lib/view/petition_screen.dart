import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_topic_cubit.dart';
import 'package:smart_petition_app/cubit/petition_topic_state.dart';
import 'package:smart_petition_app/utils/app_assets.dart';
import 'package:smart_petition_app/utils/app_colors.dart';
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
        body: Center(
          child: BlocBuilder<PetitionTopicCubit, PetitionTopicState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const _PetitionLoading();
              }
              return _PetitionForm(
                inputController: inputController,
                otherTopicController: otherTopicController,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PetitionLoading extends StatelessWidget {
  const _PetitionLoading();

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class _PetitionForm extends StatelessWidget {
  const _PetitionForm({
    required this.inputController,
    required this.otherTopicController,
  });

  final TextEditingController inputController;
  final TextEditingController otherTopicController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetitionTopicCubit, PetitionTopicState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildLogo(context),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopicDropdown(context, state),
                      const SizedBox(height: 16),
                      _buildOtherTopicField(context, state),
                      _buildDetailsField(context, state),
                      const SizedBox(height: 24),
                      //
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSubmitButton(context, state),
              ],
            ),
          ),
        );
      },
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

  Widget _buildTopicDropdown(BuildContext context, PetitionTopicState state) {
    return DropdownButtonFormField<String>(
      value: state.selectedTopic,
      items:
          state.topics
              .map(
                (topic) => DropdownMenuItem(value: topic, child: Text(topic)),
              )
              .toList(),
      onChanged: (value) {
        context.read<PetitionTopicCubit>().updateSelectedTopic(value);
      },

      decoration: InputDecoration(
        labelText: 'Dilekçe Konusu',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildOtherTopicField(BuildContext context, PetitionTopicState state) {
    return state.selectedTopic == 'Diğer'
        ? Column(
          children: [
            TextField(
              controller: otherTopicController,
              decoration: InputDecoration(
                labelText: 'Lütfen konuyu belirtiniz',
                hintText: 'Konuyu giriniz...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        )
        : const SizedBox.shrink();
  }

  Widget _buildDetailsField(BuildContext context, PetitionTopicState state) {
    return TextField(
      controller: inputController,
      decoration: InputDecoration(
        labelText: 'Kısa Açıklama',
        alignLabelWithHint: true,
        hintText: 'Detayları giriniz...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      maxLines: 8,
    );
  }

  Widget _buildSubmitButton(BuildContext context, PetitionTopicState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        child: const Text('Devam Et'),
      ),
    );
  }
}
