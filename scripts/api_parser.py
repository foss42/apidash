import json

def parse_openapi(file_path):
    with open(file_path, 'r') as f:
        data = json.load(f)

    endpoints = []

    paths = data.get("paths", {})
    for path, methods in paths.items():
        for method, details in methods.items():
            endpoints.append({
                "path": path,
                "method": method.upper(),
                "summary": details.get("summary", "")
            })

    return endpoints


if __name__ == "__main__":
    file_path = "scripts/sample_openapi.json"
    endpoints = parse_openapi(file_path)

    for ep in endpoints:
        print(f"{ep['method']} {ep['path']} - {ep['summary']}")