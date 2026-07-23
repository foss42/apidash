class MessageHandler {
  static String get js => r'''
    // 1. Dynamic Host Theme Synchronization
    window.addEventListener('message', (event) => {
      const msg = event.data;
      if (msg && (msg.method === 'ui/initialize' || msg?.hostContext?.styles?.variables)) {
        const vars = msg?.hostContext?.styles?.variables || msg?.params?.hostContext?.styles?.variables;
        if (vars) {
          for (const [key, value] of Object.entries(vars)) {
            if (value) document.documentElement.style.setProperty(key, value);
          }
        }
      }
    });

    // 2. Iframe Auto-Resizer
    const sendResizeNotification = () => {
      const scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;
      window.parent.postMessage({ type: 'MCP_APP_RESIZE', height: scrollHeight }, '*');
      window.parent.postMessage({ jsonrpc: '2.0', method: 'ui/notifications/resize', params: { height: scrollHeight } }, '*');
    };
    new ResizeObserver(sendResizeNotification).observe(document.body);
  ''';
}