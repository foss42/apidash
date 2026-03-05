const kGeneralArgPropertyFormatPy = """:ARG_NAME: {
  "type": ":ARG_TYPE:",
  "description: ":ARG_DESC:"
}""";

const kGeneralPythonToolFormat = """
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

const kGeneralJavascriptToolFormat = """
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

const kLangchainPythonToolFormat = """
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

const kLangchainJavascriptToolFormat = """
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

const kMicrosoftAutogenToolFormat = """
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
        return kMicrosoftAutogenToolFormat;
      } else if (agent == 'LANGCHAIN') {
        return kLangchainPythonToolFormat;
      }
      return kGeneralPythonToolFormat;
    } else if (language == 'JAVASCRIPT') {
      if (agent == 'LANGCHAIN') {
        return kLangchainJavascriptToolFormat;
      }
      return kGeneralJavascriptToolFormat;
    }
    return 'NO_TEMPLATE';
  }
}
