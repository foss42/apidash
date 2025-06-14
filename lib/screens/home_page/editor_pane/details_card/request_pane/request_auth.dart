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

    return SingleChildScrollView(
      child: Padding(
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
                final selectedRequest = ref.read(selectedRequestModelProvider);
                if (newType != null) {
                  ref.read(collectionStateNotifierProvider.notifier).update(
                        authData: selectedRequest?.authData
                                ?.copyWith(type: newType) ??
                            ApiAuthModel(type: newType),
                      );
                }
              },
            ),
            const SizedBox(height: 48),
            _buildAuthFields(context, ref, currentAuthData),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthFields(
    BuildContext context,
    WidgetRef ref,
    ApiAuthModel? authData,
  ) {
    void updateAuth(ApiAuthModel? model) {
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
              onChanged: (value) => updateAuth(authData?.copyWith(
                type: APIAuthType.basic,
                basic: AuthBasicAuthModel(
                  username: usernameController.text.trim(),
                  password: passwordController.text.trim(),
                ),
              )),
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
                authData?.copyWith(
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
                authData?.copyWith(
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
                  updateAuth(
                    authData?.copyWith(
                      type: APIAuthType.apiKey,
                      apikey: AuthApiKeyModel(
                        key: keyController.text,
                        name: nameController.text,
                        location: newLocation,
                      ),
                    ),
                  );
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
                authData?.copyWith(
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
              onChanged: (value) => updateAuth(
                authData?.copyWith(
                  type: APIAuthType.apiKey,
                  apikey: AuthApiKeyModel(
                    key: keyController.text.trim(),
                    name: nameController.text,
                    location: currentLocation,
                  ),
                ),
              ),
            ),
          ],
        );

      case APIAuthType.jwt:
        final jwtSecretController = TextEditingController(
          text: authData?.jwt?.secret ?? '',
        );
        final jwtPayloadController = TextEditingController(
          text: authData?.jwt?.payload ?? '',
        );
        final jwtHeaderPrefixController = TextEditingController(
          text: authData?.jwt?.headerPrefix ?? 'Bearer',
        );
        final jwtQueryParamKeyController = TextEditingController(
          text: authData?.jwt?.queryParamKey ?? 'token',
        );
        final jwtHeaderController = TextEditingController(
          text: authData?.jwt?.header ?? '',
        );

        final currentAddTokenTo = authData?.jwt?.addTokenTo ?? 'header';
        final currentAlgorithm = authData?.jwt?.algorithm ?? 'HS256';
        final isSecretBase64Encoded =
            authData?.jwt?.isSecretBase64Encoded ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add JWT token to",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: currentAddTokenTo,
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
                  child: Text('Request Header'),
                ),
                DropdownMenuItem(
                  value: 'query',
                  child: Text('Query Parameters'),
                ),
              ],
              onChanged: (String? newAddTokenTo) {
                if (newAddTokenTo != null) {
                  updateAuth(
                    authData?.copyWith(
                      type: APIAuthType.jwt,
                      jwt: AuthJwtModel(
                        secret: jwtSecretController.text.trim(),
                        payload: jwtPayloadController.text.trim(),
                        addTokenTo: newAddTokenTo,
                        algorithm: currentAlgorithm,
                        isSecretBase64Encoded: isSecretBase64Encoded,
                        headerPrefix: jwtHeaderPrefixController.text.trim(),
                        queryParamKey: jwtQueryParamKeyController.text.trim(),
                        header: jwtHeaderController.text.trim(),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Algorithm",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: currentAlgorithm,
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
                'HS256',
                'HS384',
                'HS512',
              ].map((algorithm) {
                return DropdownMenuItem(
                  value: algorithm,
                  child: Text(algorithm),
                );
              }).toList(),
              onChanged: (String? newAlgorithm) {
                if (newAlgorithm != null) {
                  updateAuth(
                    authData?.copyWith(
                      type: APIAuthType.jwt,
                      jwt: AuthJwtModel(
                        secret: jwtSecretController.text.trim(),
                        payload: jwtPayloadController.text.trim(),
                        addTokenTo: currentAddTokenTo,
                        algorithm: newAlgorithm,
                        isSecretBase64Encoded: isSecretBase64Encoded,
                        headerPrefix: jwtHeaderPrefixController.text.trim(),
                        queryParamKey: jwtQueryParamKeyController.text.trim(),
                        header: jwtHeaderController.text.trim(),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Secret",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextField(
              controller: jwtSecretController,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText: "Secret key",
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => updateAuth(
                authData?.copyWith(
                  type: APIAuthType.jwt,
                  jwt: AuthJwtModel(
                    secret: jwtSecretController.text.trim(),
                    payload: jwtPayloadController.text.trim(),
                    addTokenTo: currentAddTokenTo,
                    algorithm: currentAlgorithm,
                    isSecretBase64Encoded: isSecretBase64Encoded,
                    headerPrefix: jwtHeaderPrefixController.text.trim(),
                    queryParamKey: jwtQueryParamKeyController.text.trim(),
                    header: jwtHeaderController.text.trim(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text(
                "Secret is Base64 encoded",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: isSecretBase64Encoded,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                updateAuth(
                  authData?.copyWith(
                    type: APIAuthType.jwt,
                    jwt: AuthJwtModel(
                      secret: jwtSecretController.text.trim(),
                      payload: jwtPayloadController.text.trim(),
                      addTokenTo: currentAddTokenTo,
                      algorithm: currentAlgorithm,
                      isSecretBase64Encoded: value ?? false,
                      headerPrefix: jwtHeaderPrefixController.text.trim(),
                      queryParamKey: jwtQueryParamKeyController.text.trim(),
                      header: jwtHeaderController.text.trim(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Payload (JSON format)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextField(
              controller: jwtPayloadController,
              maxLines: 4,
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                contentPadding: const EdgeInsets.all(18),
                hintText:
                    '{"sub": "1234567890", "name": "John Doe", "iat": 1516239022}',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => updateAuth(
                authData?.copyWith(
                  type: APIAuthType.jwt,
                  jwt: AuthJwtModel(
                    secret: jwtSecretController.text.trim(),
                    payload: jwtPayloadController.text.trim(),
                    addTokenTo: currentAddTokenTo,
                    algorithm: currentAlgorithm,
                    isSecretBase64Encoded: isSecretBase64Encoded,
                    headerPrefix: jwtHeaderPrefixController.text.trim(),
                    queryParamKey: jwtQueryParamKeyController.text.trim(),
                    header: jwtHeaderController.text.trim(),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 16),
            // if (currentAddTokenTo == 'header') ...[
            //   Text(
            //     "Header Prefix",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   SizedBox(height: 4),
            //   TextField(
            //     controller: jwtHeaderPrefixController,
            //     decoration: InputDecoration(
            //       constraints: BoxConstraints(
            //         maxWidth: MediaQuery.sizeOf(context).width - 100,
            //       ),
            //       contentPadding: const EdgeInsets.all(18),
            //       hintText: "Bearer",
            //       hintStyle: Theme.of(context).textTheme.bodyMedium,
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     onChanged: (value) => updateAuth(ApiAuthModel(
            //       type: APIAuthType.jwt,
            //       jwt: AuthJwtModel(
            //         secret: jwtSecretController.text.trim(),
            //         payload: jwtPayloadController.text.trim(),
            //         addTokenTo: currentAddTokenTo,
            //         algorithm: currentAlgorithm,
            //         isSecretBase64Encoded: isSecretBase64Encoded,
            //         headerPrefix: jwtHeaderPrefixController.text.trim(),
            //         queryParamKey: jwtQueryParamKeyController.text.trim(),
            //         header: jwtHeaderController.text.trim(),
            //       ),
            //     )),
            //   ),
            //   const SizedBox(height: 16),
            // ],
            // if (currentAddTokenTo == 'query') ...[
            //   Text(
            //     "Query Parameter Key",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   SizedBox(height: 4),
            //   TextField(
            //     controller: jwtQueryParamKeyController,
            //     decoration: InputDecoration(
            //       constraints: BoxConstraints(
            //         maxWidth: MediaQuery.sizeOf(context).width - 100,
            //       ),
            //       contentPadding: const EdgeInsets.all(18),
            //       hintText: "token",
            //       hintStyle: Theme.of(context).textTheme.bodyMedium,
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     onChanged: (value) => updateAuth(ApiAuthModel(
            //       type: APIAuthType.jwt,
            //       jwt: AuthJwtModel(
            //         secret: jwtSecretController.text.trim(),
            //         payload: jwtPayloadController.text.trim(),
            //         addTokenTo: currentAddTokenTo,
            //         algorithm: currentAlgorithm,
            //         isSecretBase64Encoded: isSecretBase64Encoded,
            //         headerPrefix: jwtHeaderPrefixController.text.trim(),
            //         queryParamKey: jwtQueryParamKeyController.text.trim(),
            //         header: jwtHeaderController.text.trim(),
            //       ),
            //     )),
            //   ),
            //   const SizedBox(height: 16),
            // ],
            // Text(
            //   "JWT Headers (JSON format)",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: 4),
            // TextField(
            //   controller: jwtHeaderController,
            //   maxLines: 3,
            //   decoration: InputDecoration(
            //     constraints: BoxConstraints(
            //       maxWidth: MediaQuery.sizeOf(context).width - 100,
            //     ),
            //     contentPadding: const EdgeInsets.all(18),
            //     hintText: '{"typ": "JWT", "alg": "HS256"}',
            //     hintStyle: Theme.of(context).textTheme.bodyMedium,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   onChanged: (value) => updateAuth(
            //     ApiAuthModel(
            //       type: APIAuthType.jwt,
            //       jwt: AuthJwtModel(
            //         secret: jwtSecretController.text.trim(),
            //         payload: jwtPayloadController.text.trim(),
            //         addTokenTo: currentAddTokenTo,
            //         algorithm: currentAlgorithm,
            //         isSecretBase64Encoded: isSecretBase64Encoded,
            //         headerPrefix: jwtHeaderPrefixController.text.trim(),
            //         queryParamKey: jwtQueryParamKeyController.text.trim(),
            //         header: jwtHeaderController.text.trim(),
            //       ),
            //     ),
            //   ),
            // ),
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
