import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tudo/common/widget/base_widget.dart';
import 'package:tudo/pages/login/login_step/country_code/country_code_model.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/intl_tool.dart';
import 'package:tudo/tool/string_tool.dart';

class CountryPickPage extends StatefulWidget {
  final List<CountryCodeModel>? list;
  final List<CountryCodeModel>? recommend;
  final Function(CountryCodeModel) onSelected;

  const CountryPickPage(
      {super.key,
      required this.list,
      required this.recommend,
      required this.onSelected});

  @override
  State<CountryPickPage> createState() => _CountryPickPageState();
}

class _CountryPickPageState extends State<CountryPickPage> {
  List<CountryCodeModel>? get list => widget.list;
  List<CountryCodeModel>? get recommend => widget.recommend;

  RxList<CountryCodeModel> all = <CountryCodeModel>[].obs;
  List<String> index = const [
    '#',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  // late TextEditingController _controller;

  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    // _controller = TextEditingController();
    _updateList();
    super.initState();
  }

  _updateList({String? searchText}) {
    List<CountryCodeModel> tmp = [];
    tmp.addAll(recommend ?? []);
    tmp.addAll(list ?? []);
    if (searchText.isSafeEmpty) {
      all.clear();
      SuspensionUtil.setShowSuspensionStatus(tmp);
      all.addAll(tmp);
    } else {
      List<CountryCodeModel> searchRes = tmp.where((v) {
        return (v.name?.toLowerCase().contains(searchText!.toLowerCase()) ==
                true) ||
            (v.code?.toLowerCase().contains(searchText!.toLowerCase()) ==
                true) ||
            (v.dialCode?.toLowerCase().contains(searchText!.toLowerCase()) ==
                true);
      }).toList();
      all.clear();
      SuspensionUtil.setShowSuspensionStatus(searchRes);
      all.addAll(searchRes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        centerTitle: true,
        shadowColor: Colors.transparent,
        title: Text(
          intlS.country_select_page_title,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        leading: appBarBack(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return Container(
                  alignment: Alignment.topCenter,
                  child: AzListView(
                    data: all,
                    itemCount: all.length,
                    physics: const ClampingScrollPhysics(),
                    itemScrollController: itemScrollController,
                    itemBuilder: (BuildContext context, int index) {
                      bool needTopLine = false;
                      CountryCodeModel model = all[index];
                      if (index > 0) {
                        CountryCodeModel last = all[index - 1];
                        needTopLine = (last.index == model.index);
                      }
                      return _item(model, needTopLine);
                    },
                    susItemBuilder: (BuildContext context, int index) {
                      return _susItem(all[index]);
                    },
                    indexBarData: index,
                    indexBarOptions: const IndexBarOptions(
                      needRebuild: true,
                      hapticFeedback: true,
                      selectTextStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      selectItemDecoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF333333)),
                      indexHintWidth: 96,
                      indexHintHeight: 97,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  _item(CountryCodeModel model, bool needTopLine) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(model);
        Get.back();
      },
      child: SizedBox(
        height: 48.h + 1,
        width: screanWidth,
        child: Column(
          children: [
            Container(
              height: 1,
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                  color: needTopLine
                      ? colorScheme.outlineVariant
                      : Colors.transparent),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  buildImage(model),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Text(
                      model.toCountryStringOnly(),
                      overflow: TextOverflow.fade,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(model.dialCode!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      )),
                  const SizedBox(width: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _susItem(CountryCodeModel model) {
    String sus = model.getSuspensionTag();
    if (sus == "#") {
      sus = "common".tr;
    }
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFF3F3F3)),
      height: 24.h,
      width: screanWidth,
      padding: const EdgeInsets.only(left: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        sus,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  buildImage(CountryCodeModel? e) {
    if (e == null) {
      return Container();
    }
    if (e.flagUrl.isSafeNotEmpty) {
      if (e.flagUrl!.contains("http")) {
        return CachedNetworkImage(
          imageUrl: e.flagUrl!,
          width: 28,
          height: 21,
          fit: BoxFit.contain,
          cacheKey: e.flagUrl!,
          placeholder: (context, url) => Container(),
        );
      }
      return Image.asset(
        e.flagUri!,
        width: 28,
        height: 21,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      e.flagUri!,
      width: 28,
      height: 21,
      fit: BoxFit.contain,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
