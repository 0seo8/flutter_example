import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/random_advice_repository.dart';

@injectable
class RandomAdviceCubit extends Cubit<String> {
  RandomAdviceCubit({required RandomAdviceRepository randomAdviceRepository})
      : _randomAdviceRepository = randomAdviceRepository,
        super('Get some adivce!');

  final RandomAdviceRepository _randomAdviceRepository;

  Future<void> getRandomAdvice() async {
    emit('Loading...');
    try {
      final randomAdvice = await _randomAdviceRepository.getRandomAdvice();
      emit(randomAdvice);
    } catch (e) {
      emit('Error while fetching random advice');     
    }
  }
}
 