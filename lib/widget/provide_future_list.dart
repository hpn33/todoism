import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProvideFutureList<T> extends StatelessWidget {
  final AsyncValue<List<T>> futureProvider;
  final Widget Function(BuildContext, T) itemBuilder;

  const ProvideFutureList({
    Key? key,
    required this.futureProvider,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return futureProvider.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => itemBuilder(context, data[index]),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (o, s) {
        return Center(child: Text('$o\n$s'));
      },
    );
  }
}
