import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyan_learning/services/avatar_coins_service.dart';
import 'package:jiyan_learning/services/tts_service.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class AvatarShopPage extends StatefulWidget {
  const AvatarShopPage({super.key});

  @override
  State<AvatarShopPage> createState() => _AvatarShopPageState();
}

class _AvatarShopPageState extends State<AvatarShopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AvatarCoinsService _avatarService = Get.find<AvatarCoinsService>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Avatar Shop",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // Coin display
          Obx(
            () => Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  const Text("🪙", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4.w),
                  Text(
                    '${_avatarService.totalCoins.value}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
          tabs: const [
            Tab(text: '👤 Avatars'),
            Tab(text: '👕 Outfits'),
            Tab(text: '✨ Accessories'),
            Tab(text: '🖼️ Backgrounds'),
          ],
        ),
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
            // Current Avatar Preview
            Container(
              margin: EdgeInsets.all(16.r),
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Obx(() {
                final avatar = AvatarCoinsService
                    .avatars[_avatarService.selectedAvatar.value];
                final outfit = AvatarCoinsService
                    .outfits[_avatarService.selectedOutfit.value];
                final accessory = AvatarCoinsService
                    .accessories[_avatarService.selectedAccessory.value];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar display
                    Container(
                      width: 80.w,
                      height: 80.h,
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
                          avatar?.emoji ?? '👤',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _avatarService.avatarName.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          avatar?.name ?? 'Default',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        if (outfit != null && outfit.id != 'casual')
                          Text(
                            'Outfit: ${outfit.name}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        if (accessory != null && accessory.id != 'none')
                          Text(
                            'Accessory: ${accessory.name}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              }),
            ),

            // Daily bonus button
            Obx(() {
              if (_avatarService.canClaimBonus.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _avatarService.claimDailyBonus();
                      Get.snackbar(
                        '🎁 Daily Bonus!',
                        'You earned 15 coins!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Text("🎁", style: TextStyle(fontSize: 20)),
                    label: const Text('Claim Daily Bonus (+15 coins)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            SizedBox(height: 8.h),

            // Shop Items
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildShopGrid(
                    AvatarCoinsService.avatars.values.toList(),
                    'avatar',
                  ),
                  _buildShopGrid(
                    AvatarCoinsService.outfits.values.toList(),
                    'outfit',
                  ),
                  _buildShopGrid(
                    AvatarCoinsService.accessories.values.toList(),
                    'accessory',
                  ),
                  _buildShopGrid(
                    AvatarCoinsService.backgrounds.values.toList(),
                    'background',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopGrid(List<ShopItem> items, String type) {
    return GridView.builder(
      padding: EdgeInsets.all(16.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.r,
        crossAxisSpacing: 16.r,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildShopItem(item, type);
      },
    );
  }

  Widget _buildShopItem(ShopItem item, String type) {
    return Obx(() {
      final isOwned = _avatarService.isItemOwned(item);
      final isEquipped = _isItemEquipped(item, type);
      final canAfford = _avatarService.totalCoins.value >= item.price;

      return GestureDetector(
        onTap: () {
          TtsService.to.speak(item.name);
          _handleItemTap(item, isOwned, canAfford);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: isEquipped
                ? Border.all(color: Colors.amber, width: 3)
                : null,
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
              // Item content
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Emoji
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(type).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Name
                    Flexible(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Category badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(type),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Price or status
                    if (isOwned)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isEquipped ? Colors.amber : Colors.green,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          isEquipped ? 'EQUIPPED' : 'OWNED',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (item.price == 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Text(
                          'FREE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: canAfford ? Colors.amber : Colors.grey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("🪙", style: TextStyle(fontSize: 12)),
                            SizedBox(width: 4.w),
                            Text(
                              '${item.price}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Locked overlay for unaffordable items
              if (!isOwned && !canAfford && item.price > 0)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Icon(Icons.lock, color: Colors.white, size: 32.r),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  bool _isItemEquipped(ShopItem item, String type) {
    switch (type) {
      case 'avatar':
        return _avatarService.selectedAvatar.value == item.id;
      case 'outfit':
        return _avatarService.selectedOutfit.value == item.id;
      case 'accessory':
        return _avatarService.selectedAccessory.value == item.id;
      case 'background':
        return _avatarService.selectedBackground.value == item.id;
      default:
        return false;
    }
  }

  Color _getCategoryColor(String type) {
    switch (type) {
      case 'avatar':
        return Colors.purple;
      case 'outfit':
        return Colors.blue;
      case 'accessory':
        return Colors.orange;
      case 'background':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _handleItemTap(ShopItem item, bool isOwned, bool canAfford) {
    if (isOwned) {
      // Equip item
      _avatarService.equipItem(item);
      Get.snackbar(
        'Equipped!',
        '${item.name} is now equipped',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else if (item.price == 0 || canAfford) {
      // Show purchase dialog
      _showPurchaseDialog(item);
    } else {
      // Not enough coins
      Get.snackbar(
        'Not Enough Coins',
        'You need ${item.price - _avatarService.totalCoins.value} more coins',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showPurchaseDialog(ShopItem item) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 32)),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item.price == 0 ? 'Get ${item.name}?' : 'Buy ${item.name}?',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.description ?? 'A cool ${item.category} for your avatar!',
            ),
            SizedBox(height: 16.h),
            if (item.price > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("🪙", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8.w),
                  Text(
                    '${item.price}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              )
            else
              const Text(
                'FREE!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final result = _avatarService.purchaseItem(item);
              Get.back();
              if (result.success) {
                Get.snackbar(
                  'Purchase Successful!',
                  'You now own ${item.name}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Purchase Failed',
                  result.message,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: Text(item.price == 0 ? 'Get' : 'Buy'),
          ),
        ],
      ),
    );
  }
}
