# AI API Evaluation Framework - Proof of Concept
This is Proof of Concept (PoC) for AI API evaluation on a structured framework. It benchmarks AI language models against various performance metrics and provides actionable insights by means of easy-to-interpret visualizations. The PoC involves end-to-end integration from API calls to result analysis.

## Objectives

Benchmark the AI models (Falcon 7B, LLaMA 3.2) against others such as BLEU-4, ROUGE-L, BERTScore, METEOR.

Use radar charts to provide a visual comparison.

Facilitate effective monitoring of model performance by real-time latency and cost measurement.

---
##  Key Features Implemented
Backend (FastAPI)
Model Evaluation Endpoint: Tests AI models against given data sets.

Scores such as BLEU-4, ROUGE-L, BERTScore, and METEOR are computed from Hugging Face models.

Real-Time Performance Metrics: Tracks latency, cost, and processing time.

Frontend (Flutter)
Interactive Dashboard: Displays model scores in radar charts.

Real-Time Data Display: Presents results of evaluation in a formatted way.

Model Selection: Enables users to select from amongst available AI models.

## Screenshots and Visuals
![alt text](<Screenshot 2025-03-26 211623.png>)

![alt text](image.png)

![alt text](<Screenshot 2025-03-26 214413.png>)

![alt text](<Screenshot 2025-03-26 214424.png>)

---
##  Proof of Concept Details
Models Evaluated: LLaMA 3.2 (3B) and Falcon 7B.

Dataset: CNN Dailymail (3.0.0) used for benchmarking assessment.

Evaluation Metrics

BLEU-4: Scores n-gram overlap.

ROUGE-L: Checks the longest consecutive matches.

BERTScore: Scores contextual embeddings.

METEOR: Considers synonyms, stemming, and grammar.

