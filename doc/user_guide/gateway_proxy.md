# Proxy Server for API Dash

API Dash (Web) runs directly in the browser, which means it is subject to Cross-Origin Resource Sharing (CORS) restrictions. Many APIs (like CoinMarketCap, Google, etc.) block requests from browser-based applications unless they are configured to allow them.

To bypass these restrictions, you can use a **CORS Proxy Server**. The proxy forwards your request to the target API and returns the response with the necessary CORS headers to satisfy the browser.

## How to Configure in API Dash

1. Go to **Settings**.
2. Look for the **Proxy URL** field (only visible on Web).
3. Enter the URL of your proxy server (e.g., `https://my-proxy.vercel.app/`).
4. API Dash will now prepend this URL to your API requests.

Example:
- Proxy URL: `https://my-proxy.com/`
- Target API: `https://api.example.com/v1/users`
- Actual Request: `https://my-proxy.com/https://api.example.com/v1/users`

## Hosting Your Own Proxy

API Dash does not provide a public proxy server. You should self-host one to ensure privacy and security.

### Node.js (Express + cors-anywhere)

You can easily deploy a proxy using [cors-anywhere](https://github.com/Rob--W/cors-anywhere).

1. Create a new directory and initialize a project:
   ```bash
   mkdir my-proxy
   cd my-proxy
   npm init -y
   npm install cors-anywhere
   ```

2. Create `server.js`:
   ```javascript
   const host = process.env.HOST || '0.0.0.0';
   const port = process.env.PORT || 8080;
   
   const cors_proxy = require('cors-anywhere');
   cors_proxy.createServer({
       originWhitelist: [], // Allow all origins
       requireHeader: ['origin', 'x-requested-with'],
       removeHeaders: ['cookie', 'cookie2']
   }).listen(port, host, function() {
       console.log('Running CORS Anywhere on ' + host + ':' + port);
   });
   ```

3. Run it:
   ```bash
   node server.js
   ```

### Deploying to Vercel/Cloudflare

There are many open-source templates for deploying CORS proxies to serverless platforms like Vercel or Cloudflare Workers.

- **Vercel**: [cors-anywhere-vercel](https://github.com/davidfurlong/cors-anywhere-vercel)
- **Cloudflare Workers**: [cloudflare-cors-anywhere](https://github.com/Zibri/cloudflare-cors-anywhere)

> **Security Note:** If you deploy a public proxy, anyone can use it to mask their IP. It is recommended to restrict the `originWhitelist` to your API Dash deployment domain (or `localhost` for testing).