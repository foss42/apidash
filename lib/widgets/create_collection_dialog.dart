import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:apidash/models/models.dart';

// Import the Postman collection model
import 'package:postman/postman.dart';

class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({Key? key}) : super(key: key);

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Then use this conversion in your onPressed handler
  Collection convertToCollection(PostmanCollection postman) {
    return Collection(
      id: postman.info?.postmanId ?? '',
      name: postman.info!.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Collection'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Collection Name',
                hintText: 'Enter collection name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a collection name';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter collection description',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
        // In your onPressed handler:
        onPressed: () {
    if (_formKey.currentState!.validate()) {
    final postmanCollection = PostmanCollection( info: Info(
    postmanId: const Uuid().v4(), // Generate a UUID for the collection
    name: _nameController.text,
    schema: "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
    ),
    item: [], // Initialize with empty items list
    );
    final collection = convertToCollection(postmanCollection);
    Navigator.of(context).pop(collection);
    }
    }
          ,
          child: const Text('Create'),
        ),
      ],
    );
  }
}