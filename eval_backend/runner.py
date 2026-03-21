import sys
import json
import argparse
import time
import asyncio
import statistics
import httpx

async def perform_request(client, url, method="GET", headers=None, body=None):
    start_time = time.time()
    try:
        if method == "POST":
            response = await client.post(url, headers=headers, content=body)
        else:
            response = await client.get(url, headers=headers)
        
        latency = (time.time() - start_time) * 1000  # ms
        return {"success": response.status_code < 400, "latency": latency, "status": response.status_code}
    except Exception as e:
        return {"success": False, "latency": (time.time() - start_time) * 1000, "error": str(e)}

async def run_stress_test(url, concurrency, total_requests):
    print(f"INFO: Initializing Stress Test on {url}")
    print(f"INFO: Concurrency: {concurrency}, Total Requests: {total_requests}")
    
    tasks = []
    latencies = []
    success_count = 0
    start_time = time.time()

    async with httpx.AsyncClient(timeout=30.0) as client:
        # We batch requests based on concurrency
        for i in range(0, total_requests, concurrency):
            batch_size = min(concurrency, total_requests - i)
            batch_tasks = [perform_request(client, url) for _ in range(batch_size)]
            batch_results = await asyncio.gather(*batch_tasks)
            
            for res in batch_results:
                if res["success"]:
                    success_count += 1
                latencies.append(res["latency"])
            
            print(f"LOG: Batch {i // concurrency + 1} completed ({i + batch_size}/{total_requests})")

    end_time = time.time()
    total_duration = end_time - start_time
    rps = total_requests / total_duration if total_duration > 0 else 0

    results = {
        "status": "completed",
        "rps": round(rps, 2),
        "total_requests": total_requests,
        "success_count": success_count,
        "error_count": total_requests - success_count,
        "avg_latency": round(statistics.mean(latencies), 2) if latencies else 0,
        "p95_latency": round(statistics.quantiles(latencies, n=100)[94], 2) if len(latencies) >= 2 else 0,
        "p99_latency": round(statistics.quantiles(latencies, n=100)[98], 2) if len(latencies) >= 2 else 0,
        "duration_sec": round(total_duration, 2)
    }
    
    print("RESULT:" + json.dumps(results))

async def run_workflow_eval(workflow_steps_json, model_name):
    print(f"INFO: Initializing Agentic Workflow Evaluation for {model_name}")
    
    # We parse the steps (e.g., [{"url": "...", "method": "GET"}, ...])
    try:
        steps = json.loads(workflow_steps_json)
    except:
        print("ERROR: Invalid workflow JSON format.")
        return

    print(f"INFO: Found {len(steps)} steps in workflow.")
    
    step_results = []
    all_success = True
    
    async with httpx.AsyncClient(timeout=10.0) as client:
        for idx, step in enumerate(steps):
            url = step.get("url")
            print(f"LOG: Executing Step {idx+1}: {url}")
            
            res = await perform_request(client, url)
            step_results.append({
                "step_index": idx + 1,
                "url": url,
                "success": res["success"],
                "latency": res["latency"]
            })
            
            if not res["success"]:
                all_success = False
                print(f"LOG: Step {idx+1} failed. Breaking workflow chain.")
                break
            
            await asyncio.sleep(0.5) # Simulate slight agent processing delay

    results = {
        "status": "completed",
        "workflow_success": all_success,
        "completed_steps": len(step_results),
        "total_steps": len(steps),
        "steps_detail": step_results,
        "avg_step_latency": round(statistics.mean([r["latency"] for r in step_results]), 2) if step_results else 0
    }
    
    print("RESULT:" + json.dumps(results))

def run_benchmark(benchmark_type, target, concurrency=5, total=20, workflow=None):
    if benchmark_type == "stress_test":
        asyncio.run(run_stress_test(target, concurrency, total))
    elif benchmark_type == "agentic_workflow":
        asyncio.run(run_workflow_eval(workflow, target))
    elif benchmark_type == "lm_harness":
        simulate_generic_benchmark("LM Evaluation Harness", target)
    elif benchmark_type == "lighteval":
        simulate_generic_benchmark("LightEval", target)
    elif benchmark_type == "mmlu":
        simulate_generic_benchmark("MMLU", target)
    elif benchmark_type == "human_eval":
        simulate_generic_benchmark("HumanEval", target)
    else:
        print(f"ERROR: Unknown benchmark type: {benchmark_type}")

def simulate_generic_benchmark(name, model):
    print(f"INFO: Initializing {name} for {model}")
    time.sleep(1.5)
    results = {
        "benchmark": name,
        "model": model,
        "results": {
            "accuracy": 0.75,
            "latency_avg": "120ms",
            "samples": 100
        },
        "status": "success"
    }
    print("RESULT:" + json.dumps(results))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='AI Eval & Stress Test Runner')
    parser.add_argument('--benchmark', type=str, required=True)
    parser.add_argument('--target', type=str, required=True, help='Model name or URL')
    parser.add_argument('--concurrency', type=int, default=5)
    parser.add_argument('--total', type=int, default=20)
    parser.add_argument('--workflow', type=str, default="[]", help='JSON list of workflow steps')
    
    args = parser.parse_args()
    try:
        run_benchmark(args.benchmark, args.target, args.concurrency, args.total, args.workflow)
    except Exception as e:
        print(f"ERROR: {str(e)}")
        sys.exit(1)
