import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'service/hive/hive_wrapper.dart';

Future<void> main() async {
  await hiveW.loadHive();

  runApp(ProviderScope(child: MyApp()));
}
