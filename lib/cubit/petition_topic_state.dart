class PetitionTopicState {
  final List<String> topics;
  final String? selectedTopic;
  final bool isLoading;
  final String? topicError;
  final String? detailsError;
  final bool isValid;

  PetitionTopicState({
    required this.topics,
    required this.selectedTopic,
    required this.isLoading,
    this.topicError,
    this.detailsError,
    this.isValid = false,
  });

  PetitionTopicState copyWith({
    List<String>? topics,
    String? selectedTopic,
    bool? isLoading,
    String? topicError,
    String? detailsError,
    bool? isValid,
  }) {
    return PetitionTopicState(
      topics: topics ?? this.topics,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      isLoading: isLoading ?? this.isLoading,
      topicError: topicError,
      detailsError: detailsError,
      isValid: isValid ?? this.isValid,
    );
  }
}
