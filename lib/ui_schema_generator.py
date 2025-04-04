import json

def analyze_json_to_ui_schema(json_data):
    if isinstance(json_data, str):
        json_data = json.loads(json_data)

    if isinstance(json_data, list) and json_data and isinstance(json_data[0], dict):
        fields = json_data[0].keys()
        ui_schema = {
            "layout": "table",
            "columns": []
        }

        for field in fields:
            values = [item.get(field) for item in json_data if field in item]
            unique_values = set(values)
            ui_type = "text"

            if all(isinstance(v, bool) for v in values):
                ui_type = "toggle"
            elif all(isinstance(v, (int, float)) for v in values):
                if len(unique_values) < 10:
                    ui_type = "dropdown"
                else:
                    ui_type = "chart"
            elif len(unique_values) <= 5:
                ui_type = "dropdown"

            ui_schema["columns"].append({
                "field": field,
                "type": ui_type,
                "sample": values[:3]
            })

        return ui_schema

    elif isinstance(json_data, dict):
        return {
            "layout": "card",
            "fields": [
                {"field": k, "type": "text", "value_type": type(v).__name__}
                for k, v in json_data.items()
            ]
        }

    else:
        return {"layout": "text", "message": "Unsupported format"}


if __name__ == "__main__":
    mock_json = [
        {"name": "Alice", "age": 30, "active": True, "status": "pending"},
        {"name": "Bob", "age": 28, "active": False, "status": "approved"},
        {"name": "Charlie", "age": 35, "active": True, "status": "pending"}
    ]

    schema = analyze_json_to_ui_schema(mock_json)
    print(json.dumps(schema, indent=2))
