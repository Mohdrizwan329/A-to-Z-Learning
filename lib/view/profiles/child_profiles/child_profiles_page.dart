import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/multi_profile_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class ChildProfilesPage extends StatelessWidget {
  const ChildProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileService = Get.find<MultiProfileService>();
    final nameController = TextEditingController();

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
          "Child Profiles",
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
        child: Column(
          children: [
            // Current Profile Card
            Obx(() {
              final currentProfile = profileService.currentProfile.value;
              return Container(
                margin: EdgeInsets.all(16.r),
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10.r,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          currentProfile?.avatarEmoji ?? '👤',
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Currently Active',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            currentProfile?.name ?? 'No Profile',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (currentProfile != null)
                            Text(
                              '${currentProfile.age} years • ${currentProfile.grade ?? 'No grade'}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Profiles Grid Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Profiles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${profileService.profiles.length}/${MultiProfileService.maxProfiles}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Profiles List
            Expanded(
              child: Obx(() {
                final profiles = profileService.profiles;
                final canAddMore =
                    profiles.length < MultiProfileService.maxProfiles;

                return GridView.builder(
                  padding: EdgeInsets.all(16.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.r,
                    crossAxisSpacing: 16.r,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: profiles.length + (canAddMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == profiles.length && canAddMore) {
                      // Add new profile card
                      return _buildAddProfileCard(
                        context,
                        profileService,
                        nameController,
                      );
                    }

                    final profile = profiles[index];
                    final isActive =
                        profileService.currentProfile.value?.id == profile.id;

                    return _buildProfileCard(
                      context,
                      profile,
                      isActive,
                      profileService,
                      nameController,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    ChildProfile profile,
    bool isActive,
    MultiProfileService profileService,
    TextEditingController nameController,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          _showSwitchProfileDialog(context, profile, profileService);
        }
      },
      onLongPress: () {
        _showProfileOptions(context, profile, profileService, nameController);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: isActive ? Border.all(color: Colors.green, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        profile.avatarEmoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${profile.age} years old',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  if (profile.grade != null)
                    Text(
                      profile.grade!,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (isActive)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16.r),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProfileCard(
    BuildContext context,
    MultiProfileService profileService,
    TextEditingController nameController,
  ) {
    return GestureDetector(
      onTap: () =>
          _showAddProfileDialog(context, profileService, nameController),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 32.r),
            ),
            SizedBox(height: 12.h),
            const Text(
              'Add Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProfileDialog(
    BuildContext context,
    MultiProfileService profileService,
    TextEditingController nameController,
  ) {
    nameController.clear();
    int selectedAge = 5;
    String selectedEmoji = '👦';
    String? selectedGrade;

    final emojis = ['👦', '👧', '🧒', '👶', '🦸', '🧚', '🤖', '🐱', '🦊', '🐶'];
    final grades = ['Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2'];

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Row(
              children: [
                Text("➕", style: TextStyle(fontSize: 24)),
                SizedBox(width: 8.w),
                Text('Add Child Profile'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Child\'s Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Age selector
                  const Text(
                    'Age',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.r,
                    children: List.generate(10, (index) {
                      final age = index + 3;
                      return GestureDetector(
                        onTap: () => setState(() => selectedAge = age),
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: selectedAge == age
                                ? Colors.purple
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              '$age',
                              style: TextStyle(
                                color: selectedAge == age
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),

                  // Avatar selector
                  const Text(
                    'Avatar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.r,
                    runSpacing: 8.r,
                    children: emojis.map((emoji) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedEmoji = emoji),
                        child: Container(
                          width: 45.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: selectedEmoji == emoji
                                ? Colors.purple.withValues(alpha: 0.2)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10.r),
                            border: selectedEmoji == emoji
                                ? Border.all(color: Colors.purple, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),

                  // Grade selector
                  const Text(
                    'Grade (Optional)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.r,
                    runSpacing: 8.r,
                    children: grades.map((grade) {
                      return GestureDetector(
                        onTap: () => setState(
                          () => selectedGrade = selectedGrade == grade
                              ? null
                              : grade,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: selectedGrade == grade
                                ? Colors.purple
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            grade,
                            style: TextStyle(
                              color: selectedGrade == grade
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter a name',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  final result = await profileService.createProfile(
                    name: name,
                    age: selectedAge,
                    avatarEmoji: selectedEmoji,
                    grade: selectedGrade,
                  );

                  Get.back();
                  Get.snackbar(
                    result.success ? 'Success!' : 'Error',
                    result.message,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: result.success ? Colors.green : Colors.red,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSwitchProfileDialog(
    BuildContext context,
    ChildProfile profile,
    MultiProfileService profileService,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Text(profile.avatarEmoji, style: const TextStyle(fontSize: 32)),
            SizedBox(width: 12.w),
            Expanded(child: Text('Switch to ${profile.name}?')),
          ],
        ),
        content: const Text(
          'This will load their progress and customizations.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await profileService.switchProfile(profile.id);
              Get.back();
              Get.snackbar(
                'Switched!',
                'Now playing as ${profile.name}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }

  void _showProfileOptions(
    BuildContext context,
    ChildProfile profile,
    MultiProfileService profileService,
    TextEditingController nameController,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(profile.avatarEmoji, style: const TextStyle(fontSize: 32)),
                SizedBox(width: 12.w),
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Profile'),
              onTap: () {
                Get.back();
                _showEditProfileDialog(
                  context,
                  profile,
                  profileService,
                  nameController,
                );
              },
            ),
            if (profileService.profiles.length > 1)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Profile'),
                onTap: () {
                  Get.back();
                  _showDeleteProfileDialog(context, profile, profileService);
                },
              ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    ChildProfile profile,
    MultiProfileService profileService,
    TextEditingController nameController,
  ) {
    nameController.text = profile.name;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final updatedProfile = profile.copyWith(name: name);
                await profileService.updateProfile(updatedProfile);
                Get.back();
                Get.snackbar(
                  'Updated!',
                  'Profile name changed',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteProfileDialog(
    BuildContext context,
    ChildProfile profile,
    MultiProfileService profileService,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8.w),
            const Text('Delete Profile?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete ${profile.name}\'s profile? This will remove all their progress and cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final success = await profileService.deleteProfile(profile.id);
              Get.back();
              Get.snackbar(
                success ? 'Deleted' : 'Error',
                success ? 'Profile removed' : 'Cannot delete profile',
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
