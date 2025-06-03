// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About me`
  String get about_me {
    return Intl.message('About me', name: 'about_me', desc: '', args: []);
  }

  /// `Account and Security`
  String get account_and_security {
    return Intl.message(
      'Account and Security',
      name: 'account_and_security',
      desc: '',
      args: [],
    );
  }

  /// `Album not authorized`
  String get album_not_authorized {
    return Intl.message(
      'Album not authorized',
      name: 'album_not_authorized',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and_no_trim {
    return Intl.message('and', name: 'and_no_trim', desc: '', args: []);
  }

  /// `Apply for deleteing ID`
  String get apply_for_deleting {
    return Intl.message(
      'Apply for deleteing ID',
      name: 'apply_for_deleting',
      desc: '',
      args: [],
    );
  }

  /// `beautiful`
  String get beautiful {
    return Intl.message('beautiful', name: 'beautiful', desc: '', args: []);
  }

  /// `B`
  String get billion {
    return Intl.message('B', name: 'billion', desc: '', args: []);
  }

  /// `Bills`
  String get bills {
    return Intl.message('Bills', name: 'bills', desc: '', args: []);
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `Birthday`
  String get birthday {
    return Intl.message('Birthday', name: 'birthday', desc: '', args: []);
  }

  /// `Blacklist`
  String get blacklist {
    return Intl.message('Blacklist', name: 'blacklist', desc: '', args: []);
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Buy`
  String get buy {
    return Intl.message('Buy', name: 'buy', desc: '', args: []);
  }

  /// `Read and agree`
  String get by_signing_up {
    return Intl.message(
      'Read and agree',
      name: 'by_signing_up',
      desc: '',
      args: [],
    );
  }

  /// `Camera not authorized`
  String get camera_not_authorized {
    return Intl.message(
      'Camera not authorized',
      name: 'camera_not_authorized',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Chat`
  String get chats {
    return Intl.message('Chat', name: 'chats', desc: '', args: []);
  }

  /// `Child Safety Policy`
  String get child_safety_policy {
    return Intl.message(
      'Child Safety Policy',
      name: 'child_safety_policy',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a {clear} and {beautiful} avatar`
  String choose_avatar_tip(Object clear, Object beautiful) {
    return Intl.message(
      'Please upload a $clear and $beautiful avatar',
      name: 'choose_avatar_tip',
      desc: '',
      args: [clear, beautiful],
    );
  }

  /// `Select Your avatar`
  String get choose_your_avatar {
    return Intl.message(
      'Select Your avatar',
      name: 'choose_your_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Birthday`
  String get choose_your_birth {
    return Intl.message(
      'Select Your Birthday',
      name: 'choose_your_birth',
      desc: '',
      args: [],
    );
  }

  /// `clear`
  String get clear {
    return Intl.message('clear', name: 'clear', desc: '', args: []);
  }

  /// `Continue`
  String get common_continue {
    return Intl.message(
      'Continue',
      name: 'common_continue',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get common_copy {
    return Intl.message('Copy', name: 'common_copy', desc: '', args: []);
  }

  /// `day`
  String get common_day {
    return Intl.message('day', name: 'common_day', desc: '', args: []);
  }

  /// `Delete`
  String get common_delete {
    return Intl.message('Delete', name: 'common_delete', desc: '', args: []);
  }

  /// `Skip`
  String get common_skip {
    return Intl.message('Skip', name: 'common_skip', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Confirm Deletion`
  String get confirm_delete {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirm_delete',
      desc: '',
      args: [],
    );
  }

  /// `Copied successfully`
  String get copy_success {
    return Intl.message(
      'Copied successfully',
      name: 'copy_success',
      desc: '',
      args: [],
    );
  }

  /// `Select country/region`
  String get country_select_page_title {
    return Intl.message(
      'Select country/region',
      name: 'country_select_page_title',
      desc: '',
      args: [],
    );
  }

  /// `What should we call you?`
  String get create_nick_tip {
    return Intl.message(
      'What should we call you?',
      name: 'create_nick_tip',
      desc: '',
      args: [],
    );
  }

  /// `Create your nickname`
  String get create_nick_title {
    return Intl.message(
      'Create your nickname',
      name: 'create_nick_title',
      desc: '',
      args: [],
    );
  }

  /// `Creating error payment order. Please try again.`
  String get create_order_error {
    return Intl.message(
      'Creating error payment order. Please try again.',
      name: 'create_order_error',
      desc: '',
      args: [],
    );
  }

  /// `Input your name`
  String get create_your_nick {
    return Intl.message(
      'Input your name',
      name: 'create_your_nick',
      desc: '',
      args: [],
    );
  }

  /// `In order to protect the security of your account, please confirm whether you need to back up important information before deleting the account. The deletion is irreversible, please operate with caution. If you have any questions, please contact customer service.`
  String get del_in_order {
    return Intl.message(
      'In order to protect the security of your account, please confirm whether you need to back up important information before deleting the account. The deletion is irreversible, please operate with caution. If you have any questions, please contact customer service.',
      name: 'del_in_order',
      desc: '',
      args: [],
    );
  }

  /// `The contents of the account will be cleared`
  String get del_tip_account_clean {
    return Intl.message(
      'The contents of the account will be cleared',
      name: 'del_tip_account_clean',
      desc: '',
      args: [],
    );
  }

  /// `Including chat history, personal information and other information will be cleared`
  String get del_tip_account_clean1 {
    return Intl.message(
      'Including chat history, personal information and other information will be cleared',
      name: 'del_tip_account_clean1',
      desc: '',
      args: [],
    );
  }

  /// `The account cannot be recovered after deletion`
  String get del_tip_can_not_1 {
    return Intl.message(
      'The account cannot be recovered after deletion',
      name: 'del_tip_can_not_1',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm whether you need to delete the account, it cannot be recovered after deletion`
  String get del_tip_can_not_2 {
    return Intl.message(
      'Please confirm whether you need to delete the account, it cannot be recovered after deletion',
      name: 'del_tip_can_not_2',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to recall your account cancellation?`
  String get delete_ask {
    return Intl.message(
      'Are you sure to recall your account cancellation?',
      name: 'delete_ask',
      desc: '',
      args: [],
    );
  }

  /// `Deletion instructions`
  String get delete_instruction {
    return Intl.message(
      'Deletion instructions',
      name: 'delete_instruction',
      desc: '',
      args: [],
    );
  }

  /// `After deleting your account, you will not be able to use your current account`
  String get delete_tip_1 {
    return Intl.message(
      'After deleting your account, you will not be able to use your current account',
      name: 'delete_tip_1',
      desc: '',
      args: [],
    );
  }

  /// `After deleting your account, you will not be able to use your current account`
  String get delete_tip_2 {
    return Intl.message(
      'After deleting your account, you will not be able to use your current account',
      name: 'delete_tip_2',
      desc: '',
      args: [],
    );
  }

  /// `Your personal information will be deleted and cannot be retrieved`
  String get delete_tip_3 {
    return Intl.message(
      'Your personal information will be deleted and cannot be retrieved',
      name: 'delete_tip_3',
      desc: '',
      args: [],
    );
  }

  /// `Dislike`
  String get dislike {
    return Intl.message('Dislike', name: 'dislike', desc: '', args: []);
  }

  /// `You disliked him/her`
  String get dislike_toast {
    return Intl.message(
      'You disliked him/her',
      name: 'dislike_toast',
      desc: '',
      args: [],
    );
  }

  /// `Edit information`
  String get edit_info {
    return Intl.message(
      'Edit information',
      name: 'edit_info',
      desc: '',
      args: [],
    );
  }

  /// `Please edit`
  String get edit_info_hint {
    return Intl.message(
      'Please edit',
      name: 'edit_info_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code just sent to your phone`
  String get enter_v_code_tip {
    return Intl.message(
      'Enter the verification code just sent to your phone',
      name: 'enter_v_code_tip',
      desc: '',
      args: [],
    );
  }

  /// `Equip`
  String get equip {
    return Intl.message('Equip', name: 'equip', desc: '', args: []);
  }

  /// `Expense`
  String get expenditure {
    return Intl.message('Expense', name: 'expenditure', desc: '', args: []);
  }

  /// `Failed`
  String get fail {
    return Intl.message('Failed', name: 'fail', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Unable to connect to Google services`
  String get google_service_error {
    return Intl.message(
      'Unable to connect to Google services',
      name: 'google_service_error',
      desc: '',
      args: [],
    );
  }

  /// `Already worn`
  String get has_worn {
    return Intl.message('Already worn', name: 'has_worn', desc: '', args: []);
  }

  /// `Deepmeet`
  String get home {
    return Intl.message('Deepmeet', name: 'home', desc: '', args: []);
  }

  /// `Clear chat records`
  String get im_clear_msg {
    return Intl.message(
      'Clear chat records',
      name: 'im_clear_msg',
      desc: '',
      args: [],
    );
  }

  /// `Deepmeet Team`
  String get im_official {
    return Intl.message(
      'Deepmeet Team',
      name: 'im_official',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get im_title {
    return Intl.message('Messages', name: 'im_title', desc: '', args: []);
  }

  /// `Unknown news type, please upgrade to the latest version`
  String get im_unknown_message {
    return Intl.message(
      'Unknown news type, please upgrade to the latest version',
      name: 'im_unknown_message',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message('Income', name: 'income', desc: '', args: []);
  }

  /// `Insult`
  String get insult {
    return Intl.message('Insult', name: 'insult', desc: '', args: []);
  }

  /// `English`
  String get language_eng {
    return Intl.message('English', name: 'language_eng', desc: '', args: []);
  }

  /// `ไทย`
  String get language_th {
    return Intl.message('ไทย', name: 'language_th', desc: '', args: []);
  }

  /// `Language`
  String get language_title {
    return Intl.message('Language', name: 'language_title', desc: '', args: []);
  }

  /// `繁體中文`
  String get language_tw {
    return Intl.message('繁體中文', name: 'language_tw', desc: '', args: []);
  }

  /// `Tiếng Việt`
  String get language_vi {
    return Intl.message('Tiếng Việt', name: 'language_vi', desc: '', args: []);
  }

  /// `简体中文`
  String get language_zh {
    return Intl.message('简体中文', name: 'language_zh', desc: '', args: []);
  }

  /// `LOG OUT`
  String get log_out {
    return Intl.message('LOG OUT', name: 'log_out', desc: '', args: []);
  }

  /// `Login by phone number`
  String get login_by_phone {
    return Intl.message(
      'Login by phone number',
      name: 'login_by_phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter SMS code`
  String get login_code_hint {
    return Intl.message(
      'Enter SMS code',
      name: 'login_code_hint',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get login_continue {
    return Intl.message('Continue', name: 'login_continue', desc: '', args: []);
  }

  /// `Log in`
  String get login_in {
    return Intl.message('Log in', name: 'login_in', desc: '', args: []);
  }

  /// `Input your nickname`
  String get login_nick_hint {
    return Intl.message(
      'Input your nickname',
      name: 'login_nick_hint',
      desc: '',
      args: [],
    );
  }

  /// `Login By Phone`
  String get login_phone {
    return Intl.message(
      'Login By Phone',
      name: 'login_phone',
      desc: '',
      args: [],
    );
  }

  /// `Input phone number`
  String get login_phone_hint {
    return Intl.message(
      'Input phone number',
      name: 'login_phone_hint',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get login_resend_code {
    return Intl.message(
      'Resend',
      name: 'login_resend_code',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_title {
    return Intl.message('Login', name: 'login_title', desc: '', args: []);
  }

  /// `you can request a new code in {count} seconds`
  String login_verification_code_content(Object count) {
    return Intl.message(
      'you can request a new code in $count seconds',
      name: 'login_verification_code_content',
      desc: '',
      args: [count],
    );
  }

  /// `Login Method`
  String get login_way {
    return Intl.message('Login Method', name: 'login_way', desc: '', args: []);
  }

  /// `Welcome !`
  String get login_welcome {
    return Intl.message('Welcome !', name: 'login_welcome', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Me`
  String get me_title {
    return Intl.message('Me', name: 'me_title', desc: '', args: []);
  }

  /// `Media library is not authorized`
  String get media_library_is_not_authorized {
    return Intl.message(
      'Media library is not authorized',
      name: 'media_library_is_not_authorized',
      desc: '',
      args: [],
    );
  }

  /// `M`
  String get million {
    return Intl.message('M', name: 'million', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Months`
  String get months {
    return Intl.message('Months', name: 'months', desc: '', args: []);
  }

  /// `January`
  String get mouth1 {
    return Intl.message('January', name: 'mouth1', desc: '', args: []);
  }

  /// `October`
  String get mouth10 {
    return Intl.message('October', name: 'mouth10', desc: '', args: []);
  }

  /// `November`
  String get mouth11 {
    return Intl.message('November', name: 'mouth11', desc: '', args: []);
  }

  /// `December`
  String get mouth12 {
    return Intl.message('December', name: 'mouth12', desc: '', args: []);
  }

  /// `February`
  String get mouth2 {
    return Intl.message('February', name: 'mouth2', desc: '', args: []);
  }

  /// `March`
  String get mouth3 {
    return Intl.message('March', name: 'mouth3', desc: '', args: []);
  }

  /// `April`
  String get mouth4 {
    return Intl.message('April', name: 'mouth4', desc: '', args: []);
  }

  /// `May`
  String get mouth5 {
    return Intl.message('May', name: 'mouth5', desc: '', args: []);
  }

  /// `June`
  String get mouth6 {
    return Intl.message('June', name: 'mouth6', desc: '', args: []);
  }

  /// `July`
  String get mouth7 {
    return Intl.message('July', name: 'mouth7', desc: '', args: []);
  }

  /// `August`
  String get mouth8 {
    return Intl.message('August', name: 'mouth8', desc: '', args: []);
  }

  /// `September`
  String get mouth9 {
    return Intl.message('September', name: 'mouth9', desc: '', args: []);
  }

  /// `My code is`
  String get my_code_is {
    return Intl.message('My code is', name: 'my_code_is', desc: '', args: []);
  }

  /// `Network error. Please check the network connection and try again`
  String get network_failed {
    return Intl.message(
      'Network error. Please check the network connection and try again',
      name: 'network_failed',
      desc: '',
      args: [],
    );
  }

  /// `Nick name`
  String get nick {
    return Intl.message('Nick name', name: 'nick', desc: '', args: []);
  }

  /// `Operation failed`
  String get opreation_faild {
    return Intl.message(
      'Operation failed',
      name: 'opreation_faild',
      desc: '',
      args: [],
    );
  }

  /// `Request Success`
  String get opreation_success {
    return Intl.message(
      'Request Success',
      name: 'opreation_success',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred confirming the order`
  String get pay_ack_failure {
    return Intl.message(
      'An error occurred confirming the order',
      name: 'pay_ack_failure',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get person_profile {
    return Intl.message('Profile', name: 'person_profile', desc: '', args: []);
  }

  /// `Profile`
  String get personal_profile {
    return Intl.message(
      'Profile',
      name: 'personal_profile',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get phone_number {
    return Intl.message('Number', name: 'phone_number', desc: '', args: []);
  }

  /// `Political rumors`
  String get political_rumors {
    return Intl.message(
      'Political rumors',
      name: 'political_rumors',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `To provide personalized contents for you`
  String get provider_contents_for_you {
    return Intl.message(
      'To provide personalized contents for you',
      name: 'provider_contents_for_you',
      desc: '',
      args: [],
    );
  }

  /// `Product: {productID} information cannot be queried`
  String query_production_error(Object productID) {
    return Intl.message(
      'Product: $productID information cannot be queried',
      name: 'query_production_error',
      desc: '',
      args: [productID],
    );
  }

  /// `Recharge`
  String get recharge {
    return Intl.message('Recharge', name: 'recharge', desc: '', args: []);
  }

  /// `Cancel recharge`
  String get recharge_cancel {
    return Intl.message(
      'Cancel recharge',
      name: 'recharge_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Recharge failure`
  String get recharge_failure {
    return Intl.message(
      'Recharge failure',
      name: 'recharge_failure',
      desc: '',
      args: [],
    );
  }

  /// `Recharge success`
  String get recharge_success {
    return Intl.message(
      'Recharge success',
      name: 'recharge_success',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Child sexual abuse and exploitation`
  String get report_child_abuse {
    return Intl.message(
      'Child sexual abuse and exploitation',
      name: 'report_child_abuse',
      desc: '',
      args: [],
    );
  }

  /// `Revert`
  String get revert {
    return Intl.message('Revert', name: 'revert', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Select Your Gender`
  String get select_your_gender {
    return Intl.message(
      'Select Your Gender',
      name: 'select_your_gender',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get send_auth_code {
    return Intl.message(
      'Send Code',
      name: 'send_auth_code',
      desc: '',
      args: [],
    );
  }

  /// `Set up`
  String get set_up {
    return Intl.message('Set up', name: 'set_up', desc: '', args: []);
  }

  /// `Settings`
  String get setting {
    return Intl.message('Settings', name: 'setting', desc: '', args: []);
  }

  /// `Mall`
  String get store {
    return Intl.message('Mall', name: 'store', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Switch Language`
  String get switch_language {
    return Intl.message(
      'Switch Language',
      name: 'switch_language',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get terms_service {
    return Intl.message(
      'Terms of Service',
      name: 'terms_service',
      desc: '',
      args: [],
    );
  }

  /// `K`
  String get thousand {
    return Intl.message('K', name: 'thousand', desc: '', args: []);
  }

  /// `Just now`
  String get time_just {
    return Intl.message('Just now', name: 'time_just', desc: '', args: []);
  }

  /// `Tips`
  String get tips {
    return Intl.message('Tips', name: 'tips', desc: '', args: []);
  }

  /// `Open the album in "Settings-App" to save photos normally`
  String get turn_on_the_album {
    return Intl.message(
      'Open the album in "Settings-App" to save photos normally',
      name: 'turn_on_the_album',
      desc: '',
      args: [],
    );
  }

  /// `Turn on the camera in "Settings-App" to use it normally~`
  String get turn_on_the_camera {
    return Intl.message(
      'Turn on the camera in "Settings-App" to use it normally~',
      name: 'turn_on_the_camera',
      desc: '',
      args: [],
    );
  }

  /// `Unblock`
  String get unblock {
    return Intl.message('Unblock', name: 'unblock', desc: '', args: []);
  }

  /// `Ask me`
  String get unknow_type {
    return Intl.message('Ask me', name: 'unknow_type', desc: '', args: []);
  }

  /// `Aries`
  String get user_baiyang {
    return Intl.message('Aries', name: 'user_baiyang', desc: '', args: []);
  }

  /// `Virgo`
  String get user_chinv {
    return Intl.message('Virgo', name: 'user_chinv', desc: '', args: []);
  }

  /// `Height`
  String get user_height {
    return Intl.message('Height', name: 'user_height', desc: '', args: []);
  }

  /// `Taurus`
  String get user_jinniu {
    return Intl.message('Taurus', name: 'user_jinniu', desc: '', args: []);
  }

  /// `Cancer`
  String get user_juxie {
    return Intl.message('Cancer', name: 'user_juxie', desc: '', args: []);
  }

  /// `Capricorn`
  String get user_moji {
    return Intl.message('Capricorn', name: 'user_moji', desc: '', args: []);
  }

  /// `Sagittarius`
  String get user_sheshow {
    return Intl.message(
      'Sagittarius',
      name: 'user_sheshow',
      desc: '',
      args: [],
    );
  }

  /// `Leo`
  String get user_shizi {
    return Intl.message('Leo', name: 'user_shizi', desc: '', args: []);
  }

  /// `Pisces`
  String get user_shuangyu {
    return Intl.message('Pisces', name: 'user_shuangyu', desc: '', args: []);
  }

  /// `Gemini`
  String get user_shuangzi {
    return Intl.message('Gemini', name: 'user_shuangzi', desc: '', args: []);
  }

  /// `Aquarius`
  String get user_shuiping {
    return Intl.message('Aquarius', name: 'user_shuiping', desc: '', args: []);
  }

  /// `Camera`
  String get user_take_photo {
    return Intl.message('Camera', name: 'user_take_photo', desc: '', args: []);
  }

  /// `Libra`
  String get user_tiancheng {
    return Intl.message('Libra', name: 'user_tiancheng', desc: '', args: []);
  }

  /// `Scorpio`
  String get user_tianxie {
    return Intl.message('Scorpio', name: 'user_tianxie', desc: '', args: []);
  }

  /// `OTP Verification`
  String get v_code_login {
    return Intl.message(
      'OTP Verification',
      name: 'v_code_login',
      desc: '',
      args: [],
    );
  }

  /// `Verbal harassment`
  String get verbal_harassment {
    return Intl.message(
      'Verbal harassment',
      name: 'verbal_harassment',
      desc: '',
      args: [],
    );
  }

  /// `Violent content`
  String get violent_content {
    return Intl.message(
      'Violent content',
      name: 'violent_content',
      desc: '',
      args: [],
    );
  }

  /// `Vulgar`
  String get vulgar {
    return Intl.message('Vulgar', name: 'vulgar', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `What do you want people to call you`
  String get want_call_you_ask {
    return Intl.message(
      'What do you want people to call you',
      name: 'want_call_you_ask',
      desc: '',
      args: [],
    );
  }

  /// `We will send text with a verification code.`
  String get will_send_auth {
    return Intl.message(
      'We will send text with a verification code.',
      name: 'will_send_auth',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'HK'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'MO'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
