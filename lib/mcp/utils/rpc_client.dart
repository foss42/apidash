class RpcClient {
  static String get js => r'''
    async function executeMcpTool(name, args) {
      if (typeof request === 'function') {
        return await request("tools/call", { name, arguments: args });
      } else {
        return new Promise((resolve, reject) => {
          const id = Math.random().toString(36).substring(7);
          
          // Failsafe timeout for strict clients like Claude
          const timeout = setTimeout(() => {
            window.removeEventListener('message', handler);
            reject(new Error("Tool execution timed out waiting for host response."));
          }, 15000);

          const handler = (event) => {
            const msg = event.data;
            if (msg && msg.jsonrpc === '2.0' && msg.id === id) {
              clearTimeout(timeout);
              window.removeEventListener('message', handler);
              
              if (msg.error) {
                reject(msg.error);
              } else {
                resolve(msg.result);
              }
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