import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AvatarCoinsService extends GetxService {
  final GetStorage _box = GetStorage();

  // Coins
  final RxInt totalCoins = 0.obs;
  final RxInt lifetimeEarned = 0.obs;
  final RxInt lifetimeSpent = 0.obs;

  // Avatar customization
  final RxString selectedAvatar = 'default'.obs;
  final RxString selectedSkinTone = 'medium'.obs;
  final RxString selectedHairStyle = 'short'.obs;
  final RxString selectedHairColor = 'black'.obs;
  final RxString selectedOutfit = 'casual'.obs;
  final RxString selectedAccessory = 'none'.obs;
  final RxString selectedBackground = 'blue'.obs;
  final RxString avatarName = 'Buddy'.obs;

  // Owned items
  final RxList<String> ownedAvatars = <String>[].obs;
  final RxList<String> ownedOutfits = <String>[].obs;
  final RxList<String> ownedAccessories = <String>[].obs;
  final RxList<String> ownedBackgrounds = <String>[].obs;
  final RxList<String> ownedHairStyles = <String>[].obs;

  // Daily bonus state
  final RxBool canClaimBonus = true.obs;

  // Shop items
  static final Map<String, ShopItem> avatars = {
    'default': ShopItem(id: 'default', name: 'Default', price: 0, emoji: '🧒', category: 'avatar'),
    'boy1': ShopItem(id: 'boy1', name: 'Cool Boy', price: 100, emoji: '👦', category: 'avatar'),
    'girl1': ShopItem(id: 'girl1', name: 'Smart Girl', price: 100, emoji: '👧', category: 'avatar'),
    'robot': ShopItem(id: 'robot', name: 'Robot', price: 500, emoji: '🤖', category: 'avatar'),
    'astronaut': ShopItem(id: 'astronaut', name: 'Astronaut', price: 800, emoji: '👨‍🚀', category: 'avatar'),
    'superhero': ShopItem(id: 'superhero', name: 'Superhero', price: 1000, emoji: '🦸', category: 'avatar'),
    'wizard': ShopItem(id: 'wizard', name: 'Wizard', price: 1200, emoji: '🧙', category: 'avatar'),
    'fairy': ShopItem(id: 'fairy', name: 'Fairy', price: 1200, emoji: '🧚', category: 'avatar'),
    'ninja': ShopItem(id: 'ninja', name: 'Ninja', price: 1500, emoji: '🥷', category: 'avatar'),
    'king': ShopItem(id: 'king', name: 'King', price: 2000, emoji: '🤴', category: 'avatar'),
    'queen': ShopItem(id: 'queen', name: 'Queen', price: 2000, emoji: '👸', category: 'avatar'),
  };

  static final Map<String, ShopItem> outfits = {
    'casual': ShopItem(id: 'casual', name: 'Casual', price: 0, emoji: '👕', category: 'outfit'),
    'school': ShopItem(id: 'school', name: 'School Uniform', price: 150, emoji: '🎒', category: 'outfit'),
    'sports': ShopItem(id: 'sports', name: 'Sports', price: 200, emoji: '⚽', category: 'outfit'),
    'party': ShopItem(id: 'party', name: 'Party', price: 300, emoji: '🎉', category: 'outfit'),
    'traditional': ShopItem(id: 'traditional', name: 'Traditional', price: 400, emoji: '👘', category: 'outfit'),
    'space': ShopItem(id: 'space', name: 'Space Suit', price: 800, emoji: '🚀', category: 'outfit'),
    'royal': ShopItem(id: 'royal', name: 'Royal', price: 1000, emoji: '👑', category: 'outfit'),
  };

  static final Map<String, ShopItem> accessories = {
    'none': ShopItem(id: 'none', name: 'None', price: 0, emoji: '❌', category: 'accessory'),
    'glasses': ShopItem(id: 'glasses', name: 'Glasses', price: 100, emoji: '👓', category: 'accessory'),
    'sunglasses': ShopItem(id: 'sunglasses', name: 'Sunglasses', price: 150, emoji: '🕶️', category: 'accessory'),
    'hat': ShopItem(id: 'hat', name: 'Hat', price: 200, emoji: '🎩', category: 'accessory'),
    'crown': ShopItem(id: 'crown', name: 'Crown', price: 500, emoji: '👑', category: 'accessory'),
    'headphones': ShopItem(id: 'headphones', name: 'Headphones', price: 300, emoji: '🎧', category: 'accessory'),
    'bow': ShopItem(id: 'bow', name: 'Bow', price: 100, emoji: '🎀', category: 'accessory'),
    'cape': ShopItem(id: 'cape', name: 'Cape', price: 400, emoji: '🦸', category: 'accessory'),
    'wings': ShopItem(id: 'wings', name: 'Wings', price: 800, emoji: '🪽', category: 'accessory'),
  };

  static final Map<String, ShopItem> backgrounds = {
    'blue': ShopItem(id: 'blue', name: 'Sky Blue', price: 0, emoji: '🔵', category: 'background'),
    'green': ShopItem(id: 'green', name: 'Green Meadow', price: 100, emoji: '🌿', category: 'background'),
    'sunset': ShopItem(id: 'sunset', name: 'Sunset', price: 200, emoji: '🌅', category: 'background'),
    'space': ShopItem(id: 'space', name: 'Space', price: 300, emoji: '🌌', category: 'background'),
    'underwater': ShopItem(id: 'underwater', name: 'Underwater', price: 400, emoji: '🐠', category: 'background'),
    'rainbow': ShopItem(id: 'rainbow', name: 'Rainbow', price: 500, emoji: '🌈', category: 'background'),
    'castle': ShopItem(id: 'castle', name: 'Castle', price: 600, emoji: '🏰', category: 'background'),
    'jungle': ShopItem(id: 'jungle', name: 'Jungle', price: 400, emoji: '🌴', category: 'background'),
  };

  static final Map<String, ShopItem> hairStyles = {
    'short': ShopItem(id: 'short', name: 'Short', price: 0, emoji: '💇', category: 'hair'),
    'long': ShopItem(id: 'long', name: 'Long', price: 50, emoji: '💇‍♀️', category: 'hair'),
    'curly': ShopItem(id: 'curly', name: 'Curly', price: 100, emoji: '🌀', category: 'hair'),
    'ponytail': ShopItem(id: 'ponytail', name: 'Ponytail', price: 100, emoji: '🎀', category: 'hair'),
    'spiky': ShopItem(id: 'spiky', name: 'Spiky', price: 150, emoji: '⚡', category: 'hair'),
    'braids': ShopItem(id: 'braids', name: 'Braids', price: 200, emoji: '🧵', category: 'hair'),
  };

  // Coin earning rates
  static const Map<String, int> coinRewards = {
    'lesson_complete': 10,
    'quiz_perfect': 50,
    'quiz_pass': 20,
    'daily_goal': 30,
    'streak_3': 50,
    'streak_7': 100,
    'streak_30': 500,
    'first_login': 50,
    'daily_bonus': 15,
    'watch_ad': 25,
    'achievement': 100,
    'level_up': 200,
  };

  Future<AvatarCoinsService> init() async {
    await _loadData();
    _updateDailyBonusStatus();
    return this;
  }

  void _updateDailyBonusStatus() {
    canClaimBonus.value = canClaimDailyBonus();
  }

  Future<void> _loadData() async {
    totalCoins.value = _box.read<int>('total_coins') ?? 0;
    lifetimeEarned.value = _box.read<int>('lifetime_earned') ?? 0;
    lifetimeSpent.value = _box.read<int>('lifetime_spent') ?? 0;

    selectedAvatar.value = _box.read<String>('selected_avatar') ?? 'default';
    selectedSkinTone.value = _box.read<String>('selected_skin') ?? 'medium';
    selectedHairStyle.value = _box.read<String>('selected_hair') ?? 'short';
    selectedHairColor.value = _box.read<String>('selected_hair_color') ?? 'black';
    selectedOutfit.value = _box.read<String>('selected_outfit') ?? 'casual';
    selectedAccessory.value = _box.read<String>('selected_accessory') ?? 'none';
    selectedBackground.value = _box.read<String>('selected_background') ?? 'blue';
    avatarName.value = _box.read<String>('avatar_name') ?? 'Buddy';

    ownedAvatars.value = List<String>.from(_box.read<List>('owned_avatars') ?? ['default']);
    ownedOutfits.value = List<String>.from(_box.read<List>('owned_outfits') ?? ['casual']);
    ownedAccessories.value = List<String>.from(_box.read<List>('owned_accessories') ?? ['none']);
    ownedBackgrounds.value = List<String>.from(_box.read<List>('owned_backgrounds') ?? ['blue']);
    ownedHairStyles.value = List<String>.from(_box.read<List>('owned_hairstyles') ?? ['short']);
  }

  Future<void> _saveData() async {
    await _box.write('total_coins', totalCoins.value);
    await _box.write('lifetime_earned', lifetimeEarned.value);
    await _box.write('lifetime_spent', lifetimeSpent.value);

    await _box.write('selected_avatar', selectedAvatar.value);
    await _box.write('selected_skin', selectedSkinTone.value);
    await _box.write('selected_hair', selectedHairStyle.value);
    await _box.write('selected_hair_color', selectedHairColor.value);
    await _box.write('selected_outfit', selectedOutfit.value);
    await _box.write('selected_accessory', selectedAccessory.value);
    await _box.write('selected_background', selectedBackground.value);
    await _box.write('avatar_name', avatarName.value);

    await _box.write('owned_avatars', ownedAvatars.toList());
    await _box.write('owned_outfits', ownedOutfits.toList());
    await _box.write('owned_accessories', ownedAccessories.toList());
    await _box.write('owned_backgrounds', ownedBackgrounds.toList());
    await _box.write('owned_hairstyles', ownedHairStyles.toList());
  }

  // Earn coins
  void earnCoins(String reason, {int? customAmount}) {
    final amount = customAmount ?? coinRewards[reason] ?? 0;
    if (amount > 0) {
      totalCoins.value += amount;
      lifetimeEarned.value += amount;
      _saveData();
    }
  }

  // Spend coins
  bool spendCoins(int amount) {
    if (totalCoins.value >= amount) {
      totalCoins.value -= amount;
      lifetimeSpent.value += amount;
      _saveData();
      return true;
    }
    return false;
  }

  // Purchase item
  PurchaseResult purchaseItem(ShopItem item) {
    if (isItemOwned(item)) {
      return PurchaseResult(success: false, message: 'Already owned');
    }

    if (totalCoins.value < item.price) {
      return PurchaseResult(
        success: false,
        message: 'Not enough coins. Need ${item.price - totalCoins.value} more.',
      );
    }

    spendCoins(item.price);
    _addOwnedItem(item);
    _saveData();

    return PurchaseResult(success: true, message: 'Purchase successful!');
  }

  void _addOwnedItem(ShopItem item) {
    switch (item.category) {
      case 'avatar':
        if (!ownedAvatars.contains(item.id)) ownedAvatars.add(item.id);
        break;
      case 'outfit':
        if (!ownedOutfits.contains(item.id)) ownedOutfits.add(item.id);
        break;
      case 'accessory':
        if (!ownedAccessories.contains(item.id)) ownedAccessories.add(item.id);
        break;
      case 'background':
        if (!ownedBackgrounds.contains(item.id)) ownedBackgrounds.add(item.id);
        break;
      case 'hair':
        if (!ownedHairStyles.contains(item.id)) ownedHairStyles.add(item.id);
        break;
    }
  }

  bool isItemOwned(ShopItem item) {
    switch (item.category) {
      case 'avatar':
        return ownedAvatars.contains(item.id);
      case 'outfit':
        return ownedOutfits.contains(item.id);
      case 'accessory':
        return ownedAccessories.contains(item.id);
      case 'background':
        return ownedBackgrounds.contains(item.id);
      case 'hair':
        return ownedHairStyles.contains(item.id);
      default:
        return false;
    }
  }

  // Equip item
  void equipItem(ShopItem item) {
    if (!isItemOwned(item)) return;

    switch (item.category) {
      case 'avatar':
        selectedAvatar.value = item.id;
        break;
      case 'outfit':
        selectedOutfit.value = item.id;
        break;
      case 'accessory':
        selectedAccessory.value = item.id;
        break;
      case 'background':
        selectedBackground.value = item.id;
        break;
      case 'hair':
        selectedHairStyle.value = item.id;
        break;
    }
    _saveData();
  }

  // Set avatar name
  void setAvatarName(String name) {
    if (name.trim().isNotEmpty) {
      avatarName.value = name.trim();
      _saveData();
    }
  }

  // Set skin tone
  void setSkinTone(String tone) {
    selectedSkinTone.value = tone;
    _saveData();
  }

  // Set hair color
  void setHairColor(String color) {
    selectedHairColor.value = color;
    _saveData();
  }

  // Get current avatar display emoji
  String get currentAvatarEmoji => avatars[selectedAvatar.value]?.emoji ?? '🧒';

  // Get avatar configuration
  Map<String, String> get avatarConfig => {
        'avatar': selectedAvatar.value,
        'skinTone': selectedSkinTone.value,
        'hairStyle': selectedHairStyle.value,
        'hairColor': selectedHairColor.value,
        'outfit': selectedOutfit.value,
        'accessory': selectedAccessory.value,
        'background': selectedBackground.value,
        'name': avatarName.value,
      };

  // Daily bonus check
  bool canClaimDailyBonus() {
    final lastClaim = _box.read<String>('last_daily_bonus');
    if (lastClaim == null) return true;

    final lastDate = DateTime.tryParse(lastClaim);
    if (lastDate == null) return true;

    final now = DateTime.now();
    return now.day != lastDate.day ||
        now.month != lastDate.month ||
        now.year != lastDate.year;
  }

  void claimDailyBonus() {
    if (canClaimDailyBonus()) {
      earnCoins('daily_bonus');
      _box.write('last_daily_bonus', DateTime.now().toIso8601String());
      canClaimBonus.value = false;
    }
  }
}

class ShopItem {
  final String id;
  final String name;
  final int price;
  final String emoji;
  final String category;
  final String? description;
  final bool isPremium;

  const ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    required this.category,
    this.description,
    this.isPremium = false,
  });
}

class PurchaseResult {
  final bool success;
  final String message;

  PurchaseResult({required this.success, required this.message});
}
