class PetitionTopicState {
  final List<String> topics;
  final String? selectedTopic;
  final bool isLoading;

  PetitionTopicState({
    required this.topics,
    required this.selectedTopic,
    required this.isLoading,
  });

  PetitionTopicState copyWith({
    List<String>? topics,
    String? selectedTopic,
    bool? isLoading,
  }) {
    return PetitionTopicState(
      topics: topics ?? this.topics,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
