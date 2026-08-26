import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/cloud_sync_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class CloudSyncPage extends StatelessWidget {
  const CloudSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = Get.find<CloudSyncService>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Cloud Sync",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            // Sync Status Card
            Obx(
              () => Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      syncService.isOnline.value ? Colors.green : Colors.grey,
                      syncService.isOnline.value
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (syncService.isOnline.value
                                  ? Colors.green
                                  : Colors.grey)
                              .withValues(alpha: 0.4),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: syncService.isSyncing.value
                                ? SizedBox(
                                    width: 30.w,
                                    height: 30.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3.r,
                                    ),
                                  )
                                : Icon(
                                    syncService.isOnline.value
                                        ? Icons.cloud_done
                                        : Icons.cloud_off,
                                    color: Colors.white,
                                    size: 32.r,
                                  ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                syncService.isOnline.value
                                    ? 'Connected'
                                    : 'Offline',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                syncService.syncStatus.value,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Flexible, so the inner row is measured against the
                        // width that is actually available. A Row measures an
                        // inflexible child with unbounded width, and this one
                        // holds a Flexible caption, which cannot be laid out
                        // that way.
                        Flexible(
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Colors.white70,
                                size: 16.r,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  'Last sync: ${syncService.lastSyncFormatted}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Sync Actions
            _buildSectionHeader('Sync Actions'),
            _buildSettingsCard([
              Obx(
                () => ListTile(
                  leading: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cloud_upload, color: Colors.blue),
                  ),
                  title: const Text('Backup to Cloud'),
                  subtitle: const Text('Save your progress online'),
                  trailing: syncService.isSyncing.value
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(strokeWidth: 2.r),
                        )
                      : Icon(Icons.arrow_forward_ios, size: 16.r),
                  onTap: syncService.isSyncing.value
                      ? null
                      : () async {
                          final result = await syncService.syncToCloud();
                          Get.snackbar(
                            result.success ? 'Success!' : 'Error',
                            result.message,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: result.success
                                ? Colors.green
                                : Colors.red,
                            colorText: Colors.white,
                          );
                        },
                ),
              ),
              const Divider(),
              Obx(
                () => ListTile(
                  leading: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_download,
                      color: Colors.orange,
                    ),
                  ),
                  title: const Text('Restore from Cloud'),
                  subtitle: const Text('Get your saved progress'),
                  trailing: syncService.isSyncing.value
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(strokeWidth: 2.r),
                        )
                      : Icon(Icons.arrow_forward_ios, size: 16.r),
                  onTap: syncService.isSyncing.value
                      ? null
                      : () => _showRestoreDialog(context, syncService),
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // Auto Sync Settings
            _buildSectionHeader('Settings'),
            _buildSettingsCard([
              Obx(
                () => SwitchListTile(
                  secondary: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.sync_alt, color: Colors.purple),
                  ),
                  title: const Text('Auto Sync'),
                  subtitle: const Text('Sync automatically when online'),
                  value: syncService.autoSyncEnabled.value,
                  onChanged: (value) => syncService.setAutoSync(value),
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // What gets synced
            _buildSectionHeader('What Gets Synced'),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  _buildSyncItem('📊', 'Progress & Scores', true),
                  _buildSyncItem('🏆', 'Achievements & Rewards', true),
                  _buildSyncItem('🪙', 'Coins & Shop Items', true),
                  _buildSyncItem('👤', 'Avatar Customizations', true),
                  _buildSyncItem('⚙️', 'App Settings', true),
                  _buildSyncItem('📅', 'Daily Goals & Streaks', true),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Danger Zone
            _buildSectionHeader('Danger Zone'),
            _buildSettingsCard([
              ListTile(
                leading: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_forever, color: Colors.red),
                ),
                title: const Text(
                  'Delete Cloud Data',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Remove all backup data'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.r,
                  color: Colors.red,
                ),
                onTap: () => _showDeleteDialog(context, syncService),
              ),
            ]),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSyncItem(String emoji, String title, bool synced) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          SizedBox(width: 12.w),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          Icon(
            synced ? Icons.check_circle : Icons.cancel,
            color: synced ? Colors.green : Colors.grey,
            size: 20.r,
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, CloudSyncService syncService) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8.w),
            Text('Restore Data?'),
          ],
        ),
        content: const Text(
          'This will replace your current progress with the cloud backup. Make sure you want to do this.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final result = await syncService.restoreFromCloud();
              Get.snackbar(
                result.success ? 'Restored!' : 'Error',
                result.message,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: result.success ? Colors.green : Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, CloudSyncService syncService) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red),
            SizedBox(width: 8.w),
            Text('Delete Cloud Data?'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your backup data from the cloud. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await syncService.deleteCloudData();
              Get.snackbar(
                success ? 'Deleted' : 'Error',
                success
                    ? 'Cloud data has been deleted'
                    : 'Failed to delete cloud data',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: success ? Colors.orange : Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
