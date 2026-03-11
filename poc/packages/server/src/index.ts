import express from 'express';
import cors from 'cors';
import { WebSocketServer, WebSocket } from 'ws';
import { createServer } from 'http';
import { fileURLToPath } from 'url';
import path from 'path';
import { ZodError } from 'zod';
import { McpClientEngine } from './engine/McpClientEngine.js';
import { ToolPoisoningDetector } from './analyzers/ToolPoisoningDetector.js';
import {
  ConnectRequestSchema,
  InvokeRequestSchema,
  StdioConfigSchema,
} from '@mcp-suite/shared';

function isZodError(err: unknown): err is ZodError {
  return err instanceof ZodError || (err instanceof Error && err.name === 'ZodError');
}

// Resolve project root (poc/) — two levels up from packages/server/src/
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PROJECT_ROOT = path.resolve(__dirname, '..', '..', '..');

const app = express();
app.use(cors());
app.use(express.json());

const engine = new McpClientEngine();
const poisoningDetector = new ToolPoisoningDetector();

// ---- WebSocket broadcast helper ----

const httpServer = createServer(app);
const wss = new WebSocketServer({ server: httpServer });
const clients = new Set<WebSocket>();

wss.on('connection', (ws) => {
  clients.add(ws);
  ws.on('close', () => clients.delete(ws));
});

function broadcast(event: string, data: unknown) {
  const msg = JSON.stringify({ event, data });
  for (const ws of clients) {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(msg);
    }
  }
}

// ---- Helper: format Zod errors ----

function formatZodError(err: ZodError): string {
  return err.errors.map(e => `${e.path.join('.')}: ${e.message}`).join('; ');
}

// ---- Routes ----

app.post('/api/connect', async (req, res) => {
  try {
    
    const body = ConnectRequestSchema.parse(req.body);
    const profile = body.profile;

    if (profile.transport !== 'stdio') {
      res.status(400).json({ error: 'Only stdio transport supported in POC' });
      return;
    }

    /* StdioConfigSchema

      {
        command: z.string().min(1, 'Command is required'),
        args: z.array(z.string()),
        workingDirectory: z.string().optional(),
        env: z.record(z.string()).optional(),
      }

    */

    const config = StdioConfigSchema.parse(profile.config);
    // Default working directory to project root so relative paths work
    if (!config.workingDirectory) {
      config.workingDirectory = PROJECT_ROOT;
    }
    const capabilities = await engine.connectStdio(config);
    broadcast('connected', capabilities);
    res.json(capabilities);
  } catch (err: unknown) {
    if (isZodError(err)) {
      res.status(400).json({ error: formatZodError(err as ZodError) });
      return;
    }
    const message = err instanceof Error ? err.message : 'Unknown error';
    res.status(500).json({ error: message });
  }
});

app.post('/api/disconnect', async (_req, res) => {
  try {
    await engine.disconnect();
    broadcast('disconnected', null);
    res.json({ ok: true });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    res.status(500).json({ error: message });
  }
});

app.get('/api/capabilities', (_req, res) => {
  if (!engine.capabilities) {
    res.status(404).json({ error: 'Not connected' });
    return;
  }
  res.json(engine.capabilities);
});

app.post('/api/invoke', async (req, res) => {
  try {
    const { toolName, args } = InvokeRequestSchema.parse(req.body);
    const result = await engine.invokeTool(toolName, args);
    broadcast('invocation', { toolName, ...result });
    res.json(result);
  } catch (err: unknown) {
    if (isZodError(err)) {
      res.status(400).json({ error: formatZodError(err as ZodError) });
      return;
    }
    const message = err instanceof Error ? err.message : 'Unknown error';
    res.status(500).json({ error: message });
  }
});

app.post('/api/security/scan', async (_req, res) => {
  try {
    if (!engine.capabilities) {
      res.status(400).json({ error: 'Not connected to any server' });
      return;
    }

    broadcast('scan:start', null);
    const findings = await poisoningDetector.analyze(engine.capabilities);

    // Compute score: start at 100, deduct per finding by severity
    const deductions: Record<string, number> = {
      critical: 25,
      high: 15,
      medium: 8,
      low: 3,
      info: 0,
    };

    let score = 100;
    const severityCounts = { critical: 0, high: 0, medium: 0, low: 0, info: 0 };
    for (const f of findings) {
      score -= deductions[f.severity] ?? 0;
      severityCounts[f.severity]++;
    }
    score = Math.max(0, score);

    const result = {
      score,
      findings,
      severityCounts,
      totalFindings: findings.length,
      scannedAt: new Date().toISOString(),
    };

    broadcast('scan:complete', result);
    res.json(result);
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    res.status(500).json({ error: message });
  }
});

app.get('/api/status', (_req, res) => {
  res.json({
    connected: engine.isConnected,
    serverInfo: engine.capabilities?.serverInfo ?? null,
  });
});

// ---- Start ----

const PORT = process.env.PORT ?? 3001;
httpServer.listen(PORT, () => {
  console.log(`MCP Testing Suite API running on http://localhost:${PORT}`);
});
