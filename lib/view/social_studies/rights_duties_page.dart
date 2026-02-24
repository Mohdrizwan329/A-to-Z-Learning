import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/view%20model/rights_duties_controller/rights_duties_controller.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

class RightsDutiesPage extends StatefulWidget {
  const RightsDutiesPage({super.key});

  @override
  State<RightsDutiesPage> createState() => _RightsDutiesPageState();
}

class _RightsDutiesPageState extends State<RightsDutiesPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  late final RightsDutiesController controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RightsDutiesController());
    _tabController = TabController(length: 2, vsync: this);
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Rights & Duties',
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
          onPressed: () => controller.resetProgress(),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'My Rights'),
          Tab(text: 'My Duties'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(
            progressKey: ProgressService.kRights,
            listBuilder: _buildRightsList,
          ),
          _buildTabContent(
            progressKey: ProgressService.kDuties,
            listBuilder: _buildDutiesList,
          ),
        ],
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildTabContent({
    required String progressKey,
    required Widget Function() listBuilder,
  }) {
    return Column(
      children: [
        Obx(() {
          final progress =
              ProgressService.to.getProgressPercentage(progressKey) / 100;
          final progressString =
              ProgressService.to.getProgressString(progressKey);
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$progressString completed',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        Expanded(child: listBuilder()),
      ],
    );
  }

  Widget _buildRightsList() {
    return ListView.builder(
      key: const ValueKey('rights'),
      padding: const EdgeInsets.all(16),
      itemCount: controller.rights.length,
      itemBuilder: (context, index) {
        final right = controller.rights[index];
        final gradient = AppColors.getGradientForIndex(index);

        return Obx(() {
          final isCompleted = controller.isRightCompleted(index);

          return buildFloatingItem(
            index: index,
            child: _buildExpandableCard(
              item: right,
              gradient: gradient,
              isCompleted: isCompleted,
              detailKey: 'example',
              detailLabel: 'Example:',
              detailEmoji: '💡',
              onExpand: () => controller.markRightRead(index, right['title']),
            ),
          );
        });
      },
    );
  }

  Widget _buildDutiesList() {
    return ListView.builder(
      key: const ValueKey('duties'),
      padding: const EdgeInsets.all(16),
      itemCount: controller.duties.length,
      itemBuilder: (context, index) {
        final duty = controller.duties[index];
        final gradient = AppColors.getGradientForIndex(index + 8);

        return Obx(() {
          final isCompleted = controller.isDutyCompleted(index);

          return buildFloatingItem(
            index: index,
            child: _buildExpandableCard(
              item: duty,
              gradient: gradient,
              isCompleted: isCompleted,
              detailKey: 'howTo',
              detailLabel: 'How to do it:',
              detailEmoji: '✅',
              onExpand: () => controller.markDutyRead(index, duty['title']),
            ),
          );
        });
      },
    );
  }

  Widget _buildExpandableCard({
    required Map<String, dynamic> item,
    required List<Color> gradient,
    required bool isCompleted,
    required String detailKey,
    required String detailLabel,
    required String detailEmoji,
    required VoidCallback onExpand,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -15,
            left: -15,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Content
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (expanded) {
                  if (expanded) onExpand();
                },
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white70,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(item['emoji'], style: const TextStyle(fontSize: 28)),
                  ),
                ),
                title: Text(
                  item['title'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  item['description'],
                  style: GoogleFonts.nunito(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(detailEmoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detailLabel,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                item[detailKey],
                                style: GoogleFonts.nunito(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // Checkmark for completed
          if (isCompleted)
            Positioned(
              top: 8,
              right: 40,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
