import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyra/core/constants/app_constants.dart';
import 'package:zyra/core/theme/app_theme.dart';
import 'package:zyra/core/utils/responsive_utils.dart';
import 'package:zyra/features/auth/presentation/providers/auth_provider.dart';
import 'package:zyra/features/home/presentation/providers/home_provider.dart';
import 'package:zyra/routes/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final auth = context.read<AuthProvider>();
    if (auth.currentUser?.id != null) {
      context.read<HomeProvider>().loadHomeData(auth.currentUser!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final home = context.watch<HomeProvider>();
    final isTablet = ResponsiveUtils.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRouter.voiceSettings),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: ResponsiveUtils.screenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(auth, home),
              const SizedBox(height: 24),
              _buildSosButton(context),
              const SizedBox(height: 24),
              _buildQuickActions(context, isTablet),
              const SizedBox(height: 24),
              _buildStatusCards(home, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(AuthProvider auth, HomeProvider home) {
    final greeting = home.homeData?.greeting ?? 'Welcome';
    final name = auth.currentUser?.name ?? 'User';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSosButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRouter.sos),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment.center,
              colors: [
                AppTheme.sosRed,
                Color(0xFFD50000),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.sosRed.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 48, color: Colors.white),
              SizedBox(height: 8),
              Text(
                'SOS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'Tap for Emergency',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isTablet) {
    final actions = [
      _ActionItem(Icons.people_outlined, 'Emergency\nContacts', AppRouter.contacts),
      _ActionItem(Icons.mic_outlined, 'Voice\nSettings', AppRouter.voiceSettings),
      _ActionItem(Icons.location_on_outlined, 'Share\nLocation', AppRouter.location),
      _ActionItem(Icons.security_outlined, 'Safety\nTips', ''),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionCard(context, action);
      },
    );
  }

  Widget _buildActionCard(BuildContext context, _ActionItem action) {
    return Card(
      child: InkWell(
        onTap: action.route.isNotEmpty
            ? () => Navigator.pushNamed(context, action.route)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, size: 32, color: AppTheme.primaryColor),
              const SizedBox(height: 12),
              Text(
                action.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards(HomeProvider home, bool isTablet) {
    final voiceEnabled = home.homeData?.voiceDetectionEnabled ?? false;
    final contactsCount = home.homeData?.emergencyContactsCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Status',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                icon: Icons.mic,
                label: 'Voice Detection',
                value: voiceEnabled ? 'Active' : 'Off',
                color: voiceEnabled ? AppTheme.safeGreen : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatusCard(
                icon: Icons.people,
                label: 'Emergency Contacts',
                value: '$contactsCount',
                color: contactsCount > 0 ? AppTheme.safeGreen : AppTheme.warningAmber,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String route;

  const _ActionItem(this.icon, this.label, this.route);
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatusCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
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
}
