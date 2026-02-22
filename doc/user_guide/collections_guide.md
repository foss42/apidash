# Collections & Request Management

API Dash organizes your API requests in a single, ordered collection. You can add, name, reorder, duplicate, and delete requests to keep your workspace tidy.

## Creating a New Request

1. Click the **"+"** button at the top of the collection pane (left sidebar).
2. A new request is added to the list with a default name.
3. The request editor opens on the right so you can start configuring it.

## Naming Requests

Give your requests meaningful names to find them quickly:

- **Desktop:** Double-click a request in the sidebar to edit its name inline. Press **Enter** to save or **Escape** to cancel.
- **Mobile:** Long-press a request to see the full name tooltip, or use the context menu to rename.

> **Tip:** Hovering on Desktop or long-pressing on Mobile displays a tooltip with the full request name for requests with long names.

![Tooltip](./images/req/req_tooltip.png)

## Reordering Requests (Drag & Drop)

You can reorder requests by dragging them:

- **Desktop:** Click and hold the drag handle on a request card, then drag it to the desired position.
- **Mobile:** Long-press a request card to begin dragging, then move it to the desired position.

Release to drop the request in its new location. The updated order is saved automatically.

## Searching & Filtering

Use the search bar at the top of the collection pane to filter requests:

- Type a keyword to filter by **request name** or **URL**.
- The list updates in real time as you type.
- Clear the search field to show all requests again.

## Request Context Menu

Right-click (Desktop) or long-press (Mobile) on a request to access these actions:

- **Rename:** Edit the request name inline.
- **Duplicate:** Create a copy of the request with all its settings (URL, headers, body, parameters). The duplicate gets a new unique ID.
- **Delete:** Remove the request from the collection. This action cannot be undone.

## Importing Requests

You can import requests from external sources. See the [Importing Guide](./importing_guide.md) for details on importing from cURL, Postman, Insomnia, and HAR files.

## Request Editor Overview

When a request is selected, the editor pane shows:

1. **URL Bar:** Enter the request URL with the HTTP method selector (GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS).
2. **Tabs:**
   - **Params:** Add URL query parameters as key-value pairs.
   - **Headers:** Add custom HTTP headers.
   - **Body:** Set the request body (JSON, form data, text, etc.).
   - **Authentication:** Configure authentication (see [Authentication Guide](./authentication.md)).
   - **Pre-Request Script:** Write JavaScript to run before sending (see [Scripting Guide](./scripting_user_guide.md)).
   - **Post-Response Script:** Write JavaScript to run after receiving the response.
3. **Send Button:** Click to execute the request.
4. **Response Pane:** View the response status, headers, body, and timing.

## Response Viewing

API Dash supports previewing responses in multiple formats:

- **Preview:** Rendered view for supported content types (JSON with syntax highlighting, images, PDFs, HTML, audio, video).
- **Code:** Raw response body with syntax highlighting.
- **Raw:** Plain text response body.
- **None:** Hide the response body.

### Supported Response Types

API Dash can preview 50+ MIME types including:

| Category | Formats |
|----------|---------|
| **Structured Data** | JSON, XML, YAML, TOML, NDJSON |
| **Web** | HTML, CSS, JavaScript |
| **Documents** | PDF, Markdown, SQL |
| **Images** | PNG, JPEG, GIF, SVG, WebP, BMP, ICO |
| **Audio** | MP3, WAV, OGG, AAC, FLAC |
| **Video** | MP4, WebM, OGG |
| **Streaming** | Server-Sent Events (SSE) |

## GraphQL Requests

To send a GraphQL request:

1. Select **GraphQL** from the request type selector (next to the HTTP method).
2. Enter the GraphQL endpoint URL.
3. Write your query in the **Query** tab.
4. Optionally add variables in the **Variables** tab.
5. Click **Send** to execute the query.

## AI Requests

API Dash supports sending AI model requests:

1. Select **AI** from the request type selector.
2. Configure your AI provider and model in the settings.
3. Enter your prompt or message.
4. Click **Send** to get the AI response.

## Tips

- Use [Environment Variables](./env_user_guide.md) like `{{API_URL}}` in your URLs and headers to switch between different environments easily.
- Check [Request History](./his_user_guide.md) to review past requests and responses.
- Use the [Code Generation](./code_generation_guide.md) feature to export your request as runnable code.
