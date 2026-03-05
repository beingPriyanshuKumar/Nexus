import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile/profile_provider.dart';
import '../../utils/models/mock_data/se_mock_data.dart';
import 'shared/dashboard_layout.dart';

class SePanel extends StatelessWidget {
  const SePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        profileInitDataProvider.overrideWithValue(ProfileInitData(
          profile: seProfileData,
          members: seMembersData,
          tasks: seTasksData,
          messages: seMessagesData,
          notifications: seNotificationsData,
          role: 'SE',
        )),
        profileProvider.overrideWith(() => ProfileNotifier()),
      ],
      child: const DashboardLayout(),
    );
  }
}
