# API Explorer Feature - APIDash (#PR 1)

This temp README helps to monitor and understand the Proof of Concept (POC) for the **API Explorer** feature.

The feature currently uses mock JSON data for templates (stored in `lib/screens/explorer/api_templates/mock`) and leverages reusable models from the `apidash_core` package to ensure consistency. It is built with Flutter, Riverpod for state management, and the `multi_split_view` package for a resizable split view layout.

## Key Functionality

### Current Implementation

- **Template Browsing**: Displays API templates in a responsive grid, loaded from mock JSON files.
- **Template Details**: Provides a split view to show a list of requests and detailed information about the selected request.
- **Request Import**: Allows users to import a request into the main application with a single click.
- **Search (Placeholder)**: Includes a search bar for filtering templates (to be implemented).
- **Navigation**: Seamlessly integrates with the APIDash dashboard, accessible via the "Explorer" navigation option.

## Key Files and Their Functionality

### Models

**Current Implementation**:

The API Explorer reuses models from `apidash_core` and defines additional models specific to the feature. These models ensure consistency and enable serialization to/from JSON.

1. `lib/models/explorer_model.dart`

   - **Purpose**: Defines the `ApiTemplate` and `Info` classes for representing API templates and their metadata.
   - **Key Classes**:
     - `ApiTemplate`: Contains an `Info` object (title, description, tags) and a list of `RequestModel`s.
     - `Info`: Metadata for a template, serializable to/from JSON.
   - **Functionality**:
     - Parses JSON data from mock files into `ApiTemplate` objects.
     - Supports future extensions (e.g., adding category or version fields to `Info`).
   - **Reusability**: Designed to be extensible for real API data and reusable across other features.

**Reusability Note**: The reuse of `RequestModel`, `HttpRequestModel`, and `HttpResponseModel` from `apidash_core` ensures consistency across APIDash features, reducing code duplication and simplifying maintenance.

### Service

1. `lib/services/templates_service.dart`
   - **Purpose**: Loads API templates from mock JSON files or (in the future) a GitHub repo.
   - **Key Methods**:
     - `loadTemplates()`: Reads JSON files from `lib/screens/explorer/api_templates/mock` and parses them into `ApiTemplate` objects.
     - `fetchTemplatesFromApi()`: Placeholder for fetching templates from a remote API.
   - **Functionality**:
     - Asynchronously loads templates using `rootBundle`.
     - Handles errors gracefully, returning an empty list if loading fails.
     - Filters JSON files from the asset manifest.
   - **Future Potential**:
     - Implement `fetchTemplatesFromrepo` for dynamic data.
     - Add Hive to reduce redundant loads.

### Important Widgets

1. `lib/screens/explorer/explorer_page.dart`

   - **Purpose**: The main entry point for the API Explorer, managing navigation between the explorer grid and description page.
   - **Functionality**:
     - Toggles between the explorer view (`ExplorerHeader` + `ExplorerBody`) and the description view (`DescriptionPage`) using local state.
     - Passes the selected template to `DescriptionPage` and handles back navigation.
   - **Key Role**: Orchestrates the user flow within the API Explorer.

2. `lib/screens/explorer/explorer_body.dart`

   - **Purpose**: Renders a searchable grid of API template cards.
   - **Functionality**:
     - Uses a `FutureBuilder` to load templates via `TemplatesService.loadTemplates()`.
     - Displays loading, error, or empty states.
     - Renders `TemplateCard` widgets in a responsive `GridView`.
     - Includes an `ApiSearchBar` (placeholder for search filtering).
   - **Key Role**: Provides the primary browsing interface.

3. `lib/screens/explorer/description/description_page.dart`

   - **Purpose**: Displays detailed information about a selected API template.
   - **Functionality**:
     - Comprises a `DescriptionHeader` (title, description, back button) and a `DescriptionBody` (split view of requests and details).
     - Receives the selected `ApiTemplate` and a callback to return to the explorer.
   - **Key Role**: Facilitates in-depth exploration of templates.

4. `lib/screens/explorer/description/description_body.dart`

   - **Purpose**: Manages the split view layout for the description page.
   - **Functionality**:
     - Uses `ExplorerSplitView` to create a resizable split view with `RequestsPane` (list of requests) and `DescriptionPane` (request details).
     - Maintains state for the selected `RequestModel`.
   - **Key Role**: Enables side-by-side viewing of requests and their details.

5. `lib/screens/explorer/common_widgets/template_card.dart`

   - **Purpose**: Represents an API template in the explorer grid.
   - **Functionality**:
     - Displays the template's title (`CardTitle`), description (`CardDescription`), and tags (`CustomChip.tag`).
     - Triggers navigation to the description page on tap.
   - **Key Role**: Provides a visually appealing and informative template preview.

6. `lib/screens/explorer/common_widgets/url_card.dart`

   - **Purpose**: Displays a request's URL, HTTP method, and an "Import" button.
   - **Functionality**:
     - Uses Riverpod to add the request to the collection via `collectionStateNotifierProvider`.
     - Shows a `SnackBar` on successful import and navigates to the `HomePage`.
   - **Key Role**: Enables seamless integration with the main application.

7. `lib/screens/explorer/common_widgets/api_search_bar.dart`

   - **Purpose**: Provides a search input field for filtering templates.
   - **Functionality**:
     - Includes a search icon and a clear button (when text is entered).
     - Currently a placeholder with TODOs for `onChanged` and `onClear` callbacks.
   - **Key Role**: Foundation for future search functionality.

8. `lib/screens/explorer/common_widgets/chip.dart`

   - **Purpose**: A versatile chip widget for HTTP methods, status codes, content types, and tags.
   - **Functionality**:
     - Provides factory constructors (e.g., `httpMethod`, `statusCode`, `tag`) with context-specific colors.
     - Used across `TemplateCard`, `RequestCard`, and other widgets for consistent styling.
   - **Key Role**: Enhances visual clarity and consistency.

## Future Checklist

The following tasks are planned to enhance the API Explorer feature:

- [ ] **Implement Search Functionality**:
  - Add filtering logic to `ApiSearchBar` to search templates by title, description, or tags.
  - Update `ExplorerBody` to reflect filtered results dynamically.
- [ ] **Add Global State Management**:
  - Introduce a Riverpod provider for managing selected template, selected request, and search query.
  - Refactor `ExplorerPage` and `DescriptionBody` to use the provider.
- [ ] **Fetch Templates from GitHub Repo**:
  - Implement `TemplatesService.fetchTemplatesFromRepo` to load templates from a remote endpoint.
  - Add caching (e.g., using `hive`).
- [ ] **Enhance UI/UX**:
  - Add sorting and filtering options to `ExplorerHeader` (e.g., by category or tag).
  - Introduce template-specific icons in `TemplateCard`.
  - Provide a placeholder UI in `DescriptionPane` when no request is selected.
- [ ] **Improve Performance**:
  - Implement pagination or lazy loading in `ExplorerBody` for large template sets.
  - Optimize `GridView` rendering for better scrolling performance.
- [ ] **Community Contributions** via API Dash:
  - An in-app Documentation Editor will allow users to upload API specs, edit auto-generated JSON templates, download them, and (in the future) trigger GitHub pull requests directly .
  