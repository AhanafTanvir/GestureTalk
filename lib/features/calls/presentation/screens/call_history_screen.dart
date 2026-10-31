import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/gestutalk_side_drawer.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../../core/widgets/user_avatar_circle.dart';
import '../providers/calls_provider.dart';

/// Recent Calls Screen matching Figma Mockup (Frame@2x-1.png)
class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final callsState = ref.watch(callsProvider);

    return GradientScaffold(
      drawer: const GestuTalkSideDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Hamburger, "Recent", and Circular Profile Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu, size: 28),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Recent',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  // User Profile Circular Avatar with Blue Ring
                  UserAvatarCircle(
                    radius: 20,
                    borderWidth: 2.5,
                    onTap: () => context.push(AppRoutes.editProfile),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // "Today" Section Header
              Text(
                'Today',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),

              // Calls List
              Expanded(
                child: ListView.separated(
                  itemCount: callsState.todayCalls.length,
                  separatorBuilder: (ctx, idx) => Divider(
                    color: isDark ? AppColors.darkBorder : Colors.black12,
                    height: 24,
                  ),
                  itemBuilder: (ctx, idx) {
                    final call = callsState.todayCalls[idx];
                    return InkWell(
                      onTap: () => context.push(AppRoutes.disabledTranslation),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            // Call icon in cyan rounded box matching mockup
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF38BDF8),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF38BDF8)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.phone_callback_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Contact Name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    call.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${call.time} • ${call.duration}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.55),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.videocam_outlined,
                                  color: AppColors.primary),
                              onPressed: () =>
                                  context.push(AppRoutes.disabledTranslation),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Subtitle watermark "call history" matching mockup
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'call history',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.45),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.phone_in_talk_rounded,
                        size: 16,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
