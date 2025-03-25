import argparse
import json
import shutil
import subprocess
from pathlib import Path

def main():
    cmd = argparse.ArgumentParser()
    cmd.add_argument("--model", required=True)
    cmd.add_argument("--base_url", required=True)
    cmd.add_argument("--api_key", required=True)
    cmd.add_argument("--limit", type=int, default=20)
    args = cmd.parse_args()

    file_dir = Path(__file__).resolve().parent

    lm_eval_path = (file_dir / "venv/bin/lm_eval").resolve()

    res_folder = Path("results")
    if res_folder.exists() and res_folder.is_dir():
        shutil.rmtree(res_folder)

    model_args = f"model={args.model},base_url={args.base_url},api_key={args.api_key}"
    cmd = [
        str(lm_eval_path),
        "--model", "apidash",
        "--tasks", "hellaswag",
        "--device", "cuda:0",
        "--batch_size", "1",
        "--limit", str(args.limit),
        "--model_args", model_args,
        "--output", "results",
    ]

    output = subprocess.run(cmd, capture_output=True, text=True)
    model_folder = Path("results") / args.model
    json_loc = list(model_folder.glob("*.json"))

    if output.returncode == 0 and model_folder.exists() and json_loc:
        with open(json_loc[0], "r") as f:
            data = json.load(f)
    else:
        print("error in script")

    acc = data.get("results", {}).get("hellaswag", {}).get("acc,none", None)
    
    print(json.dumps({"acc": acc}))

if __name__ == "__main__":
    main()
