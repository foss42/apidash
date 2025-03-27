import os
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import time, datetime
from datetime import datetime
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig
from datasets import load_dataset
import evaluate
load_dotenv()
app = FastAPI()
origins = [
    "http://localhost:8000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
dataset_path = os.getenv("DATASET_PATH")
@app.get("/dataset")
async def read_dataset(file: UploadFile = File(...)):
    with open(f"{dataset_path}/{file.filename}", "wb") as f:
        f.write(file.file.read())
    return {"filename": file.filename}

@app.get("/test")
async def read_root():
    return {"Hello": "World"}


cnn_dataset = load_dataset("cnn_dailymail", "3.0.0", split="train")

# Evaluation functions
def generate_text(prompt, model, tokenizer, max_tokens=300):
    inputs = tokenizer(prompt,return_tensors="pt", truncation=True, padding=True).to("cuda")
    with torch.no_grad():
        output = model.generate(**inputs, max_new_tokens=max_tokens, temperature=0.7)
    return tokenizer.decode(output[0], skip_special_tokens=True)

def evaluate_model(model_name):
    start_time = time.time()

    # Model Config
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_compute_dtype=torch.bfloat16,
        bnb_4bit_quant_type="nf4"
    )

    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        quantization_config=bnb_config,
        device_map="auto",
        token="" # put your hugginface token here
    )
    tokenizer.pad_token = tokenizer.eos_token
    # Evaluation Metrics
    bleu = evaluate.load("bleu")
    rouge = evaluate.load("rouge")
    meteor = evaluate.load("meteor")
    bertscore = evaluate.load("bertscore")

    predictions, references = [], []
    for sample in cnn_dataset.select(range(40)):  # Evaluate on a subset for speed
        print(f"Evaluating: {sample['article'][:50]}...")
        generated_text = generate_text(prompt=sample['article'],model=model,tokenizer=tokenizer)
        predictions.append(generated_text)
        references.append([sample['highlights']])

    # Compute Scores
    scores = {
        "BLEU-4": bleu.compute(predictions=predictions, references=references)["bleu"],
        "ROUGE-L": rouge.compute(predictions=predictions, references=references)["rougeL"],
        "BERTScore": sum(bertscore.compute(predictions=predictions, references=references, lang="en")["f1"]) / len(predictions),
        "METEOR": meteor.compute(predictions=predictions, references=references)["meteor"],
    }

    latency = (time.time() - start_time) * 1000
    cost = 0.0004  # Example fixed cost
    torch.cuda.empty_cache()
    
    return {
        "model_name": model_name,
        "scores": scores,
        "latency": latency,
        "cost": cost,
        "timestamp": datetime.now().isoformat() + "Z"
    }

@app.get("/evaluate/{model_name}")
def evaluate_api(model_name: str):
    valid_models = ['meta-llama/Llama-3.2-3B', 'tiiuae/falcon-7b']
    
    if model_name == "Llama-3.2-3B":
        model_name = valid_models[0]
    elif model_name == "falcon-7b":
        model_name = valid_models[1]
    else:
        raise HTTPException(status_code=404, detail="Model not found")
    result = evaluate_model(model_name)
    return [result]

@app.get("/evaluate1/{model_name}")
def evaluate_api(model_name: str):
    # model_name = model_name.replace("%2F", "/")
    valid_models = ['meta-llama/Llama-3.2-3B', 'mistralai/Mistral-7B', 'tiiuae/falcon-7b']
    
    if model_name == "Llama-3.2-3B":
        model_name = valid_models[0]
    
    # Mock response for testing
    mock_response = {
        "model_name": model_name,
        "scores": {
            "BLEU-4": 0.45,
            "ROUGE-L": 0.60,
            "BERTScore": 0.85,
            "METEOR": 0.40,
            "CIDEr": 0.55,
            "SPICE": 0.50,
        },
        "latency": 250,
        "cost": 0.25,
        "timestamp": "2023-11-15T12:00:00"
    }
    
    return [mock_response]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)