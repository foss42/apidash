# MCP Testing Suite — GSoC 2025 Proposal

**Applicant:** [@souvikDevloper](https://github.com/souvikDevloper)  
**Discussion:** #1225  
**Previous PR:** #1284

## What's in this folder

| Path | What it is |
|------|-----------|
| `mockup/index.html` | Interactive UI mockup — open in any browser, no server needed |
| `poc/poc.js` | Working PoC — real stdio MCP communication, zero dependencies |

## Run the PoC
```bash
node poc/poc.js
```

Expected output: 8 tests, 4-layer breakdown, MCP Apps detection, ~7ms.

## View the mockup

Open `mockup/index.html` in your browser.  
Navigate: Overview → Session Setup → Scenario Runner → Trace Inspection → Replay & Compare → **MCP Apps Preview** (new — working iframe handshake PoC).

## Demo video

https://youtu.be/GAZrTeIq_M0
