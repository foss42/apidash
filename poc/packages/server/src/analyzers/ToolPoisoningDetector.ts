import type {
  Finding,
  SecurityAnalyzer,
  ServerCapabilities,
  ToolInfo,
} from '@mcp-suite/shared';
import { randomUUID } from 'crypto';

// ---- Pattern definitions ----

interface PatternRule {
  id: string;
  title: string;
  description: string;
  severity: Finding['severity'];
  remediation: string;
  test: (text: string, tool: ToolInfo, allTools: ToolInfo[]) => string | null;
}

const INSTRUCTION_KEYWORDS = [
  'IMPORTANT',
  'ALWAYS',
  'MUST',
  'NEVER',
  'REQUIRED',
  'MANDATORY',
  'DO NOT',
  'YOU SHOULD',
  'YOU MUST',
  'SYSTEM INSTRUCTION',
  'IGNORE PREVIOUS',
  'OVERRIDE',
];

const SECRECY_PATTERNS = [
  /don'?t\s+tell\s+the\s+user/i,
  /do\s+not\s+(mention|reveal|disclose|tell)/i,
  /keep\s+(this\s+)?secret/i,
  /hide\s+(this|the)\s+(from|output)/i,
  /never\s+(show|display|reveal|mention)/i,
  /required\s+for\s+compliance/i,
  /internal\s+use\s+only/i,
];

const DATA_EXFIL_PATTERNS = [
  /send\s+(to|the\s+data|results?\s+to)/i,
  /forward\s+(to|all)/i,
  /exfiltrate/i,
  /upload\s+(to|the)/i,
  /post\s+(to|the\s+data)/i,
  /transmit/i,
  /https?:\/\/[^\s]+/i, // URLs in descriptions are suspicious
];

const SCOPE_ESCALATION_PATTERNS = [
  /conversation\s+history/i,
  /all\s+(previous\s+)?messages/i,
  /credentials?/i,
  /api\s*key/i,
  /password/i,
  /secret/i,
  /token/i,
  /private\s+key/i,
  /session/i,
  /cookie/i,
  /auth(entication|orization)?/i,
  /\.env/i,
  /environment\s+variable/i,
];

// ---- Rules ----

function buildRules(): PatternRule[] {
  return [
    {
      id: 'TP-001',
      title: 'Instruction injection in tool description',
      description:
        'Tool description contains directive keywords that attempt to instruct the LLM directly.',
      severity: 'high',
      remediation:
        'Tool descriptions should describe what the tool does, not instruct the AI model. Remove directive language.',
      test: (text) => {
        const upper = text.toUpperCase();
        const found = INSTRUCTION_KEYWORDS.filter((kw) =>
          upper.includes(kw),
        );
        if (found.length >= 2) {
          return `Contains directive keywords: ${found.join(', ')}`;
        }
        return null;
      },
    },
    {
      id: 'TP-002',
      title: 'Secrecy language in tool description',
      description:
        'Tool description contains language that attempts to hide its behavior from the user.',
      severity: 'critical',
      remediation:
        'Tool descriptions must not instruct the model to conceal information from users. This is a strong indicator of malicious intent.',
      test: (text) => {
        for (const pattern of SECRECY_PATTERNS) {
          const match = text.match(pattern);
          if (match) {
            return `Secrecy pattern found: "${match[0]}"`;
          }
        }
        return null;
      },
    },
    {
      id: 'TP-003',
      title: 'Data exfiltration language in tool description',
      description:
        'Tool description contains language suggesting data should be sent to an external destination.',
      severity: 'critical',
      remediation:
        'Tool descriptions should not instruct data to be sent to external services. Review the tool implementation for data leakage.',
      test: (text) => {
        for (const pattern of DATA_EXFIL_PATTERNS) {
          const match = text.match(pattern);
          if (match) {
            return `Data exfiltration pattern: "${match[0]}"`;
          }
        }
        return null;
      },
    },
    {
      id: 'TP-004',
      title: 'Cross-tool reference in description',
      description:
        'Tool description references another tool by name, which may be an attempt to chain malicious behavior.',
      severity: 'high',
      remediation:
        'Tools should not reference other tools in their descriptions. If coordination is needed, it should be handled at the application level, not in tool metadata.',
      test: (text, tool, allTools) => {
        const otherTools = allTools.filter((t) => t.name !== tool.name);
        for (const other of otherTools) {
          if (text.includes(other.name)) {
            return `References other tool: "${other.name}"`;
          }
        }
        return null;
      },
    },
    {
      id: 'TP-005',
      title: 'Scope escalation in tool description',
      description:
        'Tool description requests access to data outside its apparent purpose (credentials, conversation history, etc.).',
      severity: 'high',
      remediation:
        'Tools should only request data relevant to their stated purpose. A weather tool should not ask for credentials or conversation history.',
      test: (text, tool) => {
        const matched: string[] = [];
        for (const pattern of SCOPE_ESCALATION_PATTERNS) {
          const match = text.match(pattern);
          if (match) {
            matched.push(match[0]);
          }
        }
        // Only flag if the tool name doesn't suggest it should have access
        // e.g., a "login" tool asking for credentials is fine
        const toolNameLower = tool.name.toLowerCase();
        const authRelated = ['auth', 'login', 'credential', 'token', 'session', 'oauth'];
        if (authRelated.some((kw) => toolNameLower.includes(kw))) {
          return null; // expected for auth-related tools
        }
        if (matched.length >= 1) {
          return `Scope escalation: requests "${matched.join('", "')}"`;
        }
        return null;
      },
    },
    {
      id: 'TP-006',
      title: 'Excessive description length',
      description:
        'Tool description is unusually long, which may be used to hide malicious instructions.',
      severity: 'medium',
      remediation:
        'Keep tool descriptions concise. Excessively long descriptions may contain hidden instructions buried in the text.',
      test: (text) => {
        if (text.length > 1000) {
          return `Description is ${text.length} characters (threshold: 1000)`;
        }
        return null;
      },
    },
    {
      id: 'TP-007',
      title: 'Unicode obfuscation in description',
      description:
        'Tool description contains unusual Unicode characters that may be used to hide or obfuscate malicious content.',
      severity: 'high',
      remediation:
        'Tool descriptions should use standard ASCII text. Unicode tricks can hide malicious instructions from human reviewers.',
      test: (text) => {
        // Check for zero-width characters, RTL overrides, homoglyphs
        const suspiciousUnicode =
          /[\u200B\u200C\u200D\u200E\u200F\u202A-\u202E\u2060\u2061\u2062\u2063\u2064\uFEFF]/;
        const match = text.match(suspiciousUnicode);
        if (match) {
          return `Contains suspicious Unicode character: U+${match[0].charCodeAt(0).toString(16).toUpperCase().padStart(4, '0')}`;
        }
        return null;
      },
    },
    {
      id: 'TP-008',
      title: 'Base64 content in description',
      description:
        'Tool description contains what appears to be base64-encoded content, which may hide malicious instructions.',
      severity: 'medium',
      remediation:
        'Decode and review any base64 content in tool descriptions. Encoded content can hide malicious instructions.',
      test: (text) => {
        // Look for base64 strings (at least 20 chars, likely encoded content)
        const base64Pattern = /[A-Za-z0-9+/]{20,}={0,2}/;
        const match = text.match(base64Pattern);
        if (match && match[0].length >= 20) {
          return `Possible base64 content: "${match[0].substring(0, 30)}..."`;
        }
        return null;
      },
    },
    {
      id: 'TP-009',
      title: 'Prompt injection patterns in parameter descriptions',
      description:
        'Parameter descriptions contain injection patterns that could manipulate LLM behavior when processing the schema.',
      severity: 'high',
      remediation:
        'Parameter descriptions should only describe the expected input format and constraints, not contain directives.',
      test: (_text, tool) => {
        const schema = tool.inputSchema;
        const properties =
          (schema?.properties as Record<string, { description?: string }>) ??
          {};
        for (const [paramName, paramDef] of Object.entries(properties)) {
          const desc = paramDef?.description ?? '';
          const upper = desc.toUpperCase();
          const found = INSTRUCTION_KEYWORDS.filter((kw) =>
            upper.includes(kw),
          );
          if (found.length >= 2) {
            return `Parameter "${paramName}" contains directive keywords: ${found.join(', ')}`;
          }
          for (const pattern of SECRECY_PATTERNS) {
            const match = desc.match(pattern);
            if (match) {
              return `Parameter "${paramName}" contains secrecy pattern: "${match[0]}"`;
            }
          }
        }
        return null;
      },
    },
    {
      id: 'TP-010',
      title: 'Shadowed tool name',
      description:
        'Multiple tools share the same name or a tool name mimics a common system tool, which could be used to intercept calls.',
      severity: 'critical',
      remediation:
        'Each tool should have a unique, descriptive name. Tool name shadowing can be used to intercept legitimate tool calls.',
      test: (_text, tool, allTools) => {
        const dupes = allTools.filter((t) => t.name === tool.name);
        if (dupes.length > 1) {
          return `Tool name "${tool.name}" appears ${dupes.length} times`;
        }
        return null;
      },
    },
  ];
}

// ---- Analyzer ----

export class ToolPoisoningDetector implements SecurityAnalyzer {
  name = 'tool-poisoning' as const;
  private rules = buildRules();

  async analyze(capabilities: ServerCapabilities): Promise<Finding[]> {
    const findings: Finding[] = [];
    const tools = capabilities.tools;

    for (const tool of tools) {
      const fullText = [
        tool.description ?? '',
        ...Object.values(
          (tool.inputSchema?.properties as Record<string, { description?: string }>) ?? {},
        ).map((p) => p?.description ?? ''),
      ].join(' ');

      for (const rule of this.rules) {
        const evidence = rule.test(fullText, tool, tools);
        if (evidence) {
          findings.push({
            id: `${rule.id}-${randomUUID().slice(0, 8)}`,
            analyzer: this.name,
            severity: rule.severity,
            title: rule.title,
            description: rule.description,
            toolName: tool.name,
            evidence,
            remediation: rule.remediation,
            timestamp: new Date().toISOString(),
          });
        }
      }
    }

    return findings;
  }
}
