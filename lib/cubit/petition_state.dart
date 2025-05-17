abstract class PetitionState {}

class PetitionInitial extends PetitionState {}

class PetitionLoading extends PetitionState {}

class PetitionGenerated extends PetitionState {
  final String petitionText;
  PetitionGenerated(this.petitionText);
}
