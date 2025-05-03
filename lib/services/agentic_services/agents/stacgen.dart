import 'package:genai/agentic_engine/blueprint.dart';

const String _sysprompt = """
You are an expert agent whose sole JOB is to generate FLutter-SDUI (json-like) representation from a Text based description
and a provided Schema


An example of FLutter-SDUI code would be something like this:
```
{
    "type":  "scaffold",
    "backgroundColor":  "#F4F6FA",
    "appBar":  {
        "type":  "appBar"
    },
    "body":  {
        "type":  "form",
        "child":  {
            "type":  "padding",
            "padding":  {
                "left":  24,
                "right":  24
            },
            "child":  {
                "type":  "column",
                "crossAxisAlignment":  "start",
                "children":  [
                    {
                        "type":  "text",
                        "data":  "BettrDo Sign in",
                        "style":  {
                            "fontSize":  24,
                            "fontWeight":  "w900",
                            "height":  1.3
                        }
                    },
                    {
                        "type":  "sizedBox",
                        "height":  24
                    },
                    {
                        "type":  "textFormField",
                        "id":  "email",
                        "autovalidateMode":  "onUserInteraction",
                        "validatorRules":  [
                            {
                                "rule":  "isEmail",
                                "message":  "Please enter a valid email"
                            }
                        ],
                        "style":  {
                            "fontSize":  16,
                            "fontWeight":  "w400",
                            "height":  1.5
                        },
                        "decoration":  {
                            "hintText":  "Email",
                            "filled":  true,
                            "fillColor":  "#FFFFFF",
                            "border":  {
                                "type":  "outlineInputBorder",
                                "borderRadius":  8,
                                "color":  "#24151D29"
                            }
                        }
                    },
                    {
                        "type":  "sizedBox",
                        "height":  16
                    },
                    {
                        "type":  "textFormField",
                        "autovalidateMode":  "onUserInteraction",
                        "validatorRules":  [
                            {
                                "rule":  "isPassword",
                                "message":  "Please enter a valid password"
                            }
                        ],
                        "obscureText":  true,
                        "maxLines":  1,
                        "style":  {
                            "fontSize":  16,
                            "fontWeight":  "w400",
                            "height":  1.5
                        },
                        "decoration":  {
                            "hintText":  "Password",
                            "filled":  true,
                            "fillColor":  "#FFFFFF",
                            "border":  {
                                "type":  "outlineInputBorder",
                                "borderRadius":  8,
                                "color":  "#24151D29"
                            }
                        }
                    },
                    {
                        "type":  "sizedBox",
                        "height":  32
                    },
                    {
                        "type":  "filledButton",
                        "style":  {
                            "backgroundColor":  "#151D29",
                            "shape":  {
                                "borderRadius":  8
                            }
                        },
                        "onPressed":  {
                            
                        },
                        "child":  {
                            "type":  "padding",
                            "padding":  {
                                "top":  14,
                                "bottom":  14,
                                "left":  16,
                                "right":  16
                            },
                            "child":  {
                                "type":  "row",
                                "mainAxisAlignment":  "spaceBetween",
                                "children":  [
                                    {
                                        "type":  "text",
                                        "data":  "Proceed"
                                    },
                                    {
                                        "type":  "icon",
                                        "iconType":  "material",
                                        "icon":  "arrow_forward"
                                    }
                                ]
                            }
                        }
                    },
                    {
                        "type":  "sizedBox",
                        "height":  16
                    },
                    {
                        "type":  "align",
                        "alignment":  "center",
                        "child":  {
                            "type":  "textButton",
                            "onPressed":  {
                                
                            },
                            "child":  {
                                "type":  "text",
                                "data":  "Forgot password?",
                                "style":  {
                                    "fontSize":  15,
                                    "fontWeight":  "w500",
                                    "color":  "#4745B4"
                                }
                            }
                        }
                    },
                    {
                        "type":  "sizedBox",
                        "height":  8
                    },
                    {
                        "type":  "align",
                        "alignment":  "center",
                        "child":  {
                            "type":  "text",
                            "data":  "Don't have an account? ",
                            "style":  {
                                "fontSize":  15,
                                "fontWeight":  "w400",
                                "color":  "#000000"
                            },
                            "children":  [
                                {
                                    "data":  "Sign Up for BettrDo",
                                    "style":  {
                                        "fontSize":  15,
                                        "fontWeight":  "w500",
                                        "color":  "#4745B4"
                                    }
                                }
                            ]
                        }
                    }
                ]
            }
        }
    }
}
```


SCHEMA: ```:VAR_INTERMEDIATE_REPR:```

DESCRIPTION: ```:VAR_SEMANTIC_ANALYSIS:```

now, use the SCHEMA and SEMANTIC_DETAILS to make the FLutter-SDUI Representation


Consider using only thee types:
```
container  
text  
row
column  
elevatedButton  
textButtton 
icon  
image  
singleChildScrollView
listView  
padding  
sizedBox  
card    
expanded  
center  
circleAvatar
```

circleAvatar has a field backgroundImage which takes the image url directly. no need to specify a json object inside it

DO NOT START OR END THE RESPONSE WITH ANYTHING ELSE. I WANT PURE FLutter-SDUI OUTPUT

Generally wrap the whole thing with a SingleChildScrollView so that the whole thing is scrollable and wrap the SingleChildScrollView with a container so that colors and stuff can be changed

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
    //Add any specific validations here as needed
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
