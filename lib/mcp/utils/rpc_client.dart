class RpcClient {
  static String get js => r'''
    async function executeMcpTool(name, args) {
      if (typeof request === 'function') {
        return await request("tools/call", { name, arguments: args });
      } else {
        return new Promise((resolve) => {
          const id = Math.random().toString(36).substring(7);
          const handler = (event) => {
            const msg = event.data;
            if (msg && msg.jsonrpc === '2.0' && msg.id === id) {
              window.removeEventListener('message', handler);
              resolve(msg.result);
            }
          };
          window.addEventListener('message', handler);
          window.parent.postMessage({ 
            jsonrpc: '2.0', 
            id: id, 
            method: 'tools/call', 
            params: { name, arguments: args } 
          }, '*');
        });
      }
    }
    // Alias for studio compatibility
    const executeDartTool = executeMcpTool;
  ''';
}