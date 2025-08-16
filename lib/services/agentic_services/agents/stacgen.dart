import 'dart:convert';

import 'package:genai/agentic_engine/blueprint.dart';

const String _sysprompt = """
You are an expert agent whose one and only task is to generate Server Driven UI Code (json-like) representation from the given inputs.

You will be provided with the Rules of the SDUI language, schema, text description as follows:

SDUI CODE RULES:
$SAMPLE_STAC_RULESET

# Style/Formatting Rules
- No trailing commas. No comments. No undefined props.
- Strings for enums like mainAxisAlignment: "center".
- padding/margin objects may include any of: left,right,top,bottom,all,horizontal,vertical.
- style objects are opaque key-value maps (e.g., in text.style, elevatedButton.style); include only needed keys.

#Behavior Conventions
- Use sizedBox for minor spacing; spacer/expanded for flexible space.
- Use listView for long, homogeneous lists; column for short static stacks.
- Always ensure images have at least src; add fit if necessary (e.g., "cover").
- Prefer card for grouped content with elevation.
- Use gridView only if there are 2+ columns of similar items.

# Validation Checklist (apply before emitting)
- Widgets/props only from catalog.
- All required props present (type, leaf essentials like text.data, image.src).
- Property types correct; no nulls/empties.
- Keys ordered deterministically.

# Inputs
SCHEMA: ```:VAR_INTERMEDIATE_REPR:```
DESCRIPTION: ```:VAR_SEMANTIC_ANALYSIS:```

# Generation Steps (follow silently)
- Read SCHEMA to identify concrete entities/IDs; read DESCRIPTION for layout intent.
- Pick widgets from the catalog that best express the layout.
- Compose from coarse to fine: page → sections → rows/columns → leaf widgets.
- Apply sensible defaults (alignment, spacing) only when needed.
- Validate: catalog-only widgets/props, property types, no unused fields, deterministic ordering.

# Hard Output Contract
- Output MUST be ONLY the SDUI JSON. No prose, no code fences, no comments. Must start with { and end with }.
- Use only widgets and properties from the Widget Catalog below.
- Prefer minimal, valid trees. Omit null/empty props.
- Numeric where numeric, booleans where booleans, strings for enums/keys.
- Color strings allowed (e.g., "#RRGGBB").
- Keep key order consistent: type, then layout/meta props, then child/children.

# Final Instruction
Using SCHEMA and DESCRIPTION, output only the SDUI JSON that satisfies the rules above. DO NOT START OR END THE RESPONSE WITH ANYTHING ELSE.

if there are no scrollable elements then wrap the whole content with a single child scroll view, if there are scrollable contents inside, then apply shrinkWrap and handle accordingly like
you would do in Flutter but in this Stac Representation

""";

class StacGenBot extends APIDashAIAgent {
  @override
  String get agentName => 'STAC_GEN';

  @override
  String getSystemPrompt() {
    return _sysprompt;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    aiResponse = aiResponse.replaceAll('```json', '').replaceAll('```', '');
    //JSON CHECK
    try {
      jsonDecode(aiResponse);
    } catch (e) {
      print("JSON PARSE ERROR: ${e}");
      return false;
    }
    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```json', '')
        .replaceAll('```json\n', '')
        .replaceAll('```', '');

    //Stac Specific Changes
    validatedResponse = validatedResponse.replaceAll('bold', 'w700');

    return {
      'STAC': validatedResponse,
    };
  }
}

const SAMPLE_STAC_RULESET = """

### Scaffold
```
{
  "type": "scaffold",
  "appBar": {
    "type": "appBar",
    "title": {
      "type": "text",
      "data": "App Bar Title"
    }
  },
  "body": {},
  "backgroundColor": "#FFFFFF"
}
```
---
### Align
```
{
  "type": "align",
  "alignment": "topEnd",
  "child": {...}
}
```
---
### Card
```
{
  "type": "card",
  "color": "#FFFFFF",
  "shadowColor": "#000000",
  "surfaceTintColor": "#FF0000",
  "elevation": 5.0,
  "shape": {
    "type": "roundedRectangle",
    "borderRadius": 10.0
  },
  "borderOnForeground": true,
  "margin": {
    "left": 10,
    "top": 20,
    "right": 10,
    "bottom": 20
  },
  "clipBehavior": "antiAlias",
  "child": {},
  "semanticContainer": true
}
```
---
### Center
```
{
  "type": "center",
  "child": {
    "type": "text",
    "data": "Hello, World!"
  }
}
```
---
### Circle Avatar
```
{
  "type": "circleAvatar",
  "backgroundColor": "#FF0000",
  "foregroundColor": "#FFFFFF",
  "backgroundImage": "https://raw.githubusercontent.com/StacDev/stac/refs/heads/dev/assets/companies/bettrdo.jpg",
  "radius": 50,
  "child": {
    "type": "text",
    "data": "A"
  }
}
```
---
### Column
```
{
  "type": "column",
  "mainAxisAlignment": "center",
  "crossAxisAlignment": "start",
  "mainAxisSize": "min",
  "verticalDirection": "up",
  "spacing": 10,
  "children": [
    {
      "type": "text",
      "data": "Hello, World!"
    },
    {
      "type": "container",
      "width": 100,
      "height": 100,
      "color": "#FF0000"
    }
  ]
}
```
---
### Container
```
{
  "type":  "container",
  "alignment":  "center",
  "padding":  {
    "top":  16.0,
    "bottom":  16.0,
    "left":  16.0,
    "right":  16.0
  },
  "decoration":  {
    "color":  "#FF5733",
    "borderRadius":  {
      "topLeft":  16.0,
      "topRight":  16.0,
      "bottomLeft":  16.0,
      "bottomRight":  16.0
    }
  },
  "width":  200.0,
  "height":  200.0,
  "child":  {
    "type":  "text",
    "data":  "Hello, World!",
    "style":  {
      "color":  "#FFFFFF",
      "fontSize":  24.0
    }
  }
}
```
---
### GridView
```
{
  "type": "gridView",
  "physics": "never",
  "shrinkWrap": true,
  "padding": {
    "left": 10,
    "top": 10,
    "right": 10,
    "bottom": 10
  },
  "crossAxisCount": 2,
  "mainAxisSpacing": 10.0,
  "crossAxisSpacing": 10.0,
  "children": [
    {
      "type": "text",
      "data": "Item 1"
    },
    {
      "type": "text",
      "data": "Item 2"
    }
  ],
}
```
---
### Icon
```
{
  "type": "icon",
  "icon": "home",
  "size": 24.0,
  "color": "#000000",
  "semanticLabel": "Home Icon",
  "textDirection": "ltr"
}
```
---
### Image
```
{
  "type": "image",
  "src": "https://example.com/image.png",
  "alignment": "center",
  "imageType": "network",
  "color": "#FFFFFF",
  "width": 200.0,
  "height": 100.0,
  "fit": "contain"
}
```
---
### ListTile
```
{
  "type": "listTile",
  "leading": {
    "type": "image",
    "src": "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
  },
  "title": {},
  "subtitle": {},
  "trailing": {}
}
```
---
### Padding
```
{
	"type":  "padding",
	"padding":  {
	    "top":  80,
	    "left":  24,
	    "right":  24,
	    "bottom":  24
	},
	"child": {...}
}
```
---
### Row
```
{
  "type": "row",
  "mainAxisAlignment": "center",
  "crossAxisAlignment": "center",
  "spacing": 12,
  "children": []
}
```
---
### SingleChildScrollView
```
{
  "type": "singleChildScrollView",
  "child": {
    "type": "column",
    "children": [
      
    ]
  }
}
```
---
### SizedBox
```
{
  "type": "sizedBox",
  "height": 25
}
{
  "type": "sizedBox",
  "width": 25
}
```
---
### Table
```
{
  "type": "table",
  "columnWidths": {
    "1": { "type": "fixedColumnWidth", "value": 200 }
  },
  "defaultColumnWidth": { "type": "flexColumnWidth", "value": 1 },
  "textDirection": "ltr",
  "defaultVerticalAlignment": "bottom",
  "border": {
    "color": "#428AF5",
    "width": 1.0,
    "borderRadius": 16
  },
  "children": [
    {
      "type": "tableRow",
      "children": [
        { "type": "tableCell", "child": { "type": "text", "data": "Header 1" } },
      ]
    },
  ]
}
```
---
### TableCell
```
{
    "type": "tableCell",
    "verticalAlignment": "top",
    "child": {
    "type": "container",
    "color": "#40000000",
    "height": 50.0,
    "child": {
        "type": "center",
        "child": {
        "type": "text",
        "data": "Header 1"
        }
    }
    }
}
```

## Stac Styles (Analogous to Flutter Styles)

### Border Radius
```
//implicit
{
    "borderRadius": 16.0
}
//explicit
{
    "borderRadius": {
        "topLeft": 16.0,
        "topRight": 16.0,
        "bottomLeft": 16.0,
        "bottomRight": 16.0
    }
}
```
---
### Border
```
{
  "border": {
    "color": "#FF0000",
    "width": 2.0,
    "borderStyle": "solid",
    "strokeAlign": 0.0
  }
}
```
""";
