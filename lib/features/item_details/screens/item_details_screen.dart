import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_details/controllers/item_details_controller.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';

class ItemDetailsScreen extends StatefulWidget {
  final int selectedTabIndex;
  final String prCode;
  final String iCode;

  const ItemDetailsScreen({
    super.key,
    required this.selectedTabIndex,
    required this.prCode,
    required this.iCode,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final ItemDetailsController _controller = Get.put(
    ItemDetailsController(),
  );

  @override
  void initState() {
    super.initState();
    initialize();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.selectedTabIndex,
    );
  }

  void initialize() async {
    await _controller.getItemDetail(
      prCode: widget.prCode,
      iCode: widget.iCode,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: 'Item Details',
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kColorTextPrimary,
                size: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelStyle: TextStyles.kSemiBoldSofiaSansSemiCondensed(
                  color: kColorPrimary,
                  fontSize: FontSizes.k18FontSize,
                ),
                unselectedLabelColor: kColorGrey,
                indicatorColor: kColorPrimary,
                tabs: const [
                  Tab(text: 'View Price'),
                  Tab(text: 'Change Stock'),
                  Tab(text: 'Total Stock'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    Center(child: Text('View Price Content')),
                    Center(child: Text('Change Stock Content')),
                    Center(child: Text('Total Stock Content')),
                  ],
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
