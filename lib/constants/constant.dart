import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFFF0FDF4);
const ksplashlogoAssetsPath = 'assets/wlc_logo.png';
const kAppName = 'EduWLC';

const kPrimaryColor = Color(0xFF059669);
const kSecondaryColor = Color(0xFF64748B);
const kAccentColor = Color(0xFFF59E0B);
const kWhiteColor = Color(0xFFFFFFFF);
const kGreyColor = Color(0xFF94A3B8);
const kDarkGreyColor = Color(0xFF064E3B);
const kLightGreyColor = Color(0xFFDCFCE7);

const kPrimary50 = Color(0xFFF0FDF4);
const kPrimary100 = Color(0xFFDCFCE7);
const kPrimary200 = Color(0xFFBBF7D0);
const kPrimary300 = Color(0xFF86EFAC);
const kPrimary400 = Color(0xFF4ADE80);
const kPrimary500 = Color(0xFF10B981);
const kPrimary600 = Color(0xFF059669);
const kPrimary700 = Color(0xFF047857);
const kPrimary800 = Color(0xFF065F46);
const kPrimary900 = Color(0xFF064E3B);

const kDark800 = Color(0xFF064E3B);
const kDark900 = Color(0xFF022C22);

const kSuccessColor = Color(0xFF10B981);
const kWarningColor = Color(0xFFF59E0B);
const kDangerColor = Color(0xFFEF4444);
const kInfoColor = Color(0xFF3B82F6);

const kCategoryColor = Color(0xFF4ADE80);
const kBoutiqueColor = Color(0xFF047857);
const kFreeColor = Color(0xFF10B981);
const kBookstoreColor = Color(0xFF065F46);
const kLiveColor = Color(0xFF86EFAC);
const kLeaderboardColor = Color(0xFF059669);

class Constant {
  static const url = "http://192.168.1.3";

  static String resolveUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) return '';

    String processedUrl = originalUrl.trim();
    final baseUrl = Constant.url;
    final localHosts = ['scms.local', '192.168.1.3:8200'];

    String cleanBaseUrl =
        baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl;

    for (var host in localHosts) {
      if (processedUrl.contains(host)) {
        processedUrl = processedUrl.replaceAll(
          RegExp('https?://$host(:\\d+)?'),
          cleanBaseUrl,
        );
      }
    }

    try {
      return Uri.encodeFull(Uri.decodeFull(processedUrl));
    } catch (e) {
      return processedUrl.replaceAll(' ', '%20');
    }
  }
}
