import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository _repository;

  GetHomeDataUseCase(this._repository);

  Future<HomeData> call(int userId) {
    return _repository.getHomeData(userId);
  }
}
