#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');
const readline = require('readline');

// 1. Specify the exact path to your built release executable

// __dirname is "apidash/scripts"
// '..' takes us up to the root folder "apidash/"
const EXE_PATH = path.join(__dirname, '..', 'build', 'windows', 'x64', 'runner', 'Release', 'apidash.exe');

// 2. Spawn the Flutter app directly into the headless engine mode
const flutterEngine = spawn(EXE_PATH, ['--mcp-engine'], {
    stdio: ['pipe', 'pipe', 'inherit'] // Inherit stderr so we can see real crashes
});

// 3. Pipe VS Code's standard input directly to the Flutter engine
process.stdin.pipe(flutterEngine.stdin);

// 4. Interface with the engine's stdout line-by-line
const rl = readline.createInterface({
    input: flutterEngine.stdout,
    terminal: false
});

rl.on('line', (line) => {
    const trimmed = line.trim();
    // MCP protocol strictly requires single-line JSON RPC frames.
    // If it's valid JSON, pass it securely to VS Code.
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        process.stdout.write(line + '\n');
    } else if (trimmed.length > 0) {
        // Redirect raw C++ DLL/Flutter engine log garbage safely to stderr
        // where VS Code extension logs capture it, but it won't break the JSON stream.
        process.stderr.write(`[Flutter Native Log]: ${line}\n`);
    }
});

// 5. CRITICAL LIFECYCLE MANAGEMENT: Prevent Orphan Processes
// When VS Code cuts the connection or terminates Node, kill the Flutter engine immediately.
const cleanup = () => {
    flutterEngine.kill('SIGTERM');
    process.exit(0);
};

process.on('SIGINT', cleanup);
process.on('SIGTERM', cleanup);
process.on('exit', () => flutterEngine.kill('SIGKILL'));
flutterEngine.on('exit', (code) => process.exit(code || 0));