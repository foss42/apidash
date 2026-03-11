import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  AppShell, NavLink, Card, Text, Title, Badge, Button, TextInput,
  Group, Stack, RingProgress, Accordion, Code, Divider,
  ThemeIcon, Box, Alert, Transition,
} from '@mantine/core';
import {
  Shield, Plug, Unplug, AlertTriangle, AlertCircle, Info, CheckCircle2,
  Terminal, Wrench, FileText, MessageSquare, Search, ShieldCheck,
  ShieldAlert, Clock, Zap, Server, ScanLine, Package, Sparkles, Activity,
  ChevronRight, Play,
} from 'lucide-react';
import type { ServerCapabilities, ToolInfo, Finding, InvokeResponse, ScanResult } from '@mcp-suite/shared';
import { api } from './services/api';

type View = 'connect' | 'tools' | 'security';

// ================================================================
// App
// ================================================================

export default function App() {
  const [view, setView] = useState<View>('connect');
  const [capabilities, setCapabilities] = useState<ServerCapabilities | null>(null);
  const [connected, setConnected] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [command, setCommand] = useState('npx');
  const [args, setArgs] = useState('tsx test/fixtures/poisoned-server.ts');
  const [selectedTool, setSelectedTool] = useState<ToolInfo | null>(null);
  const [toolArgs, setToolArgs] = useState<Record<string, string>>({});
  const [invokeResult, setInvokeResult] = useState<InvokeResponse | null>(null);
  const [invoking, setInvoking] = useState(false);
  const [scanResult, setScanResult] = useState<ScanResult | null>(null);
  const [scanning, setScanning] = useState(false);

  async function handleConnect() {
    setError(null); setLoading(true);
    try {
      const caps = await api.connect({
        id: 'poc', name: 'POC', transport: 'stdio',
        config: { command, args: args.split(/\s+/), workingDirectory: undefined },
        createdAt: new Date().toISOString(),
      });
      setCapabilities(caps); setConnected(true); setView('tools');
    } catch (e: unknown) { setError(e instanceof Error ? e.message : 'Connection failed'); }
    finally { setLoading(false); }
  }

  async function handleDisconnect() {
    try { await api.disconnect(); } catch { /* noop */ }
    setConnected(false); setCapabilities(null); setSelectedTool(null);
    setInvokeResult(null); setScanResult(null); setView('connect');
  }

  async function handleInvoke() {
    if (!selectedTool) return;
    setInvoking(true); setInvokeResult(null);
    try {
      const parsed: Record<string, unknown> = {};
      const props = (selectedTool.inputSchema?.properties ?? {}) as Record<string, { type?: string }>;
      for (const [k, v] of Object.entries(toolArgs)) {
        if (v === '') continue;
        const t = props[k]?.type;
        if (t === 'number' || t === 'integer') parsed[k] = Number(v);
        else if (t === 'boolean') parsed[k] = v === 'true';
        else parsed[k] = v;
      }
      setInvokeResult(await api.invoke(selectedTool.name, parsed));
    } catch (e: unknown) {
      setInvokeResult({ result: e instanceof Error ? e.message : 'Error', isError: true, latencyMs: 0 });
    } finally { setInvoking(false); }
  }

  async function handleScan() {
    setScanning(true); setScanResult(null);
    try { setScanResult(await api.scan()); }
    catch (e: unknown) { setError(e instanceof Error ? e.message : 'Scan failed'); }
    finally { setScanning(false); }
  }

  return (
    <AppShell
      navbar={{ width: 260, breakpoint: 0 }}
      styles={{
        root: { height: '100%' },
        main: { background: 'var(--bg-base)', minHeight: '100%' },
        navbar: { background: 'var(--bg-raised)', borderColor: 'var(--border-subtle)' },
      }}
    >
      {/* ── Sidebar ── */}
      <AppShell.Navbar p="md">
        <Stack h="100%" gap={0}>
          {/* Brand */}
          <Group gap="sm" mb="xl" px="xs">
            <ThemeIcon size={36} radius="md" variant="gradient" gradient={{ from: 'cyan.5', to: 'blue.5', deg: 135 }}>
              <Shield size={18} />
            </ThemeIcon>
            <div>
              <Text size="sm" fw={700} c="var(--text-primary)">MCP Suite</Text>
              <Text size="10px" fw={600} tt="uppercase" lts="0.12em" c="dimmed">Security</Text>
            </div>
          </Group>

          {/* Nav */}
          <Stack gap={4} flex={1}>
            <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed" px="sm" mb={4}>Menu</Text>
            <NavLink
              label="Connection" leftSection={<Plug size={16} />} active={view === 'connect'}
              onClick={() => setView('connect')} variant="filled"
              styles={{ root: { borderRadius: 12, color: view === 'connect' ? 'var(--accent)' : 'var(--text-tertiary)', background: view === 'connect' ? 'var(--accent-muted)' : 'transparent' } }}
            />
            <NavLink
              label="Tool Explorer" leftSection={<Package size={16} />} active={view === 'tools'}
              disabled={!connected} onClick={() => setView('tools')} variant="filled"
              rightSection={capabilities ? <Badge size="xs" variant="light" color="cyan" radius="sm">{capabilities.tools.length}</Badge> : null}
              styles={{ root: { borderRadius: 12, color: view === 'tools' ? 'var(--accent)' : 'var(--text-tertiary)', background: view === 'tools' ? 'var(--accent-muted)' : 'transparent' } }}
            />
            <NavLink
              label="Security Scan" leftSection={<ScanLine size={16} />} active={view === 'security'}
              disabled={!connected} onClick={() => setView('security')} variant="filled"
              rightSection={scanResult && scanResult.totalFindings > 0 ? <Badge size="xs" variant="light" color="red" radius="sm">{scanResult.totalFindings}</Badge> : null}
              styles={{ root: { borderRadius: 12, color: view === 'security' ? 'var(--accent)' : 'var(--text-tertiary)', background: view === 'security' ? 'var(--accent-muted)' : 'transparent' } }}
            />
          </Stack>

          {/* Connection status footer */}
          <Card radius="lg" p="sm" bg="var(--bg-surface)" withBorder style={{ borderColor: 'var(--border-subtle)' }}>
            {connected && capabilities ? (
              <Stack gap={6}>
                <Group gap={8}>
                  <Box w={8} h={8} style={{ borderRadius: '50%', background: '#22c55e', boxShadow: '0 0 8px rgba(34,197,94,0.5)' }} />
                  <Text size="xs" fw={600} c="var(--text-primary)">{capabilities.serverInfo.name}</Text>
                </Group>
                <Group gap={8} ml={16}>
                  <Text size="10px" c="dimmed">v{capabilities.serverInfo.version}</Text>
                  <Text size="10px" c="dimmed">·</Text>
                  <Text size="10px" c="dimmed">{capabilities.tools.length} tools</Text>
                </Group>
                <Button
                  variant="subtle" size="compact-xs" color="red" leftSection={<Unplug size={11} />}
                  onClick={handleDisconnect} ml={12} mt={2} w="fit-content"
                  styles={{ root: { fontWeight: 500 } }}
                >
                  Disconnect
                </Button>
              </Stack>
            ) : (
              <Group gap={8}>
                <Box w={8} h={8} style={{ borderRadius: '50%', background: 'var(--text-muted)' }} />
                <Text size="xs" c="dimmed">No connection</Text>
              </Group>
            )}
          </Card>
        </Stack>
      </AppShell.Navbar>

      {/* ── Main ── */}
      <AppShell.Main>
        {/* Error banner */}
        <Transition mounted={!!error} transition="slide-down" duration={200}>
          {(styles) => (
            <Box style={styles} px="xl" pt="md">
              <Alert
                icon={<AlertCircle size={16} />} color="red" variant="light" radius="lg"
                withCloseButton onClose={() => setError(null)}
                styles={{ root: { background: 'rgba(239,68,68,0.06)', borderColor: 'rgba(239,68,68,0.12)' } }}
              >
                {error}
              </Alert>
            </Box>
          )}
        </Transition>

        <Box h="100%" style={{ overflow: 'auto' }}>
          <AnimatePresence mode="wait">
            {view === 'connect' && <ConnectionView key="conn" command={command} setCommand={setCommand} args={args} setArgs={setArgs} onConnect={handleConnect} loading={loading} connected={connected} />}
            {view === 'tools' && capabilities && (
              <ToolsView key="tools" capabilities={capabilities} selectedTool={selectedTool}
                onSelectTool={(t) => { setSelectedTool(t); setInvokeResult(null); setToolArgs({}); }}
                toolArgs={toolArgs} setToolArgs={setToolArgs} onInvoke={handleInvoke}
                invokeResult={invokeResult} invoking={invoking} />
            )}
            {view === 'security' && <SecurityView key="sec" scanResult={scanResult} scanning={scanning} onScan={handleScan} capabilities={capabilities} />}
          </AnimatePresence>
        </Box>
      </AppShell.Main>
    </AppShell>
  );
}

// ================================================================
// Connection View
// ================================================================

function ConnectionView({ command, setCommand, args, setArgs, onConnect, loading, connected }: {
  command: string; setCommand: (v: string) => void; args: string; setArgs: (v: string) => void;
  onConnect: () => void; loading: boolean; connected: boolean;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -8 }}
      transition={{ duration: 0.3 }}
      style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: '100%', padding: 32 }}
    >
      <Box w="100%" maw={480}>
        {/* Hero */}
        <Stack align="center" mb={40} gap="md">
          <Box pos="relative">
            <Box pos="absolute" top={-8} left={-8} right={-8} bottom={-8}
              style={{ borderRadius: 24, background: 'var(--accent-glow)', filter: 'blur(20px)' }} />
            <ThemeIcon size={72} radius={20} variant="gradient" gradient={{ from: 'cyan.4', to: 'blue.5', deg: 135 }}
              style={{ position: 'relative', boxShadow: '0 0 40px var(--accent-glow)' }}>
              <Server size={34} />
            </ThemeIcon>
          </Box>
          <Title order={2} ta="center" c="var(--text-primary)" style={{ letterSpacing: '-0.02em' }}>
            Connect to MCP Server
          </Title>
          <Text size="sm" ta="center" c="dimmed" maw={340}>
            Spawn a local server process and start exploring tools and security posture
          </Text>
        </Stack>

        {/* Form */}
        <Card radius="xl" p="xl" bg="var(--bg-raised)" withBorder style={{ borderColor: 'var(--border-default)' }}>
          <Stack gap="lg">
            <div>
              <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed" mb={8}>Transport</Text>
              <Card radius="md" p="sm" bg="var(--bg-surface)" withBorder style={{ borderColor: 'var(--border-subtle)' }}>
                <Group gap="sm">
                  <ThemeIcon size={28} radius="sm" variant="light" color="cyan">
                    <Terminal size={14} />
                  </ThemeIcon>
                  <div>
                    <Text size="sm" fw={600} c="var(--text-primary)">stdio</Text>
                    <Text size="xs" c="dimmed">Local process via stdin/stdout</Text>
                  </div>
                </Group>
              </Card>
            </div>

            <TextInput
              label="Command" placeholder="npx, node, python..."
              value={command} onChange={(e) => setCommand(e.target.value)}
              styles={{
                label: { fontSize: 10, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.12em', color: 'var(--text-muted)', marginBottom: 8 },
                input: { background: 'var(--bg-surface)', borderColor: 'var(--border-subtle)', color: 'var(--text-primary)', borderRadius: 12, height: 44, '&:focus': { borderColor: 'var(--accent)' } },
              }}
            />

            <TextInput
              label="Arguments" placeholder="path/to/server.ts"
              value={args} onChange={(e) => setArgs(e.target.value)}
              styles={{
                label: { fontSize: 10, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.12em', color: 'var(--text-muted)', marginBottom: 8 },
                input: { background: 'var(--bg-surface)', borderColor: 'var(--border-subtle)', color: 'var(--text-primary)', borderRadius: 12, height: 44 },
              }}
            />

            <Button
              fullWidth size="lg" radius="lg"
              variant="gradient" gradient={{ from: 'cyan.5', to: 'blue.5', deg: 135 }}
              leftSection={loading ? <Sparkles size={16} className="animate-spin" /> : <Zap size={16} />}
              onClick={onConnect} disabled={loading || connected || !command.trim()}
              loading={loading} loaderProps={{ type: 'dots', color: 'white' }}
              styles={{ root: { height: 48, fontWeight: 600, boxShadow: '0 0 24px var(--accent-glow)' } }}
            >
              {loading ? 'Connecting...' : connected ? 'Connected' : 'Connect'}
            </Button>
          </Stack>
        </Card>

        <Text size="xs" ta="center" c="dimmed" mt="lg">
          Demo: <Code style={{ background: 'var(--bg-surface)', color: 'var(--text-secondary)' }}>
            test/fixtures/poisoned-server.ts
          </Code>
        </Text>
      </Box>
    </motion.div>
  );
}

// ================================================================
// Tools View
// ================================================================

function ToolsView({ capabilities, selectedTool, onSelectTool, toolArgs, setToolArgs, onInvoke, invokeResult, invoking }: {
  capabilities: ServerCapabilities; selectedTool: ToolInfo | null; onSelectTool: (t: ToolInfo) => void;
  toolArgs: Record<string, string>; setToolArgs: (a: Record<string, string>) => void;
  onInvoke: () => void; invokeResult: InvokeResponse | null; invoking: boolean;
}) {
  return (
    <motion.div
      initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
      transition={{ duration: 0.2 }}
      style={{ display: 'flex', height: '100%' }}
    >
      {/* Explorer sidebar */}
      <Box w={280} style={{ flexShrink: 0, borderRight: '1px solid var(--border-subtle)', background: 'var(--bg-raised)', overflow: 'auto' }}>
        <Box px="md" py="sm" style={{ borderBottom: '1px solid var(--border-subtle)' }}>
          <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed">Server Explorer</Text>
        </Box>

        <Stack gap={0} py="xs">
          {/* Tools section */}
          <Group px="md" py={6} gap={6}>
            <Wrench size={12} style={{ color: 'var(--accent)' }} />
            <Text size="xs" fw={700} tt="uppercase" lts="0.1em" c="dimmed" flex={1}>Tools</Text>
            <Badge size="xs" variant="light" color="cyan" radius="sm">{capabilities.tools.length}</Badge>
          </Group>
          {capabilities.tools.map(tool => (
            <NavLink key={tool.name}
              label={<Text size="sm" fw={selectedTool?.name === tool.name ? 600 : 400} truncate>{tool.name}</Text>}
              active={selectedTool?.name === tool.name}
              onClick={() => onSelectTool(tool)}
              leftSection={<Box w={5} h={5} style={{ borderRadius: '50%', background: selectedTool?.name === tool.name ? 'var(--accent)' : 'var(--text-muted)' }} />}
              rightSection={selectedTool?.name === tool.name ? <ChevronRight size={14} style={{ color: 'var(--accent)' }} /> : null}
              styles={{
                root: {
                  borderRadius: 0,
                  borderLeft: selectedTool?.name === tool.name ? '2px solid var(--accent)' : '2px solid transparent',
                  background: selectedTool?.name === tool.name ? 'var(--accent-muted)' : 'transparent',
                  color: selectedTool?.name === tool.name ? 'var(--accent)' : 'var(--text-secondary)',
                },
              }}
            />
          ))}

          {/* Resources */}
          {capabilities.resources.length > 0 && (
            <>
              <Divider my="xs" color="var(--border-subtle)" />
              <Group px="md" py={6} gap={6}>
                <FileText size={12} style={{ color: 'var(--text-muted)' }} />
                <Text size="xs" fw={700} tt="uppercase" lts="0.1em" c="dimmed" flex={1}>Resources</Text>
                <Badge size="xs" variant="light" color="gray" radius="sm">{capabilities.resources.length}</Badge>
              </Group>
              {capabilities.resources.map(r => (
                <Box key={r.uri} px="md" py={6}>
                  <Text size="xs" c="dimmed" truncate>{r.name}</Text>
                </Box>
              ))}
            </>
          )}

          {/* Prompts */}
          {capabilities.prompts.length > 0 && (
            <>
              <Divider my="xs" color="var(--border-subtle)" />
              <Group px="md" py={6} gap={6}>
                <MessageSquare size={12} style={{ color: 'var(--text-muted)' }} />
                <Text size="xs" fw={700} tt="uppercase" lts="0.1em" c="dimmed" flex={1}>Prompts</Text>
                <Badge size="xs" variant="light" color="gray" radius="sm">{capabilities.prompts.length}</Badge>
              </Group>
              {capabilities.prompts.map(p => (
                <Box key={p.name} px="md" py={6}>
                  <Text size="xs" c="dimmed" truncate>{p.name}</Text>
                </Box>
              ))}
            </>
          )}
        </Stack>
      </Box>

      {/* Detail pane */}
      <Box flex={1} style={{ overflow: 'auto' }}>
        {!selectedTool ? (
          <Stack align="center" justify="center" h="100%" gap="md">
            <ThemeIcon size={64} radius="xl" variant="light" color="gray">
              <Search size={28} />
            </ThemeIcon>
            <div style={{ textAlign: 'center' }}>
              <Text size="sm" fw={500} c="dimmed">Select a tool to inspect</Text>
              <Text size="xs" c="dimmed" mt={4}>Choose from the explorer panel</Text>
            </div>
          </Stack>
        ) : (
          <motion.div key={selectedTool.name} initial={{ opacity: 0, x: 12 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.2 }}>
            <Box p="xl" maw={680}>
              {/* Tool header */}
              <Group gap="md" mb="xl">
                <ThemeIcon size={48} radius="lg" variant="light" color="cyan">
                  <Wrench size={22} />
                </ThemeIcon>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <Title order={3} c="var(--text-primary)" style={{ letterSpacing: '-0.01em' }}>{selectedTool.name}</Title>
                  {selectedTool.description && (
                    <Text size="sm" c="dimmed" mt={4} lineClamp={3}>{selectedTool.description}</Text>
                  )}
                </div>
              </Group>

              {/* Parameters */}
              <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed" mb="sm">
                <Group gap={6}><Sparkles size={11} /> Parameters</Group>
              </Text>
              <Stack gap="sm" mb="xl">
                {Object.entries(
                  (selectedTool.inputSchema?.properties ?? {}) as Record<string, { type?: string; description?: string }>
                ).map(([name, schema]) => {
                  const required = ((selectedTool.inputSchema?.required ?? []) as string[]).includes(name);
                  return (
                    <Card key={name} radius="lg" p="md" bg="var(--bg-raised)" withBorder style={{ borderColor: 'var(--border-subtle)' }}>
                      <Group gap="sm" mb={schema.description ? 'xs' : 'sm'}>
                        <Text size="sm" fw={600} c="var(--text-primary)">{name}</Text>
                        <Badge size="xs" variant="light" color="cyan" radius="sm" tt="none">
                          {schema.type ?? 'any'}
                        </Badge>
                        {required && <Badge size="xs" variant="light" color="red" radius="sm">required</Badge>}
                      </Group>
                      {schema.description && (
                        <Text size="xs" c="dimmed" mb="sm" lineClamp={2}>{schema.description}</Text>
                      )}
                      <TextInput
                        placeholder={`Enter ${name}...`}
                        value={toolArgs[name] ?? ''} onChange={(e) => setToolArgs({ ...toolArgs, [name]: e.target.value })}
                        styles={{
                          input: { background: 'var(--bg-surface)', borderColor: 'var(--border-subtle)', color: 'var(--text-primary)', borderRadius: 10 },
                        }}
                      />
                    </Card>
                  );
                })}
              </Stack>

              <Button
                variant="gradient" gradient={{ from: 'cyan.5', to: 'blue.5', deg: 135 }}
                radius="lg" size="md"
                leftSection={invoking ? null : <Play size={15} />}
                onClick={onInvoke} disabled={invoking} loading={invoking}
                loaderProps={{ type: 'dots', color: 'white' }}
                styles={{ root: { fontWeight: 600, boxShadow: '0 0 20px var(--accent-glow)' } }}
              >
                {invoking ? 'Running...' : 'Invoke Tool'}
              </Button>

              {/* Response */}
              <AnimatePresence>
                {invokeResult && (
                  <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }}>
                    <Box mt="xl">
                      <Group gap="sm" mb="sm">
                        <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed">
                          <Group gap={6}><Activity size={11} /> Response</Group>
                        </Text>
                        <Badge size="xs" variant="light" color={invokeResult.isError ? 'red' : 'green'} radius="sm">
                          {invokeResult.isError ? 'ERROR' : 'SUCCESS'}
                        </Badge>
                        <Group gap={4}>
                          <Clock size={10} style={{ color: 'var(--text-muted)' }} />
                          <Text size="xs" c="dimmed">{invokeResult.latencyMs}ms</Text>
                        </Group>
                      </Group>
                      <Code block
                        styles={{
                          root: {
                            background: 'var(--bg-surface)',
                            color: 'var(--text-primary)',
                            borderRadius: 16,
                            padding: 20,
                            border: '1px solid var(--border-default)',
                            maxHeight: 420,
                            overflow: 'auto',
                            fontSize: 12,
                          },
                        }}
                      >
                        {JSON.stringify(invokeResult.result, null, 2)}
                      </Code>
                    </Box>
                  </motion.div>
                )}
              </AnimatePresence>
            </Box>
          </motion.div>
        )}
      </Box>
    </motion.div>
  );
}

// ================================================================
// Security View
// ================================================================

const SEVERITY_CONFIG: Record<string, { color: string; mantineColor: string; icon: React.ReactNode }> = {
  critical: { color: '#dc2626', mantineColor: 'red', icon: <AlertCircle size={14} /> },
  high:     { color: '#ef4444', mantineColor: 'red', icon: <AlertTriangle size={14} /> },
  medium:   { color: '#f59e0b', mantineColor: 'yellow', icon: <AlertTriangle size={14} /> },
  low:      { color: '#38bdf8', mantineColor: 'cyan', icon: <Info size={14} /> },
  info:     { color: '#71717a', mantineColor: 'gray', icon: <Info size={14} /> },
};

const SEVERITY_ORDER = ['critical', 'high', 'medium', 'low', 'info'] as const;

function SecurityView({ scanResult, scanning, onScan, capabilities }: {
  scanResult: ScanResult | null; scanning: boolean; onScan: () => void; capabilities: ServerCapabilities | null;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -8 }}
      transition={{ duration: 0.3 }}
    >
      <Box p="xl" maw={960} mx="auto">
        {/* Header */}
        <Group justify="space-between" mb="xl">
          <Group gap="md">
            <ThemeIcon size={48} radius="lg" variant="light" color="cyan">
              <ShieldCheck size={24} />
            </ThemeIcon>
            <div>
              <Title order={3} c="var(--text-primary)" style={{ letterSpacing: '-0.01em' }}>Security Analysis</Title>
              <Text size="sm" c="dimmed">Scan for tool poisoning, injection patterns, and misconfigurations</Text>
            </div>
          </Group>
          <Button
            variant="gradient" gradient={{ from: 'cyan.5', to: 'blue.5', deg: 135 }}
            radius="lg" size="md"
            leftSection={scanning ? null : <ScanLine size={16} />}
            onClick={onScan} disabled={scanning || !capabilities}
            loading={scanning} loaderProps={{ type: 'dots', color: 'white' }}
            styles={{ root: { fontWeight: 600, boxShadow: '0 0 20px var(--accent-glow)' } }}
          >
            {scanning ? 'Scanning...' : 'Run Scan'}
          </Button>
        </Group>

        {/* Empty state */}
        {!scanResult && !scanning && (
          <Card radius="xl" p={60} bg="var(--bg-raised)" withBorder
            style={{ borderColor: 'var(--border-subtle)', borderStyle: 'dashed', textAlign: 'center' }}>
            <Stack align="center" gap="md">
              <ThemeIcon size={64} radius="xl" variant="light" color="gray">
                <ShieldAlert size={30} />
              </ThemeIcon>
              <div>
                <Text size="sm" fw={500} c="dimmed">No scan results yet</Text>
                <Text size="xs" c="dimmed" mt={4}>Run a scan to analyze the connected server</Text>
              </div>
            </Stack>
          </Card>
        )}

        {scanResult && (
          <Stack gap="lg">
            {/* Score + Severity breakdown */}
            <div style={{ display: 'grid', gridTemplateColumns: '240px 1fr', gap: 16 }}>
              <ScoreRing score={scanResult.score} />
              <SeverityBreakdown counts={scanResult.severityCounts} total={scanResult.totalFindings} />
            </div>

            {/* Findings */}
            <div>
              <Group gap="sm" mb="md">
                <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed">
                  <Group gap={6}><AlertTriangle size={11} /> Findings</Group>
                </Text>
                <Badge size="xs" variant="light" color="gray" radius="sm">{scanResult.totalFindings}</Badge>
              </Group>

              {scanResult.findings.length === 0 ? (
                <Card radius="xl" p={48} bg="rgba(34,197,94,0.06)" style={{ border: '1px solid rgba(34,197,94,0.12)', textAlign: 'center' }}>
                  <CheckCircle2 size={32} style={{ color: '#4ade80', margin: '0 auto 8px' }} />
                  <Text size="sm" fw={600} style={{ color: '#4ade80' }}>All clear</Text>
                  <Text size="xs" style={{ color: '#22c55e' }} mt={2}>No security issues detected</Text>
                </Card>
              ) : (
                <Accordion
                  variant="separated" radius="lg"
                  styles={{
                    item: { background: 'var(--bg-raised)', borderColor: 'var(--border-subtle)', '&[data-active]': { borderColor: 'var(--border-strong)' } },
                    control: { padding: '16px 20px', '&:hover': { background: 'var(--bg-surface-hover)' } },
                    content: { padding: '0 20px 20px' },
                  }}
                >
                  {scanResult.findings.map((f, i) => (
                    <motion.div key={f.id} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.03 }}>
                      <FindingItem finding={f} />
                    </motion.div>
                  ))}
                </Accordion>
              )}
            </div>
          </Stack>
        )}
      </Box>
    </motion.div>
  );
}

// ================================================================
// Score Ring
// ================================================================

function ScoreRing({ score }: { score: number }) {
  const color = score >= 80 ? '#22c55e' : score >= 50 ? '#f59e0b' : '#ef4444';
  const mantineColor = score >= 80 ? 'green' : score >= 50 ? 'yellow' : 'red';
  const label = score >= 80 ? 'Secure' : score >= 50 ? 'At Risk' : 'Critical';
  const glow = score >= 80 ? 'rgba(34,197,94,0.12)' : score >= 50 ? 'rgba(245,158,11,0.12)' : 'rgba(239,68,68,0.12)';

  return (
    <Card radius="xl" p="lg" bg="var(--bg-raised)" withBorder
      style={{ borderColor: 'var(--border-default)', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', boxShadow: `0 0 40px ${glow}` }}>
      <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed" mb="sm">Security Score</Text>
      <RingProgress
        size={140} thickness={10} roundCaps
        sections={[{ value: score, color }]}
        label={
          <Stack align="center" gap={0}>
            <Text size="28px" fw={800} style={{ color, lineHeight: 1 }}>{score}</Text>
            <Text size="xs" c="dimmed">/ 100</Text>
          </Stack>
        }
      />
      <Badge mt="sm" variant="light" color={mantineColor} radius="md" size="sm" fw={700}>
        {label}
      </Badge>
    </Card>
  );
}

// ================================================================
// Severity Breakdown
// ================================================================

function SeverityBreakdown({ counts, total }: { counts: Record<string, number>; total: number }) {
  return (
    <Card radius="xl" p="lg" bg="var(--bg-raised)" withBorder style={{ borderColor: 'var(--border-default)' }}>
      <Group justify="space-between" mb="lg">
        <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed">
          <Group gap={6}><Activity size={11} /> Severity Breakdown</Group>
        </Text>
        <Text size="xs" c="dimmed">{total} findings</Text>
      </Group>
      <Stack gap="md" justify="center" flex={1}>
        {SEVERITY_ORDER.map((key) => {
          const count = counts[key] ?? 0;
          const pct = total > 0 ? (count / total) * 100 : 0;
          const cfg = SEVERITY_CONFIG[key];
          return (
            <Group key={key} gap="sm" wrap="nowrap">
              <Group gap={8} w={80} justify="flex-end" wrap="nowrap">
                <Box w={7} h={7} style={{ borderRadius: '50%', background: cfg.color, flexShrink: 0 }} />
                <Text size="xs" fw={500} c="dimmed" style={{ textTransform: 'capitalize' }}>{key}</Text>
              </Group>
              <Box flex={1} h={7} style={{ borderRadius: 99, background: 'var(--bg-overlay)', overflow: 'hidden' }}>
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: `${Math.max(pct, count > 0 ? 4 : 0)}%` }}
                  transition={{ duration: 0.8, ease: 'easeOut' }}
                  style={{ height: '100%', borderRadius: 99, background: cfg.color }}
                />
              </Box>
              <Text size="xs" fw={700} w={24} ta="right" style={{ color: count > 0 ? cfg.color : 'var(--text-muted)', fontVariantNumeric: 'tabular-nums' }}>
                {count}
              </Text>
            </Group>
          );
        })}
      </Stack>
    </Card>
  );
}

// ================================================================
// Finding Item (Accordion)
// ================================================================

function FindingItem({ finding }: { finding: Finding }) {
  const cfg = SEVERITY_CONFIG[finding.severity] ?? SEVERITY_CONFIG.info;

  return (
    <Accordion.Item value={finding.id}>
      <Accordion.Control>
        <Group gap="sm" wrap="nowrap">
          <ThemeIcon size={32} radius="md" variant="light" color={cfg.mantineColor}>
            {cfg.icon}
          </ThemeIcon>
          <div style={{ flex: 1, minWidth: 0 }}>
            <Text size="sm" fw={600} c="var(--text-primary)">{finding.title}</Text>
            <Group gap={8} mt={2}>
              {finding.toolName && (
                <Badge size="xs" variant="light" color="gray" radius="sm" tt="none">
                  {finding.toolName}
                </Badge>
              )}
              <Badge size="xs" variant="light" color={cfg.mantineColor} radius="sm" tt="uppercase">
                {finding.severity}
              </Badge>
            </Group>
          </div>
        </Group>
      </Accordion.Control>
      <Accordion.Panel>
        <Stack gap="md">
          <Text size="sm" c="dimmed" lh={1.7}>{finding.description}</Text>

          {finding.evidence && (
            <div>
              <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed" mb={8}>
                <Group gap={6}><Search size={10} /> Evidence</Group>
              </Text>
              <Code block
                styles={{
                  root: {
                    background: `${cfg.color}10`,
                    color: cfg.color,
                    borderRadius: 12,
                    padding: 16,
                    border: `1px solid ${cfg.color}22`,
                    fontSize: 12,
                  },
                }}
              >
                {finding.evidence}
              </Code>
            </div>
          )}

          {finding.remediation && (
            <div>
              <Text size="10px" fw={700} tt="uppercase" lts="0.12em" c="dimmed" mb={8}>
                <Group gap={6}><CheckCircle2 size={10} /> Remediation</Group>
              </Text>
              <Card radius="md" p="md" bg="var(--accent-muted)" style={{ border: '1px solid rgba(56,189,248,0.12)' }}>
                <Group gap="sm" align="flex-start" wrap="nowrap">
                  <CheckCircle2 size={16} style={{ color: 'var(--accent)', flexShrink: 0, marginTop: 2 }} />
                  <Text size="sm" lh={1.7} style={{ color: 'var(--accent-dark)' }}>{finding.remediation}</Text>
                </Group>
              </Card>
            </div>
          )}
        </Stack>
      </Accordion.Panel>
    </Accordion.Item>
  );
}
