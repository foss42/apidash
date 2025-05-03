const GENERAL_ARG_PROPERTY_FORMAT_PY = """:ARG_NAME: {
  "type": ":ARG_TYPE:",
  "description: ":ARG_DESC:"
}""";

const GENERAL_PYTHON_TOOL_FORMAT = """
:FUNC:

api_tool = {
    "function": func,
    "definition": {
        "name": ":TOOL_NAME:",
        "description": ":TOOL_DESCRIPTION:",
        "parameters": {
            "type": "object",
            "properties": :TOOL_PARAMS:,
            "required": [:REQUIRED_PARAM_NAMES:],
            "additionalProperties": False
        }
    }
}

__all__ = ["api_tool"]
""";

const GENERAL_JAVASCRIPT_TOOL_FORMAT = """
:FUNC:

const apiTool = {
  function: func,
  definition: {
    type: 'function',
    function: {
      name: ':TOOL_NAME:',
      description: ':TOOL_DESCRIPTION:',
      parameters: {
        type: 'object',
        properties: :TOOL_PARAMS:,
        required: [:REQUIRED_PARAM_NAMES:]
        additionalProperties: false
      }
    }
  }
};

export { apiTool };
""";

const LANGCHAIN_PYTHON_TOOL_FORMAT = """
from langchain.tools import StructuredTool

:INPUT_SCHEMA:

:FUNC:
	
api_tool = StructuredTool.from_function(
    func=func,
    name=":TOOL_NAME:",
    description=":TOOL_DESCRIPTION:",
    args_schema=INPUT_SCHEMA,
)
__all__ = ["api_tool"]
""";

const LANGCHAIN_JAVASCRIPT_TOOL_FORMAT = """
import { DynamicStructuredTool } from 'langchain/tools';
import { z } from 'zod';

:INPUT_SCHEMA:

:FUNC:

const apiTool = new DynamicStructuredTool({
  func: func,
  name: ':TOOL_NAME:',
  description: ':TOOL_DESCRIPTION:',
  schema: INPUT_SCHEMA
});

export { apiTool };
""";

const MICROSOFT_AUTOGEN_TOOL_FORMAT = """
:FUNC:

api_tool = {
    "function": func,
    "name": ":TOOL_NAME:",
    "description": ":TOOL_DESCRIPTION:"
}

__all__ = ["api_tool"]
""";

class APIToolGenTemplateSelector {
  static String getTemplate(String language, String agent) {
    if (language == 'PYTHON') {
      if (agent == 'MICROSOFT_AUTOGEN') {
        return MICROSOFT_AUTOGEN_TOOL_FORMAT;
      } else if (agent == 'LANGCHAIN') {
        return LANGCHAIN_PYTHON_TOOL_FORMAT;
      }
      return GENERAL_PYTHON_TOOL_FORMAT;
    } else if (language == 'JAVASCRIPT') {
      if (agent == 'LANGCHAIN') {
        return LANGCHAIN_JAVASCRIPT_TOOL_FORMAT;
      }
      return GENERAL_JAVASCRIPT_TOOL_FORMAT;
    }
    return 'NO_TEMPLATE';
  }
}
