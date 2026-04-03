# Open Responses MVP for API Dash

## Overview

API Dash currently provides strong raw response inspection through JSON and preview modes, but AI API responses increasingly contain structured outputs that benefit from semantic visualization.

This proposal focuses on adding an MVP layer for Open Responses support by detecting structured response payloads and rendering the most common output blocks inside the response pane without affecting existing preview behavior.

## Problem

Current response rendering treats AI structured outputs as plain JSON.

For Open Responses style payloads, important semantic sections such as:

- messages
- reasoning blocks
- function calls
- tool outputs

are visible only as raw nested objects.

This makes developer inspection slower and reduces clarity when testing AI workflows.

## Proposed Architecture

Raw response → schema detection → semantic classification → optional UI renderer → fallback raw preview

## MVP Scope

### Response Classification

Detect:

- `object == "response"`
- `output[]`

Classify:

- message
- reasoning
- function_call
- tool_result

### Semantic Rendering

Render:

- messages as role-based cards
- reasoning as collapsible sections
- function calls with expandable arguments
- tool outputs linked to call ids

### Generative UI MVP

Support limited UI components:

- text
- card
- list
- button

### Safety

Unsupported payloads fall back to current JSON preview.

## Why this scope

The first version should be mergeable and small enough to preserve current stability while opening a clean path for future provider expansion and richer component support.

## Integration Point

The expected first integration point is the existing response preview layer so that semantic rendering remains optional and does not interfere with raw response inspection.

## Timeline

### Week 1

- inspect response preview integration points
- define schema detection rules

### Week 2

- implement classifier

### Week 3

- add semantic renderer widgets

### Week 4

- tests and documentation

## Expected Result

API Dash should recognize supported Open Responses payloads and present them in a clearer structured view while keeping raw preview intact.