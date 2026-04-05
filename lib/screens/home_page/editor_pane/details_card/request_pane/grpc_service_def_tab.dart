import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class GrpcServiceDefTab extends ConsumerWidget {
  const GrpcServiceDefTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final connectionInfo = ref.watch(grpcConnectionProvider(selectedId));
    final services = connectionInfo.services;

    if (connectionInfo.state != GrpcConnectionState.connected ||
        services.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            kVSpacer10,
            Text(
              connectionInfo.state != GrpcConnectionState.connected
                  ? kMsgGrpcConnectFirst
                  : kMsgGrpcNoServices,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: kP8,
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          margin: kPv2,
          child: ExpansionTile(
            title: Text(
              service.serviceName,
              style: kCodeStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "${service.methods.length} method${service.methods.length != 1 ? 's' : ''}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            initiallyExpanded: true,
            children: service.methods.map((method) {
              final callTypeLabel = switch (method.callType) {
                GrpcCallType.unary => "Unary",
                GrpcCallType.serverStreaming => "Server Streaming",
                GrpcCallType.clientStreaming => "Client Streaming",
                GrpcCallType.bidirectional => "Bidirectional",
              };
              return ListTile(
                dense: true,
                leading: Icon(
                  _callTypeIcon(method.callType),
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  method.methodName,
                  style: kCodeStyle.copyWith(fontSize: 13),
                ),
                subtitle: Text(
                  "$callTypeLabel  •  ${method.inputTypeName} → ${method.outputTypeName}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Text(
                  method.fullPath,
                  style: kCodeStyle.copyWith(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  IconData _callTypeIcon(GrpcCallType type) {
    return switch (type) {
      GrpcCallType.unary => Icons.arrow_forward,
      GrpcCallType.serverStreaming => Icons.arrow_downward,
      GrpcCallType.clientStreaming => Icons.arrow_upward,
      GrpcCallType.bidirectional => Icons.swap_vert,
    };
  }
}
