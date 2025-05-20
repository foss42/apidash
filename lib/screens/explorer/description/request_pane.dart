import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'requests_card.dart';
import 'package:apidash/models/models.dart';


class RequestsPane extends StatefulWidget {
  final List requests;
  final Function(RequestModel)? onRequestSelected;

  const RequestsPane({
    super.key,
    required this.requests,
    this.onRequestSelected,
  });

  @override
  State<RequestsPane> createState() => _RequestsPaneState();
}

class _RequestsPaneState extends State<RequestsPane> {
  RequestModel? _selectedRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.requests.length,
        itemBuilder: (context, index) {
          final request = widget.requests[index];
          final method = request.httpRequestModel?.method.toString().split('.').last.toUpperCase() ?? 'GET';
          return RequestCard(
            title: request.name,
            isSelected: _selectedRequest == request,
            method: method,
            onTap: () {
              setState(() {
                _selectedRequest = request;
              });
              widget.onRequestSelected?.call(request);
            },
          );
        },
      ),
    );
  }
}