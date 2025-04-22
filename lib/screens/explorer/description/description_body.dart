import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'request_pane.dart';
import 'description_pane.dart';

class DescriptionBody extends StatefulWidget {
  final ApiTemplate template;

  const DescriptionBody({
    super.key,
    required this.template,
  });

  @override
  State<DescriptionBody> createState() => _DescriptionBodyState();
}

class _DescriptionBodyState extends State<DescriptionBody> {
  RequestModel? _selectedRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: RequestsPane(
              requests: widget.template.requests,
              onRequestSelected: (request) {
                setState(() {
                  _selectedRequest = request;
                });
              },
            ),
          ),
          Expanded(
            child: DescriptionPane(selectedRequest: _selectedRequest),
          ),
        ],
      ),
    );
  }
}