// import 'package:apidash_core/models/oauth_models.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:apidash_core/apidash_core.dart';

// import '../../../../../providers/collection_providers.dart';
// import '../../../../../providers/oauth_providers.dart';

// class OAuthConfigWidget extends ConsumerWidget {
//   const OAuthConfigWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedId = ref.watch(selectedIdStateProvider);
//     final requestModel = ref.watch(selectedRequestModelProvider);
//     final oauthConfig = requestModel?.httpRequestModel?.;

//     return ExpansionTile(
//       title: const Text('OAuth 2.0 Configuration'),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropdownButtonFormField<OAuthFlow>(
//                 value: oauthConfig?.flow ?? OAuthFlow.authorizationCode,
//                 decoration: const InputDecoration(labelText: 'OAuth Flow'),
//                 items: OAuthFlow.values.map((flow) {
//                   return DropdownMenuItem(
//                     value: flow,
//                     child: Text(flow.toString().split('.').last),
//                   );
//                 }).toList(),
//                 onChanged: (flow) {
//                   if (flow == null) return;
//                   _updateOAuthConfig(ref, selectedId, 
//                     oauthConfig?.copyWith(flow: flow) ?? 
//                     OAuthConfig(
//                       clientId: '',
//                       authorizationEndpoint: '',
//                       tokenEndpoint: '',
//                       redirectUri: 'http://localhost:8080/callback',
//                       flow: flow,
//                     )
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 initialValue: oauthConfig?.clientId ?? '',
//                 decoration: const InputDecoration(labelText: 'Client ID'),
//                 onChanged: (value) {
//                   _updateOAuthConfig(ref, selectedId, 
//                     oauthConfig?.copyWith(clientId: value) ??
//                     OAuthConfig(
//                       clientId: value,
//                       authorizationEndpoint: '',
//                       tokenEndpoint: '',
//                       redirectUri: 'http://localhost:8080/callback',
//                     )
//                   );
//                 },
//               ),
//               if (oauthConfig?.flow != OAuthFlow.implicit) ...[
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   initialValue: oauthConfig?.clientSecret ?? '',
//                   decoration: const InputDecoration(labelText: 'Client Secret'),
//                   obscureText: true,
//                   onChanged: (value) {
//                     _updateOAuthConfig(ref, selectedId,
//                       oauthConfig?.copyWith(clientSecret: value)
//                     );
//                   },
//                 ),
//               ],
//               const SizedBox(height: 16),
//               TextFormField(
//                 initialValue: oauthConfig?.authorizationEndpoint ?? '',
//                 decoration: const InputDecoration(labelText: 'Authorization Endpoint'),
//                 onChanged: (value) {
//                   _updateOAuthConfig(ref, selectedId,
//                     oauthConfig?.copyWith(authorizationEndpoint: value)
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 initialValue: oauthConfig?.tokenEndpoint ?? '',
//                 decoration: const InputDecoration(labelText: 'Token Endpoint'),
//                 onChanged: (value) {
//                   _updateOAuthConfig(ref, selectedId,
//                     oauthConfig?.copyWith(tokenEndpoint: value)
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 initialValue: oauthConfig?.redirectUri ?? 'http://localhost:8080/callback',
//                 decoration: const InputDecoration(labelText: 'Redirect URI'),
//                 onChanged: (value) {
//                   _updateOAuthConfig(ref, selectedId,
//                     oauthConfig?.copyWith(redirectUri: value)
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 initialValue: oauthConfig?.scopes.join(' ') ?? '',
//                 decoration: const InputDecoration(
//                   labelText: 'Scopes',
//                   helperText: 'Space-separated list of scopes',
//                 ),
//                 onChanged: (value) {
//                   _updateOAuthConfig(ref, selectedId,
//                     oauthConfig?.copyWith(
//                       scopes: value.split(' ').where((s) => s.isNotEmpty).toList(),
//                     )
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: oauthConfig == null ? null : () {
//                       ref.read(tokenManagerProvider).clearToken(oauthConfig);
//                     },
//                     child: const Text('Clear Token'),
//                   ),
//                   const SizedBox(width: 16),
//                   if (oauthConfig != null) ...[
//                     FutureBuilder<OAuthToken?>(
//                       future: ref.read(tokenManagerProvider).getToken(oauthConfig),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return const CircularProgressIndicator();
//                         }
//                         final token = snapshot.data;
//                         if (token == null) {
//                           return const Text('No token');
//                         }
//                         return Text(
//                           'Token expires at: ${token.expiresAt.toLocal()}',
//                           style: Theme.of(context).textTheme.bodySmall,
//                         );
//                       },
//                     ),
//                   ],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _updateOAuthConfig(WidgetRef ref, String? selectedId, OAuthConfig? config) {
//     if (selectedId == null) return;
    
//     final notifier = ref.read(collectionStateNotifierProvider.notifier);
//     final requestModel = notifier.getRequestModel(selectedId);
//     if (requestModel == null) return;

//     // Uncomment when ready to update
//     // notifier.update(
//     //   selectedId,
//     //   requestModel.copyWith(
//     //     httpRequestModel: requestModel.httpRequestModel?.copyWith(
//     //       oauthConfig: config,
//     //     ) ?? HttpRequestModel(
//     //       id: selectedId,
//     //       method: HTTPVerb.get,
//     //       url: '',
//     //       oauthConfig: config,
//     //     ),
//     //   ),
//     // );
//   }
// }
