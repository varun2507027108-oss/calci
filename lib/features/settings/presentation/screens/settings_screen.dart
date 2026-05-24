import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/theme_provider.dart';

/// Settings screen — app preferences and configuration.
///
/// Sections: Appearance, Calculator, Data, About
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkSurfacePrimary
          : AppColors.lightSurfacePrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Settings',
                style: AppTypography.headlineLarge.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  // ── APPEARANCE ──────────────────────────────
                  _SectionHeader(title: 'Appearance', isDark: isDark),
                  _SettingsCard(
                    isDark: isDark,
                    children: [
                      _ThemeSelector(
                        isDark: isDark,
                        currentMode: themeMode,
                        onChanged: (mode) {
                          ref.read(themeModeProvider.notifier).setTheme(mode);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── CALCULATOR ──────────────────────────────
                  _SectionHeader(title: 'Calculator', isDark: isDark),
                  _SettingsCard(
                    isDark: isDark,
                    children: [
                      _SettingsTile(
                        isDark: isDark,
                        icon: Icons.straighten_rounded,
                        title: 'Decimal places',
                        subtitle: '10 (default)',
                      ),
                      _SettingsDivider(isDark: isDark),
                      _SettingsTile(
                        isDark: isDark,
                        icon: Icons.vibration_rounded,
                        title: 'Haptic feedback',
                        subtitle: 'Button press vibration',
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                        ),
                      ),
                      _SettingsDivider(isDark: isDark),
                      _SettingsTile(
                        isDark: isDark,
                        icon: Icons.volume_up_rounded,
                        title: 'Sound effects',
                        subtitle: 'Key press sounds',
                        trailing: Switch(
                          value: false,
                          onChanged: (_) {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── DATA ────────────────────────────────────
                  _SectionHeader(title: 'Data', isDark: isDark),
                  _SettingsCard(
                    isDark: isDark,
                    children: [
                      _SettingsTile(
                        isDark: isDark,
                        icon: Icons.history_rounded,
                        title: 'Clear history',
                        subtitle: 'Delete all calculation history',
                        iconColor: AppColors.accentTerracotta,
                      ),
                      _SettingsDivider(isDark: isDark),
                      _SettingsTile(
                        isDark: isDark,
                        icon: Icons.file_download_outlined,
                        title: 'Export history',
                        subtitle: 'Save as PDF or text file',
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── ABOUT ───────────────────────────────────
                  _SectionHeader(title: 'About', isDark: isDark),
                  _SettingsCard(
                    isDark: isDark,
                    children: [
                      _SettingsTile(
                        isDark: isDark,
                        icon: Icons.info_outline_rounded,
                        title: 'Calcuon',
                        subtitle: 'Version 1.0.0',
                      ),
                      _SettingsDivider(isDark: isDark),
                      _SettingsTile(
                        isDark: isDark,
                        icon: Icons.description_outlined,
                        title: 'Licenses',
                        subtitle: 'Open source licenses',
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.bottomNavHeight + bottomPadding + AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SUPPORTING WIDGETS ─────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.isDark});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.isDark, required this.children});
  final bool isDark;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
          width: 0.5,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.iconColor,
  });

  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 52,
      color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.isDark,
    required this.currentMode,
    required this.onChanged,
  });

  final bool isDark;
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _ThemeOption(
                isDark: isDark,
                icon: Icons.dark_mode_rounded,
                label: 'Dark',
                isSelected: currentMode == ThemeMode.dark,
                onTap: () => onChanged(ThemeMode.dark),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ThemeOption(
                isDark: isDark,
                icon: Icons.light_mode_rounded,
                label: 'Light',
                isSelected: currentMode == ThemeMode.light,
                onTap: () => onChanged(ThemeMode.light),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ThemeOption(
                isDark: isDark,
                icon: Icons.auto_mode_rounded,
                label: 'System',
                isSelected: currentMode == ThemeMode.system,
                onTap: () => onChanged(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentAmber.withValues(alpha: 0.15)
                : (isDark ? AppColors.darkSurfacePrimary : AppColors.lightSurfaceKeypad),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected
                  ? AppColors.accentAmber.withValues(alpha: 0.4)
                  : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? AppColors.accentAmber
                    : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.accentAmber
                      : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
