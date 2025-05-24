import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_topic_state.dart';

class PetitionTopicCubit extends Cubit<PetitionTopicState> {
  PetitionTopicCubit()
    : super(
        PetitionTopicState(
          topics: [],
          selectedTopic: null,
          isLoading: true,
          topicError: null,
          detailsError: null,
          isValid: false,
        ),
      ) {
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('petitionTopics').get();
    final fetchedTopics =
        snapshot.docs.map((doc) => doc['title'] as String).toList();

    if (!fetchedTopics.contains('Diğer')) {
      fetchedTopics.add('Diğer');
    }

    emit(state.copyWith(topics: fetchedTopics, isLoading: false));
  }

  void updateSelectedTopic(String? topic) {
    emit(
      state.copyWith(selectedTopic: topic, topicError: null, isValid: false),
    );
  }

  void validateForm({required String otherTopic, required String details}) {
    String? topicError;
    String? detailsError;
    bool isValid = true;

    if (state.selectedTopic == 'Diğer' && otherTopic.isEmpty) {
      topicError = 'Lütfen konuyu belirtiniz';
      isValid = false;
    }

    if (details.isEmpty) {
      detailsError = 'Lütfen açıklama giriniz';
      isValid = false;
    }

    emit(
      state.copyWith(
        topicError: topicError,
        detailsError: detailsError,
        isValid: isValid,
      ),
    );
  }

  void validateAndSubmit({
    required String otherTopic,
    required String details,
    required Function(String topic, String details) onValid,
  }) {
    validateForm(otherTopic: otherTopic, details: details);

    if (state.isValid) {
      final selected =
          state.selectedTopic == 'Diğer'
              ? otherTopic
              : state.selectedTopic ?? '';
      onValid(selected, details);
    }
  }
}
