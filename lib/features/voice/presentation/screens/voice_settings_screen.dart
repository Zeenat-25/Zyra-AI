import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyra/core/constants/app_constants.dart';
import 'package:zyra/core/theme/app_theme.dart';
import 'package:zyra/core/utils/responsive_utils.dart';
import 'package:zyra/core/widgets/common/app_button.dart';
import 'package:zyra/core/widgets/common/app_text_field.dart';
import 'package:zyra/features/voice/presentation/providers/voice_provider.dart';

class VoiceSettingsScreen extends StatefulWidget {
  const VoiceSettingsScreen({super.key});

  @override
  State<VoiceSettingsScreen> createState() => _VoiceSettingsScreenState();
}

class _VoiceSettingsScreenState extends State<VoiceSettingsScreen> {
  final _keywordController = TextEditingController();
  bool _isAddingKeyword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoiceProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceProvider = context.watch<VoiceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Settings'),
        actions: [
          Switch(
            value: voiceProvider.voiceDetectionEnabled,
            onChanged: (_) => voiceProvider.toggleVoiceDetection(),
            activeColor: AppTheme.safeGreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.screenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(voiceProvider),
            const SizedBox(height: 24),
            _buildListeningSection(voiceProvider),
            const SizedBox(height: 24),
            _buildDefaultKeywords(),
            const SizedBox(height: 24),
            _buildCustomKeywords(voiceProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(VoiceProvider voiceProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (voiceProvider.isListening
                        ? AppTheme.safeGreen
                        : AppTheme.textSecondary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                voiceProvider.isListening ? Icons.mic : Icons.mic_off,
                color: voiceProvider.isListening
                    ? AppTheme.safeGreen
                    : AppTheme.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voiceProvider.isListening
                        ? 'Voice Detection Active'
                        : 'Voice Detection Off',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (voiceProvider.lastHeardText != null)
                    Text(
                      'Last heard: "${voiceProvider.lastHeardText}"',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListeningSection(VoiceProvider voiceProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Detection',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: voiceProvider.isListening
                    ? 'Stop Listening'
                    : 'Start Listening',
                icon: voiceProvider.isListening ? Icons.stop : Icons.play_arrow,
                backgroundColor: voiceProvider.isListening
                    ? AppTheme.sosRed
                    : AppTheme.safeGreen,
                onPressed: () {
                  if (voiceProvider.isListening) {
                    voiceProvider.stopListening();
                  } else {
                    voiceProvider.startListening(
                      onKeywordDetected: (keyword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Keyword detected: $keyword'),
                            backgroundColor: AppTheme.sosRed,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultKeywords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Default Trigger Keywords',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...AppConstants.defaultSosKeywords.map(
          (keyword) => Card(
            child: ListTile(
              leading: const Icon(Icons.keyboard_voice, color: AppTheme.primaryColor),
              title: Text(keyword),
              subtitle: const Text('Triggers SOS alert'),
              dense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomKeywords(VoiceProvider voiceProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Custom Keywords',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        if (!_isAddingKeyword) ...[
          AppButton(
            label: 'Add Custom Keyword',
            icon: Icons.add,
            isOutlined: true,
            onPressed: () => setState(() => _isAddingKeyword = true),
          ),
        ] else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppTextField(
                    controller: _keywordController,
                    hintText: 'Enter trigger keyword',
                    prefixIcon: const Icon(Icons.keyboard_voice),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Cancel',
                          isOutlined: true,
                          onPressed: () {
                            setState(() {
                              _isAddingKeyword = false;
                              _keywordController.clear();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: 'Add',
                          onPressed: () {
                            if (_keywordController.text.isNotEmpty) {
                              voiceProvider.addCustomKeyword(
                                _keywordController.text.trim(),
                                'trigger_sos',
                              );
                              _keywordController.clear();
                              setState(() => _isAddingKeyword = false);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (voiceProvider.commands.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No custom keywords added yet.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          )
        else
          ...voiceProvider.commands.map(
            (cmd) => Card(
              child: ListTile(
                leading: const Icon(Icons.keyboard_voice, color: AppTheme.primaryColor),
                title: Text(cmd.keyword),
                subtitle: Text('Action: ${cmd.action}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.sosRed),
                  onPressed: () => voiceProvider.removeKeyword(cmd.id!),
                ),
                dense: true,
              ),
            ),
          ),
      ],
    );
  }
}
