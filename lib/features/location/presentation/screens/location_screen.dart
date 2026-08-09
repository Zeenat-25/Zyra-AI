import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyra/core/theme/app_theme.dart';
import 'package:zyra/core/utils/responsive_utils.dart';
import 'package:zyra/features/location/presentation/providers/location_provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Location'),
        actions: [
          IconButton(
            icon: Icon(
              locationProvider.isTracking
                  ? Icons.location_searching
                  : Icons.location_disabled,
              color: locationProvider.isTracking
                  ? AppTheme.safeGreen
                  : null,
            ),
            onPressed: () {
              if (locationProvider.isTracking) {
                locationProvider.stopTracking();
              } else {
                locationProvider.startTracking();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: ResponsiveUtils.screenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationCard(locationProvider),
            const SizedBox(height: 24),
            _buildTrackingControl(locationProvider),
            const SizedBox(height: 24),
            _buildShareOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(LocationProvider locationProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: locationProvider.isLoading
                    ? const CircularProgressIndicator()
                    : locationProvider.currentLocation != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 48,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${locationProvider.currentLocation!.latitude.toStringAsFixed(6)},',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${locationProvider.currentLocation!.longitude.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 48,
                                color: AppTheme.textSecondary,
                              ),
                              SizedBox(height: 8),
                              Text('Location unavailable'),
                            ],
                          ),
              ),
            ),
            if (locationProvider.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  locationProvider.error!,
                  style: const TextStyle(color: AppTheme.sosRed),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingControl(LocationProvider locationProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              locationProvider.isTracking
                  ? Icons.fiber_manual_record
                  : Icons.fiber_manual_record_outlined,
              color: locationProvider.isTracking
                  ? AppTheme.safeGreen
                  : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationProvider.isTracking
                        ? 'Live Tracking Active'
                        : 'Live Tracking Off',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    locationProvider.isTracking
                        ? 'Your location is being shared'
                        : 'Enable to share live location',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: locationProvider.isTracking,
              onChanged: (value) {
                if (value) {
                  locationProvider.startTracking();
                } else {
                  locationProvider.stopTracking();
                }
              },
              activeColor: AppTheme.safeGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.share, color: AppTheme.primaryColor),
            title: const Text('Share Current Location'),
            subtitle: const Text('Send your location via messaging apps'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.timer, color: AppTheme.primaryColor),
            title: const Text('Share Live Location'),
            subtitle: const Text('Share real-time location for a duration'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.history, color: AppTheme.primaryColor),
            title: const Text('Location History'),
            subtitle: const Text('View your location history'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
