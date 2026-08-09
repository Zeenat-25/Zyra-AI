import 'package:zyra/features/home/domain/entities/home_data.dart';
import 'package:zyra/features/home/domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<HomeData> getHomeData(int userId) async {
    final contactsCount = await _dataSource.getEmergencyContactsCount(userId);
    final voiceEnabled = await _dataSource.isVoiceDetectionEnabled();
    final lastLocation = await _dataSource.getLastLocation();

    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return HomeData(
      greeting: greeting,
      emergencyContactsCount: contactsCount,
      voiceDetectionEnabled: voiceEnabled,
      lastLocation: lastLocation,
    );
  }
}
