import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:xamraev_logistic/services/db/cache.dart';

final languageProvider = StateProvider<Locale>((ref) {
  final cachedLanguage = cache.getString('language') ?? 'uz';
  return Locale(cachedLanguage);
});
