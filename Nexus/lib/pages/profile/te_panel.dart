import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile/profile_provider.dart';
import '../../utils/models/mock_data/te_mock_data.dart';
import 'shared/dashboard_layout.dart';

class TePanel extends StatelessWidget {
  const TePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        profileInitDataProvider.overrideWithValue(ProfileInitData(
          profile: teProfileData,
          members: teMembersData,
          tasks: teTasksData,
          messages: teMessagesData,
          notifications: teNotificationsData,
          role: 'TE',
        )),
        profileProvider.overrideWith(() => ProfileNotifier()),
      ],
      child: const DashboardLayout(),
    );
  }
}
