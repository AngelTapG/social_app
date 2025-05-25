import 'package:social_app_jose_gael/features/profile/domain/data/presentation/pages/entities/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser>> searchUsers(String query);
}
