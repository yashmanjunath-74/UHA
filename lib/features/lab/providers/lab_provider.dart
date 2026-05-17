import 'package:flutter_riverpod/flutter_riverpod.dart';

class LabFilter extends Notifier<String> {
  @override
  String build() => 'All';

  void update(String value) => state = value;
}

final labFilterProvider = NotifierProvider<LabFilter, String>(LabFilter.new);
