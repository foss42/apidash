class SharedStyles {
  static String get css => r'''
    * { box-sizing: border-box; margin: 0; padding: 0; }
    
    html, body {
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
      overflow: hidden;
      background-color: var(--bg-canvas, #121212);
      font-family: var(--vscode-font-family, -apple-system, system-ui, sans-serif);
      color: var(--text-main, #f3f4f6);
      display: flex;
      flex-direction: column;
      box-sizing: border-box;
    }
  ''';
}