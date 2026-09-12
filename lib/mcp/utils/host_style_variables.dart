class HostStyleVariables {
  static String get css => r'''
    :root {
      /* 1. Canvas & Surface Backgrounds (Goose -> VS Code -> Hex Fallback) */
      --bg-canvas: var(--host-bg, var(--vscode-editor-background, #121212));
      --bg-input: var(--host-input-bg, var(--vscode-input-background, #1e1e1e));
      --bg-surface: var(--host-surface-bg, var(--vscode-sideBar-background, #181818));
      --bg-surface-hover: var(--host-surface-hover, var(--vscode-list-hoverBackground, #272727));

      /* 2. Headers & Tabs */
      --bg-header: var(--host-header-bg, var(--vscode-editorGroupHeader-tabsBackground, #141414));
      --bg-tab-active: var(--host-tab-active, var(--vscode-tab-activeBackground, #1e1e1e));
      --bg-tab-hover: var(--host-tab-hover, var(--vscode-tab-hoverBackground, rgba(255, 255, 255, 0.05)));
      
      /* 3. Typography & Text Colors */
      --text-main: var(--host-color, var(--vscode-editor-foreground, #f3f4f6));
      --text-muted: var(--host-muted, var(--vscode-input-placeholderForeground, #6b7280));
      --text-label: var(--host-label, var(--vscode-descriptionForeground, #9ca3af));
      --text-tab-active: var(--host-tab-active-text, var(--vscode-tab-activeForeground, #f9fafb));
      --text-tab-inactive: var(--host-tab-inactive-text, var(--vscode-tab-inactiveForeground, #6b7280));

      /* 4. Borders & Dividers */
      --border-color: var(--host-border, var(--vscode-input-border, var(--vscode-widget-border, #2d2d2d)));
      --border-hover: var(--host-border-hover, var(--vscode-focusBorder, #3b82f6));
      --border-divider: var(--host-divider, var(--vscode-editorGroupHeader-tabsBorder, #262626));
      --border-active-tab: var(--host-active-tab-border, var(--vscode-tab-activeBorder, var(--vscode-focusBorder, #60a5fa)));

      /* 5. Buttons */
      --btn-send-bg: var(--host-btn-bg, var(--vscode-button-background, #93c5fd));
      --btn-send-text: var(--host-btn-text, var(--vscode-button-foreground, #0f172a));
      --btn-send-hover: var(--host-btn-hover, var(--vscode-button-hoverBackground, #bfdbfe));

      /* 6. API Dash HTTP Verb Colors (Terminal ANSI Mapping) */
      --http-get: var(--vscode-terminal-ansiBrightGreen, #4ade80);
      --http-head: var(--vscode-terminal-ansiGreen, #86efac);
      --http-post: var(--vscode-terminal-ansiBrightBlue, #60a5fa);
      --http-put: var(--vscode-terminal-ansiBrightYellow, #fbbf24);
      --http-patch: var(--vscode-terminal-ansiYellow, #fb923c);
      --http-delete: var(--vscode-terminal-ansiBrightRed, #f87171);
      --http-options: var(--vscode-terminal-ansiBrightMagenta, #c084fc);

      /* 7. Fonts */
      --font-mono: var(--vscode-editor-font-family, "JetBrains Mono", Consolas, monospace);
    }
  ''';
}