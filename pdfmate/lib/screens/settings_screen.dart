import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            context,
            'Conversion Settings',
            [
              _buildSettingsTile(
                context,
                'Output Quality',
                'High',
                Icons.high_quality,
                () {},
              ),
              _buildSettingsTile(
                context,
                'Auto-open Results',
                'Enabled',
                Icons.auto_awesome,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            context,
            'App Settings',
            [
              _buildSettingsTile(
                context,
                'Theme',
                'System Default',
                Icons.palette,
                () {},
              ),
              _buildSettingsTile(
                context,
                'Language',
                'English',
                Icons.language,
                () {},
              ),
            ],
          ), const SizedBox(height: 24),
          _buildSettingsSection(
            context,
            'App Settings',
            [
              _buildSettingsTile(
                context,
                'Theme',
                'System Default',
                Icons.palette,
                () {},
              ),
              _buildSettingsTile(
                context,
                'Language',
                'English',
                Icons.language,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            context,
            'About',
            [
              _buildSettingsTile(
                context,
                'Version',
                '1.0.0',
                Icons.info,
                () {},
              ),
              _buildSettingsTile(
                context,
                'Privacy Policy',
                '',
                Icons.privacy_tip,
                () {},
              ),
              _buildSettingsTile(
                context,
                'Terms of Service',
                '',
                Icons.description,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
