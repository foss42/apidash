# Importing API Requests

API Dash lets you import API requests from several popular formats so you can quickly get started without manually recreating them.

## Supported Import Formats

| Format | Description |
|--------|-------------|
| **cURL** | Import from cURL commands |
| **Postman** | Postman Collection v2.1 |
| **Insomnia** | Insomnia v4 exports |
| **HAR** | HTTP Archive v1.2 files |

## How to Import

1. Open the **Import** dialog from the collection pane toolbar (look for the import icon).
2. Select the import format from the dropdown (cURL, Postman, Insomnia, or HAR).
3. Choose a file from your system using the file picker.
4. API Dash parses the file and creates new requests in your collection.
5. A notification confirms how many requests were imported.

## Importing cURL Commands

You can import cURL commands in two ways:

### Via the Import Dialog

1. Open the Import dialog.
2. Select **cURL** as the format.
3. Paste or load a file containing your cURL command.
4. The request is parsed and added to your collection.

### Via Dashbot (AI Assistant)

Dashbot provides an interactive cURL import experience with preview and diff:

1. Open Dashbot by clicking the floating Dashbot button.
2. Choose **"Import cURL"** from the home screen tasks.
3. Paste a complete cURL command starting with `curl ...`.
4. Dashbot parses the command and shows:
   - A summary of the detected method, URL, headers, and body.
   - A diff preview compared to your currently selected request.
   - Action buttons to **Apply to Selected** or **Create New Request**.

**What is parsed from cURL:**
- HTTP method and URL
- Headers (including `Cookie`, `User-Agent`, `Referer`)
- Basic auth from `-u user:pass`
- Request body or form data

**Known limitations:**
- Some flags don't map to requests (e.g., `-k` for insecure SSL, `-L` for follow redirects).
- Review and adjust the imported request if advanced curl options were used.

> See the [Dashbot User Guide](./dashbot_user_guide.md) for a detailed walkthrough with screenshots.

## Importing Postman Collections

1. Export your collection from Postman as **Collection v2.1** format (JSON).
2. Open the Import dialog in API Dash and select **Postman**.
3. Choose the exported `.json` file.
4. All requests from the collection are added to your API Dash workspace.

**What is imported:**
- Request names
- HTTP methods and URLs
- Headers
- Query parameters
- Request bodies
- Authentication settings (where applicable)

## Importing Insomnia Collections

1. Export your workspace from Insomnia as **Insomnia v4** format.
2. Open the Import dialog in API Dash and select **Insomnia**.
3. Choose the exported file.
4. Requests are parsed and added to your collection.

## Importing HAR Files

HAR (HTTP Archive) files capture network traffic from browser developer tools or other HTTP clients.

1. Export a HAR file from your browser's DevTools (**Network** tab → **Export HAR**) or another tool.
2. Open the Import dialog in API Dash and select **HAR**.
3. Choose the `.har` file.
4. All recorded HTTP requests are imported into your collection.

**What is imported from HAR:**
- Request URLs and methods
- Request headers
- Query parameters
- Request body content

## Importing OpenAPI Specifications

OpenAPI (Swagger) specs can be imported via Dashbot:

1. Open Dashbot and choose **"Import OpenAPI"**.
2. Provide the spec by:
   - Uploading a JSON or YAML file.
   - Pasting the full spec into the chat.
   - Entering a URL to fetch the spec.
3. Dashbot parses the spec and shows a summary.
4. Click **"Import Now"** to open the Operation Picker.
5. Select individual operations or **Select All**, then click **Import**.
6. New requests are created for each selected operation.

> See the [Dashbot User Guide](./dashbot_user_guide.md) for detailed OpenAPI import instructions with screenshots.

## Tips

- After importing, review each request to verify that all settings were correctly parsed.
- Use [Environment Variables](./env_user_guide.md) to replace hardcoded base URLs with variables like `{{BASE_URL}}` for flexibility.
- Dashbot can automatically create environment variables for base URLs when importing via cURL or OpenAPI.
