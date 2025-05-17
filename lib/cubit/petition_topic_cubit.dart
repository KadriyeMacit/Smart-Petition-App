import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_petition_app/cubit/petition_topic_state.dart';

class PetitionTopicCubit extends Cubit<PetitionTopicState> {
  PetitionTopicCubit()
    : super(
        PetitionTopicState(topics: [], selectedTopic: null, isLoading: true),
      ) {
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('petitionTopics').get();
    final fetchedTopics =
        snapshot.docs.map((doc) => doc['title'] as String).toList();
    emit(state.copyWith(topics: [...fetchedTopics, 'Diğer'], isLoading: false));
  }

  void updateSelectedTopic(String? topic) {
    emit(state.copyWith(selectedTopic: topic));
  }
}
