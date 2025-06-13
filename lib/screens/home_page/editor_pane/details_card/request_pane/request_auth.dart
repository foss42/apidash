import 'package:apidash_core/models/auth/auth_api_key_model.dart';
import 'package:apidash_core/models/auth/auth_basic_model.dart';
import 'package:apidash_core/models/auth/auth_bearer_model.dart';
import 'package:apidash_core/models/auth/auth_jwt_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';

class EditAuthType extends ConsumerWidget {
  const EditAuthType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequest = ref.read(selectedRequestModelProvider);

    if (selectedRequest == null) {
      return const SizedBox.shrink();
    }

    final currentAuthType = ref.watch(
      selectedRequestModelProvider
          .select((request) => request?.authData?.type ?? APIAuthType.none),
    );
    final currentAuthData = selectedRequest.authData;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Authentication Type",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          DropdownButtonFormField<APIAuthType>(
            value: currentAuthType,
            elevation: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            items: APIAuthType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name.capitalize()),
              );
            }).toList(),
            onChanged: (APIAuthType? newType) {
              if (newType != null) {
                ref.read(collectionStateNotifierProvider.notifier).update(
                      authData: currentAuthData?.copyWith(type: newType) ??
                          ApiAuthModel(type: newType),
                    );
              }
            },
          ),
          const SizedBox(height: 48),
          _buildAuthFields(context, ref, currentAuthData),
        ],
      ),
    );
  }

  Widget _buildAuthFields(
    BuildContext context,
    WidgetRef ref,
    ApiAuthModel? authData,
  ) {
    void updateAuth(ApiAuthModel model) {
      ref.read(collectionStateNotifierProvider.notifier).update(
            authData: model,
          );
    }

    switch (authData?.type) {
      case APIAuthType.basic:
        final usernameController = TextEditingController(
          text: authData?.basic?.username ?? '',
        );
        final passwordController = TextEditingController(
          text: authData?.basic?.password ?? '',
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText: "Username",
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => updateAuth(
                ApiAuthModel(
                  type: APIAuthType.basic,
                  basic: AuthBasicAuthModel(
                    username: usernameController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText: "Password",
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
              onChanged: (value) => updateAuth(
                ApiAuthModel(
                  type: APIAuthType.basic,
                  basic: AuthBasicAuthModel(
                    username: usernameController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                ),
              ),
            ),
          ],
        );

      case APIAuthType.bearer:
        final tokenController = TextEditingController(
          text: authData?.bearer?.token ?? '',
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Token",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText: "Token",
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => updateAuth(
                ApiAuthModel(
                  type: APIAuthType.bearer,
                  bearer: AuthBearerModel(token: tokenController.text.trim()),
                ),
              ),
            ),
          ],
        );

      case APIAuthType.apiKey:
        final keyController = TextEditingController(
          text: authData?.apikey?.key ?? '',
        );
        final nameController = TextEditingController(
          text: authData?.apikey?.name ?? 'x-api-key',
        );
        final currentLocation = authData?.apikey?.location ?? 'header';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add to",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            DropdownButtonFormField<String>(
              value: currentLocation,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'header',
                  child: Text('Header'),
                ),
                DropdownMenuItem(
                  value: 'query',
                  child: Text('Query Params'),
                ),
              ],
              onChanged: (String? newLocation) {
                if (newLocation != null) {
                  updateAuth(ApiAuthModel(
                    type: APIAuthType.apiKey,
                    apikey: AuthApiKeyModel(
                      key: keyController.text,
                      name: nameController.text,
                      location: newLocation,
                    ),
                  ));
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Header/Query Param Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText: "Header/Query Param Name",
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => updateAuth(
                ApiAuthModel(
                  type: APIAuthType.apiKey,
                  apikey: AuthApiKeyModel(
                    key: keyController.text,
                    name: nameController.text.trim(),
                    location: currentLocation,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "API Key",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: keyController,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText: "API Key",
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => updateAuth(ApiAuthModel(
                type: APIAuthType.apiKey,
                apikey: AuthApiKeyModel(
                  key: keyController.text.trim(),
                  name: nameController.text,
                  location: currentLocation,
                ),
              )),
            ),
          ],
        );

      case APIAuthType.jwt:
        final jwtController = TextEditingController(
          text: authData?.jwt?.jwt ?? '',
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "JWT Token",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: jwtController,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText: "JWT Token",
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => updateAuth(ApiAuthModel(
                type: APIAuthType.jwt,
                jwt: AuthJwtModel(jwt: jwtController.text.trim()),
              )),
            ),
          ],
        );

      case APIAuthType.none:
        return const Text("No authentication selected.");

      // TODO: Implement digest, oauth1, oauth2 later
      default:
        return const Text("This auth type is not implemented yet.");
    }
  }
}
