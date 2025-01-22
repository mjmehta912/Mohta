import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_details/controllers/item_details_controller.dart';
import 'package:mohta_app/features/item_details/widgets/item_detail_card_row.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_card.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';

class ItemDetailsScreen extends StatefulWidget {
  final int selectedTabIndex;
  final String prCode;
  final String iCode;
  final String pCode;

  const ItemDetailsScreen({
    super.key,
    required this.selectedTabIndex,
    required this.prCode,
    required this.iCode,
    required this.pCode,
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
      pCode: widget.pCode,
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
                  Tab(text: 'Price'),
                  Tab(text: 'Cmp Stock'),
                  Tab(text: 'Stock'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildViewPrice(),
                    _buildCompanyStock(),
                    _buildTotalStock(),
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

  Widget _buildTotalStock() {
    return Padding(
      padding: AppPaddings.p10,
      child: Obx(
        () {
          if (_controller.totalStockList.isEmpty &&
              !_controller.isLoading.value) {
            return Center(
              child: Text(
                'No total stock found.',
                style: TextStyles.kMediumSofiaSansSemiCondensed(),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.totalStockList.length,
            itemBuilder: (context, index) {
              final totalStock = _controller.totalStockList[index];

              return AppCard(
                child: Padding(
                  padding: AppPaddings.p10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemDetailCardRow(
                        title: 'Bill Date',
                        value: totalStock.billDate,
                        color: totalStock.days > 720
                            ? kColorRed
                            : totalStock.days < 360
                                ? kColorTextPrimary
                                : kColorBlue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Qty',
                            value: totalStock.qty.toString(),
                            color: totalStock.days > 720
                                ? kColorRed
                                : totalStock.days < 360
                                    ? kColorTextPrimary
                                    : kColorBlue,
                          ),
                          if (totalStock.rate != 0.0 || totalStock.rate != 0.00)
                            ItemDetailCardRow(
                              title: 'Rate',
                              value: totalStock.rate.toString(),
                              color: totalStock.days > 720
                                  ? kColorRed
                                  : totalStock.days < 360
                                      ? kColorTextPrimary
                                      : kColorBlue,
                            ),
                        ],
                      ),
                      ItemDetailCardRow(
                        title: 'Days',
                        value: totalStock.days.toString(),
                        color: totalStock.days > 720
                            ? kColorRed
                            : totalStock.days < 360
                                ? kColorTextPrimary
                                : kColorBlue,
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCompanyStock() {
    return Padding(
      padding: AppPaddings.p10,
      child: Obx(
        () {
          if (_controller.companyStockList.isEmpty &&
              !_controller.isLoading.value) {
            return Center(
              child: Text(
                'No company stock found.',
                style: TextStyles.kMediumSofiaSansSemiCondensed(),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.companyStockList.length,
            itemBuilder: (context, index) {
              final companyStock = _controller.companyStockList[index];

              return AppCard(
                child: Padding(
                  padding: AppPaddings.p10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Company',
                            value: companyStock.cmp,
                          ),
                          ItemDetailCardRow(
                            title: 'Total Stock',
                            value: companyStock.totalStk.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Damage',
                            value: companyStock.damage.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Resv Stock',
                            value: companyStock.resvStk.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Godown Stock',
                            value: companyStock.godownStk.isNotEmpty
                                ? companyStock.godownStk.toString()
                                : 'N/A',
                          ),
                          ItemDetailCardRow(
                            title: 'SO Qty',
                            value: companyStock.soQty.toString(),
                          ),
                        ],
                      ),
                      ItemDetailCardRow(
                        title: 'Card Stock',
                        value: companyStock.cardStk != null &&
                                companyStock.cardStk!.isNotEmpty
                            ? companyStock.cardStk!
                            : 'N/A',
                      ),
                      Visibility(
                        visible: companyStock.godownStk.isNotEmpty,
                        child: Column(
                          children: [
                            AppSpaces.v10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await _controller.getGodownStock(
                                      iCode: widget.iCode,
                                      coCode: companyStock.cocode.toString(),
                                    );

                                    showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Godown Stock',
                                            style: TextStyles
                                                .kMediumSofiaSansSemiCondensed(
                                              color: kColorPrimary,
                                              fontSize: FontSizes.k24FontSize,
                                            ),
                                          ),
                                          content: Obx(
                                            () {
                                              if (_controller.isLoading.value) {
                                                return const SizedBox.shrink();
                                              }

                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: _controller
                                                    .godownStockList
                                                    .map(
                                                  (stock) {
                                                    return ListTile(
                                                      title: Text(
                                                        stock.goDownName,
                                                        style: TextStyles
                                                            .kRegularSofiaSansSemiCondensed(
                                                          fontSize: FontSizes
                                                              .k18FontSize,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        stock.qty.toString(),
                                                        style: TextStyles
                                                            .kRegularSofiaSansSemiCondensed(
                                                          fontSize: FontSizes
                                                              .k18FontSize,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                              );
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Close',
                                                style: TextStyles
                                                    .kMediumSofiaSansSemiCondensed(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                  color: kColorPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'View Godown Stock',
                                    style: TextStyles
                                        .kMediumSofiaSansSemiCondensed(
                                      color: kColorPrimary,
                                      fontSize: FontSizes.k18FontSize,
                                    ).copyWith(
                                      height: 1.25,
                                      decoration: TextDecoration.underline,
                                      decorationColor: kColorPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }

  Padding _buildViewPrice() {
    return Padding(
      padding: AppPaddings.p10,
      child: Obx(
        () {
          if (_controller.priceList.isEmpty && !_controller.isLoading.value) {
            return Center(
              child: Text(
                'No prices found.',
                style: TextStyles.kMediumSofiaSansSemiCondensed(),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.priceList.length,
            itemBuilder: (context, index) {
              final price = _controller.priceList[index];

              return AppCard(
                child: Padding(
                  padding: AppPaddings.p10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemDetailCardRow(
                        title: 'Price Head',
                        value: price.priceHead,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Prev. Price',
                            value: price.prvPrice.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Price',
                            value: price.price.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Max Disc %',
                            value: price.maxDiscP.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Max Disc Amt',
                            value: price.maxDiscA.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Min SRate',
                            value: price.minSRate.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Market Price',
                            value: price.marketPrice.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'I/W',
                            value: price.iw,
                          ),
                          ItemDetailCardRow(
                            title: 'O/W',
                            value: price.ow,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
