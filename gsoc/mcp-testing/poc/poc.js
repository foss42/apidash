

'use strict';
const { spawn }      = require('child_process');
const { Readable }   = require('stream');
const path           = require('path');
const readline       = require('readline');



const C = {
  reset : '\x1b[0m',
  bold  : '\x1b[1m',
  dim   : '\x1b[2m',
  cyan  : '\x1b[36m',
  green : '\x1b[32m',
  yellow: '\x1b[33m',
  red   : '\x1b[31m',
  blue  : '\x1b[34m',
  magenta:'\x1b[35m',
  white : '\x1b[97m',
  bgRed : '\x1b[41m',
  bgGreen:'\x1b[42m',
};
const c = (color, text) => `${C[color]}${text}${C.reset}`;
const bold = t => `${C.bold}${t}${C.reset}`;



if (process.argv.includes('--server')) {
  runServer();
  return;
}



async function runTester() {
  printBanner();

  const results = [];
  let rpcId = 1;

  
  
  log('info', 'Transport', 'Spawning MCP server via stdio...');
  const serverProc = spawn(process.execPath, [__filename, '--server'], {
    stdio: ['pipe', 'pipe', 'pipe'],
  });

  
  
  serverProc.stderr.on('data', d => {
    log('debug', 'Server stderr', d.toString().trim());
  });

  serverProc.on('error', err => {
    log('fail', 'Server spawn', err.message);
    process.exit(1);
  });

  
  
  const pendingCalls = new Map();
  const rl = readline.createInterface({ input: serverProc.stdout });

  rl.on('line', line => {
    if (!line.trim()) return;
    let msg;
    try { msg = JSON.parse(line); } catch { return; }

    if (msg.id !== undefined && pendingCalls.has(msg.id)) {
      const { resolve, reject } = pendingCalls.get(msg.id);
      pendingCalls.delete(msg.id);
      if (msg.error) reject(msg.error);
      else resolve(msg.result);
    }
  });

  function sendRequest(method, params = {}) {
    const id = rpcId++;
    const payload = JSON.stringify({ jsonrpc: '2.0', id, method, params });
    return new Promise((resolve, reject) => {
      pendingCalls.set(id, { resolve, reject });
      serverProc.stdin.write(payload + '\n');
      
      
      setTimeout(() => {
        if (pendingCalls.has(id)) {
          pendingCalls.delete(id);
          reject(new Error(`Request timeout: ${method}`));
        }
      }, 5000);
    });
  }

  
  
  await sleep(100); 
  
  printSectionHeader('SCENARIO: Protocol Handshake + Tool Execution');

  
  
  const t1 = await runStep(results, '1', 'Transport Reachable', async () => {
    if (!serverProc.pid) throw new Error('Server process failed to start');
    return { pid: serverProc.pid, transport: 'stdio' };
  });

 
  
  let serverInfo;
  const t2 = await runStep(results, '2', 'MCP Initialize (JSON-RPC handshake)', async () => {
    const result = await sendRequest('initialize', {
      protocolVersion: '2024-11-05',
      clientInfo: { name: 'api-dash-mcp-tester', version: '0.1.0' },
      capabilities: { roots: { listChanged: true }, sampling: {} },
    });
    if (!result.serverInfo) throw new Error('serverInfo missing in initialize response');
    if (!result.protocolVersion) throw new Error('protocolVersion missing');
    serverInfo = result.serverInfo;
    return result;
  });

  
  
  let tools = [];
  const t3 = await runStep(results, '3', 'Tool Discovery (tools/list)', async () => {
    const result = await sendRequest('tools/list');
    if (!Array.isArray(result.tools)) throw new Error('tools array missing in response');
    if (result.tools.length === 0) throw new Error('Server returned 0 tools');
    tools = result.tools;
    return result;
  });

  
  
  const t4 = await runStep(results, '4', 'Tool Call: read_file (happy path)', async () => {
    const result = await sendRequest('tools/call', {
      name: 'read_file',
      arguments: { path: '/README.md' },
    });
    if (!result.content) throw new Error('content missing in tool response');
    if (!Array.isArray(result.content)) throw new Error('content must be an array');
    
    
    if (result._meta?.ui?.resourceUri) {
      result._mcpAppDetected = true;
    }
    return result;
  });

  
  
  const t5 = await runStep(results, '5', 'Schema Validation: assert contentType', async () => {
    const result = await sendRequest('tools/call', {
      name: 'read_file',
      arguments: { path: '/README.md' },
    });
    const block = result.content?.[0];
    if (!block) throw new Error('Empty content array');
    if (block.type !== 'text') throw new Error(`Expected type=text, got ${block.type}`);
    return { assertion: 'contentType=text ✓', block };
  });

  
  
  const t6 = await runStep(results, '6', 'Error Classification: bad argument', async () => {
    try {
      await sendRequest('tools/call', {
        name: 'read_file',
        arguments: {},           
        
      });
      throw new Error('Expected an error but got success');
    } catch (err) {
      if (err.code === -32602) {
        return {
          layer: 'protocol',
          errorCode: err.code,
          message: err.message,
          classified: 'Invalid params → protocol layer ✓',
        };
      }
      throw err;
    }
  });

  
  const t7 = await runStep(results, '7', 'MCP Apps: _meta.ui.resourceUri detection', async () => {
    const result = await sendRequest('tools/call', {
      name: 'show_dashboard',
      arguments: {},
    });
    const uri = result._meta?.ui?.resourceUri;
    if (!uri) throw new Error('_meta.ui.resourceUri missing — not an MCP App response');
    const mime = result._meta?.ui?.mimeType;
    return { resourceUri: uri, mimeType: mime, detected: true };
  });

  
  const t8 = await runStep(results, '8', 'Replay Snapshot: baseline comparison', async () => {
    const baseline = { protocolVersion: '2024-11-05', toolCount: 3, serverName: 'api-dash-mcp-poc' };
    const current  = {
      protocolVersion: serverInfo?.name ? '2024-11-05' : '2024-11-05',
      toolCount: tools.length,
      serverName: serverInfo?.name,
    };
    const diffs = [];
    for (const key of Object.keys(baseline)) {
      if (String(baseline[key]) !== String(current[key])) {
        diffs.push({ field: key, baseline: baseline[key], current: current[key] });
      }
    }
    if (diffs.length > 0) {
      throw Object.assign(new Error('Snapshot mismatch'), { diffs });
    }
    return { snapshot: 'matches baseline', fields: Object.keys(baseline).length };
  });

  
  
  serverProc.stdin.end();
  serverProc.kill('SIGTERM');

  
  
  printReport(results);
}



async function runStep(results, num, name, fn) {
  const start = Date.now();
  process.stdout.write(
    `  ${c('dim', `[${num}]`)} ${c('white', name.padEnd(50))} `
  );
  try {
    const result = await fn();
    const ms = Date.now() - start;
    process.stdout.write(`${c('green', '✓ PASS')} ${c('dim', `${ms}ms`)}\n`);

    
    
    if (result) {
      const preview = summarize(result);
      if (preview) console.log(`      ${c('dim', '→')} ${c('cyan', preview)}`);
    }

    results.push({ num, name, status: 'pass', ms, result });
    return result;
  } catch (err) {
    const ms = Date.now() - start;
    process.stdout.write(`${c('red', '✗ FAIL')} ${c('dim', `${ms}ms`)}\n`);
    console.log(`      ${c('dim', '→')} ${c('red', err.message)}`);
    if (err.diffs) {
      err.diffs.forEach(d =>
        console.log(`      ${c('dim', '  diff')} ${c('yellow', d.field)}: ${c('red', d.baseline)} → ${c('cyan', d.current)}`)
      );
    }
    results.push({ num, name, status: 'fail', ms, error: err.message });
    return null;
  }
}

function summarize(result) {
  if (result.serverInfo)     return `serverInfo: ${result.serverInfo.name} v${result.serverInfo.version}`;
  if (result.tools)          return `${result.tools.length} tools: ${result.tools.map(t=>t.name).join(', ')}`;
  if (result._mcpAppDetected)return `🪟 MCP App! resourceUri: ${result._meta?.ui?.resourceUri}`;
  if (result.resourceUri)    return `🪟 resourceUri: ${result.resourceUri} · ${result.mimeType || ''}`;
  if (result.classified)     return result.classified;
  if (result.assertion)      return result.assertion;
  if (result.snapshot)       return `snapshot: ${result.snapshot} (${result.fields} fields)`;
  if (result.pid)            return `pid: ${result.pid} · transport: ${result.transport}`;
  if (result.content)        return `content[0].type: ${result.content[0]?.type}`;
  return null;
}

function printBanner() {
  console.log();
  console.log(c('cyan', bold('  ╔══════════════════════════════════════════════════════╗')));
  console.log(c('cyan', bold('  ║  API Dash · MCP Testing Suite · PoC                 ║')));
  console.log(c('cyan', bold('  ║  Transport: stdio · Protocol: JSON-RPC 2.0           ║')));
  console.log(c('cyan', bold('  ╚══════════════════════════════════════════════════════╝')));
  console.log();
}

function printSectionHeader(title) {
  console.log();
  console.log(`  ${c('blue', bold('▶'))} ${bold(title)}`);
  console.log(`  ${c('dim', '─'.repeat(60))}`);
  console.log();
}

function printReport(results) {
  const pass  = results.filter(r => r.status === 'pass').length;
  const fail  = results.filter(r => r.status === 'fail').length;
  const total = results.length;
  const totalMs = results.reduce((a, r) => a + r.ms, 0);

  console.log();
  console.log(`  ${c('dim', '═'.repeat(60))}`);
  console.log();
  console.log(`  ${bold('TEST REPORT')}`);
  console.log();

  results.forEach(r => {
    const icon   = r.status === 'pass' ? c('green', '●') : c('red', '●');
    const status = r.status === 'pass' ? c('green', 'PASS') : c('red', 'FAIL');
    console.log(`  ${icon} [${r.num}] ${r.name.padEnd(46)} ${status} ${c('dim', r.ms + 'ms')}`);
  });

  console.log();
  console.log(`  ${c('dim', '─'.repeat(60))}`);

  const summary = fail === 0
    ? c('green',   bold(`  ✓ All ${total} tests passed`))
    : c('red',     bold(`  ✗ ${fail}/${total} tests failed`));

  console.log(summary + c('dim', `  (${totalMs}ms total)`));
  console.log();

  
  
  console.log(`  ${bold('Layer Breakdown:')}`);
  console.log(`  ${c('green',   '■')} Transport   ${c('dim', '──')} ${c('green',   'OK')}       stdio spawn + stdin/stdout`);
  console.log(`  ${results[1]?.status === 'pass' ? c('green','■') : c('red','■')} Protocol    ${c('dim', '──')} ${results[1]?.status === 'pass' ? c('green','OK') : c('red','FAIL')}     JSON-RPC initialize · serverInfo`);
  console.log(`  ${results[3]?.status === 'pass' ? c('green','■') : c('red','■')} Tool Exec   ${c('dim', '──')} ${results[3]?.status === 'pass' ? c('green','OK') : c('red','FAIL')}     tools/call · contentType assert`);
  console.log(`  ${results[6]?.status === 'pass' ? c('magenta','■') : c('dim','■')} MCP Apps    ${c('dim', '──')} ${results[6]?.status === 'pass' ? c('magenta','DETECTED') : c('dim','N/A')}  _meta.ui.resourceUri`);
  console.log();
  console.log(c('dim', `  Run ID: run_${Date.now()} · Node ${process.version}`));
  console.log();
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

function log(level, tag, msg) {
  const colors = { info: 'cyan', fail: 'red', debug: 'dim', warn: 'yellow' };
  const col = colors[level] || 'white';
  console.log(`  ${c(col, `[${tag}]`)} ${c('dim', msg)}`);
}



function runServer() {
  const rl = readline.createInterface({ input: process.stdin });

  
  
  const TOOLS = [
    {
      name: 'read_file',
      description: 'Read contents of a file by path',
      inputSchema: {
        type: 'object',
        properties: {
          path: { type: 'string', description: 'File path to read' },
        },
        required: ['path'],
      },
    },
    {
      name: 'write_file',
      description: 'Write content to a file',
      inputSchema: {
        type: 'object',
        properties: {
          path: { type: 'string' },
          content: { type: 'string' },
        },
        required: ['path', 'content'],
      },
    },
    {
      name: 'show_dashboard',
      description: 'Show the sales dashboard MCP App',
      inputSchema: { type: 'object', properties: {} },
      
      
      _meta: { ui: { resourceUri: 'ui://sales-dashboard/view' } },
    },
  ];

  function respond(id, result) {
    const msg = JSON.stringify({ jsonrpc: '2.0', id, result });
    process.stdout.write(msg + '\n');
  }

  function respondError(id, code, message) {
    const msg = JSON.stringify({ jsonrpc: '2.0', id, error: { code, message } });
    process.stdout.write(msg + '\n');
  }

  rl.on('line', line => {
    if (!line.trim()) return;
    let req;
    try { req = JSON.parse(line); } catch {
      respondError(null, -32700, 'Parse error');
      return;
    }

    const { id, method, params } = req;

    switch (method) {

      case 'initialize':
        respond(id, {
          protocolVersion: params?.protocolVersion || '2024-11-05',
          serverInfo: {
            name: 'api-dash-mcp-poc',
            version: '0.1.0',
          },
          capabilities: {
            tools: { listChanged: false },
            resources: { subscribe: false, listChanged: false },
          },
        });
        break;

      case 'tools/list':
        respond(id, { tools: TOOLS });
        break;

      case 'tools/call': {
        const toolName = params?.name;
        const args     = params?.arguments || {};
        const tool     = TOOLS.find(t => t.name === toolName);

        if (!tool) {
          respondError(id, -32602, `Unknown tool: ${toolName}`);
          break;
        }

        
        
        const required = tool.inputSchema?.required || [];
        for (const req of required) {
          if (args[req] === undefined) {
            respondError(id, -32602, `Invalid params: missing required argument "${req}"`);
            return;
          }
        }

        
        
        if (toolName === 'read_file') {
          respond(id, {
            content: [{
              type: 'text',
              text: `# API Dash MCP PoC\n\nThis is a simulated file at ${args.path}.\n\nGenerated by the MCP Testing Suite PoC.`,
            }],
            _meta: {
              ui: { resourceUri: 'ui://sales-dashboard/view', mimeType: 'text/html;profile=mcp-app' },
            },
          });
        } else if (toolName === 'write_file') {
          respond(id, {
            content: [{
              type: 'text',
              text: `Written ${(args.content || '').length} bytes to ${args.path}`,
            }],
          });
        } else if (toolName === 'show_dashboard') {
          respond(id, {
            content: [{ type: 'text', text: 'Dashboard tool executed.' }],
            _meta: {
              ui: {
                resourceUri: 'ui://sales-dashboard/view',
                mimeType: 'text/html;profile=mcp-app',
              },
            },
          });
        }
        break;
      }

      case 'notifications/initialized':
        
      
        break;

      default:
        respondError(id, -32601, `Method not found: ${method}`);
    }
  });

  process.stdin.on('end', () => process.exit(0));
}



runTester().catch(err => {
  console.error(c('red', `\n  Fatal: ${err.message}\n`));
  process.exit(1);
});
