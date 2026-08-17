class MessageHandler {
  static String get js => r'''
    // 0. The Missing Handshake (Claude's Green Light)
    window.parent.postMessage({ type: 'ready' }, '*');
    window.parent.postMessage({ jsonrpc: '2.0', method: 'ready' }, '*');
    window.parent.postMessage({ jsonrpc: '2.0', method: 'notifications/initialized' }, '*');

    // 1. Dynamic Host Theme Synchronization
    window.addEventListener('message', (event) => {
      const msg = event.data;
      if (msg && (msg.method === 'ui/initialize' || msg?.hostContext?.styles?.variables)) {
        
        // STRICT MCP REQUIREMENT: Acknowledge initialization if the host sent a request ID
        if (msg.id) {
          window.parent.postMessage({ jsonrpc: '2.0', id: msg.id, result: {} }, '*');
        }

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
    
    // Trigger an initial resize computation just in case
    setTimeout(sendResizeNotification, 100);
  ''';
}