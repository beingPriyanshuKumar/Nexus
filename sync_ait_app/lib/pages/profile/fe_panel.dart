import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile/profile_provider.dart';
import '../../utils/models/mock_data/fe_mock_data.dart';
import 'shared/dashboard_layout.dart';

class FePanel extends StatelessWidget {
  const FePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        profileInitDataProvider.overrideWithValue(ProfileInitData(
          profile: feProfileData,
          members: feMembersData,
          tasks: feTasksData,
          messages: feMessagesData,
          notifications: feNotificationsData,
          role: 'FE',
        )),
        profileProvider.overrideWith(() => ProfileNotifier()),
      ],
      child: const DashboardLayout(),
    );
  }
}
