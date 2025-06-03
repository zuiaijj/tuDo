import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/common/log/td_logger.dart';
import 'package:tudo/common/toast/common_toast.dart';
import 'package:tudo/pages/login/login_step/country_code/country_code_info.dart';
import 'package:tudo/pages/login/login_step/country_code/country_code_model.dart';
import 'package:tudo/pages/login/login_step/country_code/country_pick_page.dart';
import 'package:tudo/pages/login/login_step/country_code/support_defalut_country.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/string_tool.dart';

class CountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryCodeModel>? onChanged;
  final ValueChanged<CountryCodeModel?>? onInit;
  final String? initialSelection;

  /// Barrier color of ModalBottomSheet
  final Color? barrierColor;

  /// Background color of ModalBottomSheet
  final Color? backgroundColor;

  const CountryCodePicker({
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.barrierColor,
    this.backgroundColor,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CountryCodePickerState();
}

class CountryCodePickerState extends State<CountryCodePicker> {
  CountryCodeModel? selectedItem;
  List<CountryCodeModel> elements = [];
  // LoginController phoneLoginController = Get.find<LoginController>();
  final Completer _getConfigCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toCountryCodePickerPage(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(top: 9.h, bottom: 9.h),
        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // buildFlagImage(selectedItem!),
            // const SizedBox(width: 10),
            Text(
              selectedItem.toString(),
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  buildFlagImage(CountryCodeModel? e) {
    if (e == null) {
      return Container();
    }
    TdLogger.i("flagUri = ${e.flagUri} \nflagUrl =${e.flagUrl}");
    if (e.flagUrl.isSafeNotEmpty) {
      if (e.flagUrl!.contains("http")) {
        return CachedNetworkImage(
          imageUrl: e.flagUrl!,
          width: 24,
          height: 18,
          fit: BoxFit.contain,
          cacheKey: e.flagUrl!,
          placeholder: (context, url) => Container(),
        );
      }
      return Image.asset(
        e.flagUri!,
        width: 24,
        height: 18,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      e.flagUri!,
      width: 24,
      height: 18,
      fit: BoxFit.contain,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    elements = elements.map((element) => element.localize(context)).toList();
    _onInit(selectedItem);
  }

  @override
  void didUpdateWidget(CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      if (widget.initialSelection != null) {
        selectedItem = elements.firstWhere(
            (criteria) =>
                (criteria.code!.toUpperCase() ==
                    widget.initialSelection!.toUpperCase()) ||
                (criteria.dialCode == widget.initialSelection) ||
                (criteria.name!.toUpperCase() ==
                    widget.initialSelection!.toUpperCase()),
            orElse: () => elements[0]);
      } else {
        selectedItem = elements[0];
      }
      _onInit(selectedItem);
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
    requestNetData();
  }

  initData({List<CountryCodeModel>? list}) {
    if (list.isSafeEmpty) {
      elements =
          countryCodes.map((json) => CountryCodeModel.fromJson(json)).toList();
    } else if (list.isSafeNotEmpty) {
      elements.clear();
      elements.addAll(list!);
    }
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (item) =>
              (item.code!.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()) ||
              (item.dialCode == widget.initialSelection) ||
              (item.name!.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }
  }

  requestNetData() async {
    // await phoneLoginController.getPhoneLoginCountryCodeConfig();
    // if (null != phoneLoginController.countryCodeInfo) {
    //   if (phoneLoginController.countryCodeInfo?.list.isSafeNotEmpty == true) {
    //     initData(list: phoneLoginController.countryCodeInfo?.list);
    //     if (mounted) {
    //       setState(() {});
    //     }
    //   }
    // }
    if (!_getConfigCompleter.isCompleted) {
      _getConfigCompleter.complete();
    }
  }

  void toCountryCodePickerPage() async {
    var canToast = ToastTool.showLoading();
    // if (MtConfigManager.ins().appTabsModel == null) {
    //   await MtConfigManager.ins().getTabConfigData();
    // }
    // if (isEmptyList(phoneLoginController.countryCodeInfo?.list)) {
    //   await _getConfigCompleter.future;
    // }
    canToast();
    Get.to(() => CountryPickPage(
          list: CountryCodeInfo.defaultList().list,
          recommend: CountryCodeInfo.defaultList().recommend,
          // recommend: phoneLoginController.countryCodeInfo?.recommend,
          onSelected: (item) {
            setState(() {
              selectedItem = item;
            });
            _publishSelection(item);
          },
        ));
  }

  void _publishSelection(CountryCodeModel countryCode) {
    if (widget.onChanged != null) {
      widget.onChanged!(countryCode);
    }
  }

  void _onInit(CountryCodeModel? countryCode) {
    if (widget.onInit != null) {
      widget.onInit!(countryCode);
    }
  }
}
