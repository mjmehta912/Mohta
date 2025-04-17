import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_details/controllers/item_details_controller.dart';
import 'package:mohta_app/features/item_details/widgets/item_detail_card_row.dart';
import 'package:mohta_app/features/utils/extensions/app_size_extensions.dart';
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
    print(widget.pCode);
    initialize();
    _tabController = TabController(
      length: 2,
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
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildViewPrice(),
                    _buildCompanyStock(),
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
                            title: 'Godown Stock',
                            value: companyStock.godownStk.isNotEmpty
                                ? companyStock.godownStk.toString()
                                : 'N/A',
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
                      AppSpaces.v10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: companyStock.godownStk.isNotEmpty,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await _controller.getGodownStock(
                                          iCode: widget.iCode,
                                          coCode:
                                              companyStock.cocode.toString(),
                                        );

                                        showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: kColorWhite,
                                              title: Text(
                                                'Godown Stock',
                                                style: TextStyles
                                                    .kMediumSofiaSansSemiCondensed(
                                                  color: kColorPrimary,
                                                  fontSize:
                                                      FontSizes.k24FontSize,
                                                ),
                                              ),
                                              content: Obx(
                                                () {
                                                  if (_controller
                                                      .isLoading.value) {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                            stock.qty
                                                                .toString(),
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
                          GestureDetector(
                            onTap: () async {
                              await _controller.getItemStock(
                                iCode: widget.iCode,
                                coCode: companyStock.cocode.toString(),
                              );

                              showDialog(
                                context: Get.context!,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: kColorWhite,
                                    title: Text(
                                      'Item Stock',
                                      style: TextStyles
                                          .kMediumSofiaSansSemiCondensed(
                                        color: kColorPrimary,
                                        fontSize: FontSizes.k24FontSize,
                                      ),
                                    ),
                                    content: Obx(
                                      () {
                                        if (_controller.isLoading.value) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        if (_controller.itemStockList.isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'No details available.',
                                              style: TextStyles
                                                  .kMediumSofiaSansSemiCondensed(
                                                fontSize: FontSizes.k18FontSize,
                                                color: kColorTextPrimary,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }

                                        return ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: 0.4
                                                .screenHeight, // Maximum height before scrolling
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // Border radius
                                                child: DataTable(
                                                  columnSpacing: 20,
                                                  border: TableBorder.all(
                                                    color: kColorGrey,
                                                    width: 1,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // Border radius for the table
                                                  ),
                                                  headingRowColor:
                                                      MaterialStateProperty.all(
                                                    kColorPrimary,
                                                  ),
                                                  columns: [
                                                    DataColumn(
                                                      label: Text(
                                                        'QTY',
                                                        style: TextStyles
                                                            .kBoldSofiaSansSemiCondensed(
                                                          color: kColorWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'DAYS',
                                                        style: TextStyles
                                                            .kBoldSofiaSansSemiCondensed(
                                                          color: kColorWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'RATE',
                                                        style: TextStyles
                                                            .kBoldSofiaSansSemiCondensed(
                                                          color: kColorWhite,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  rows: _controller
                                                      .itemStockList
                                                      .asMap()
                                                      .entries
                                                      .map(
                                                    (entry) {
                                                      final index = entry.key;
                                                      final stock = entry.value;
                                                      return DataRow(
                                                        color:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>(
                                                          (states) {
                                                            // Alternate row colors: white and cream
                                                            return index.isEven
                                                                ? Colors.white
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    240,
                                                                    221,
                                                                    214); // Cream color
                                                          },
                                                        ),
                                                        cells: [
                                                          DataCell(Text(
                                                            stock.qty
                                                                .toString(),
                                                            style: TextStyles
                                                                .kMediumSofiaSansSemiCondensed(
                                                              fontSize: FontSizes
                                                                  .k16FontSize,
                                                              color:
                                                                  kColorTextPrimary,
                                                            ),
                                                          )),
                                                          DataCell(Text(
                                                            stock.days
                                                                .toString(),
                                                            style: TextStyles
                                                                .kMediumSofiaSansSemiCondensed(
                                                              fontSize: FontSizes
                                                                  .k16FontSize,
                                                              color:
                                                                  kColorTextPrimary,
                                                            ),
                                                          )),
                                                          DataCell(Text(
                                                            stock.rate
                                                                .toString(),
                                                            style: TextStyles
                                                                .kMediumSofiaSansSemiCondensed(
                                                              fontSize: FontSizes
                                                                  .k16FontSize,
                                                              color:
                                                                  kColorTextPrimary,
                                                            ),
                                                          )),
                                                        ],
                                                      );
                                                    },
                                                  ).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                            fontSize: FontSizes.k16FontSize,
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
                              'View Stock',
                              style: TextStyles.kMediumSofiaSansSemiCondensed(
                                color: kColorPrimary,
                                fontSize: FontSizes.k18FontSize,
                              ).copyWith(
                                height: 1.25,
                                decoration: TextDecoration.underline,
                                decorationColor: kColorPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
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
                        title: 'Curr. ALP',
                        value: price.price.toString(),
                      ),
                      ItemDetailCardRow(
                        title: 'Max Disc %',
                        value: price.maxDiscP.toString(),
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
