# GSoC Proposal for AI API Evalution


## About

1. **Full Name:** Harsh Panchal
2. **Email:** harsh.panchal.0910@gmail.com
3. **Phone number:** +91-9925095794
4. **Discord Handle:** panchalharsh
5. **Home Page:** [harshpanchal0910.netlify.app](https://harshpanchal0910.netlify.app/)
6. **GitHub:** [GANGSTER0910](https://github.com/GANGSTER0910)
7. **LinkedIn:** [Harsh Panchal](https://www.linkedin.com/in/harsh-panchal-902636255)
8. **Time Zone:** IST (UTC +5:30)
9. **Resume:** [Link to Resume](https://drive.google.com/drive/folders/1iDp0EnksaVXV3MmWd_uhGoprAuFzyqwB)


## University Information

1. **University Name:** Ahmedabad University, Ahmedabad
2. **Program:** BTech in Computer Science and Engineering
3. **Year:** 3rd Year
4. **Expected Graduation Date:** May 2026


## Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before?**
   - Yes I have once contributed to the foss/api in GSSOC 2024 
   - [Contribution](https://github.com/foss42/api/pull/69) - Added a put API.

2. **What is your one project/achievement that you are most proud of? Why?**
   - One project I'm really proud of is TrippoBot, an AI-powered travel assistance chatbot I built with my team. It helps users with personalized travel recommendations, booking assistance, and real-time insights. Developing it was both challenging and rewarding — we had to integrate AI for natural language understanding, ensure smooth API interactions, and fine-tune the bot for accurate responses.

   - What made it even more special was winning 2nd place at the TicTechToe Hackathon. Competing against talented teams and seeing our hard work recognized was an amazing feeling. It not only boosted my confidence but also sharpened my problem-solving skills and showed me the real-world impact of AI applications. Looking back, it's a reminder of how much I enjoy tackling complex problems and turning ideas into practical solutions.
3. **What kind of problems or challenges motivate you the most to solve them?**
   - I am most inspired to solve complicated challenges that need me to think in new ways and stretch my limits.  I appreciate tackling new challenges because they allow me to learn, discover innovative solutions, and gain a better understanding of developing technologies.  The AI API Evaluation project interests me since it entails examining several AI models, determining their strengths and limitations, and employing rigorous evaluation procedures.  The potential of breaking down complex model behaviors, evaluating performance indicators, and gaining actionable insights is very appealing.  I am motivated by the challenge of developing solutions that help progress AI assessment frameworks, resulting in more transparent and dependable AI applications.

4. **Will you be working on GSoC full-time?**
   - Yes, I will be working full-time on my GSoC project.

5. **Do you mind regularly syncing up with the project mentors?**
   - Not at all, I am comfortable with regular mentor interactions to ensure aligned development.

6. **What interests you the most about API Dash?**
   - API Dash is like your go-to toolkit for working with APIs. It makes testing, debugging, and evaluating APIs a breeze with its user-friendly interface. You can easily compare API responses in real-time and even assess how different AI models perform. It’s designed to take the guesswork out of API management, helping you make smarter decisions and build stronger applications. Think of it as having an extra pair of hands to simplify your API tasks!

7. **Can you mention some areas where the project can be improved?**
   - Enhanced Evaluation Framework – Add a robust AI model evaluation system for benchmarking across industry tasks.

   - Customizable Evaluation Criteria – Allow users to define metrics like fairness, robustness, and interpretability.

   - Support for Offline Datasets & Models – Provide options to upload and evaluate local models and datasets.

   - Interactive Visualizations – Improve API performance insights with comparative graphs and trend analysis.


## Project Proposal Information

### Proposal Title

**AI API Evaluation Framework**

### Abstract

This project aims to develop an end-to-end AI API evaluation framework integrated into API Dash. It will provide a user-friendly interface for configuring API requests, supporting both online and offline evaluations. Online evaluations will call APIs of server-hosted models, while offline evaluations will use LoRA adapters with 4-bit quantized models for efficient storage and minimal accuracy loss. The framework will also support custom datasets, evaluation criteria, and visual result analysis through charts and tables, making AI model assessment more accessible and effective.


## Detailed Description
This project integrates an AI API evaluation framework into API Dash to assess models across text, images, audio, and video. It supports both online (API-based) and offline (LoRA adapters with 4-bit models) evaluations. Users can upload datasets, customize metrics, and visualize results through charts. Explainability features using SHAP and LIME provide insights into model decisions. The framework also tracks performance metrics and generates detailed reports for easy comparison and analysis.

## Screenshots 
![Screenshot 1](https://github.com/GANGSTER0910/apidash/blob/eb49dfc93538a8e08653b9a89d87e5d4a510b24f/doc/proposals/2025/gsoc/images/AI_API_EVAL_Dashboard_1.png)

![Screenshot 2](https://github.com/GANGSTER0910/apidash/blob/eb49dfc93538a8e08653b9a89d87e5d4a510b24f/doc/proposals/2025/gsoc/images/AI_API_EVAL_Dashboard_2.png)

![Screenshot 3](https://github.com/GANGSTER0910/apidash/blob/eb49dfc93538a8e08653b9a89d87e5d4a510b24f/doc/proposals/2025/gsoc/images/AI_API_EVAL_result.png)



### Features to be Implemented

1. **AI Model Evaluation**
    - Evaluate AI models across multiple media types, including **text**, **images**, **audio**, and **video**.
    - Support offline evaluation using **LoRA adapters** with quantized models for efficient storage.
    - Provide user-selected metrics for benchmarking, including:
      - **BLEU-4** (for text)
      - **ROUGE-L** (for text)
      - **BERTScore** (for text)
      - **METEOR** (for text)
      - **PSNR** (for images and video)
      - **SSIM** (for images and video)
      - **CLIP Score** (for images)
      - **WER** (for audio)
    - Visualize score comparisons using **radar charts** for intuitive analysis.

2. **Custom Dataset Evaluation**
    - - Allow users to upload their own datasets for evaluation.
    - Provide access to pre-defined industry-standard benchmark datasets.
    - Support various data types including text, images, and multimedia.
    - Provide option to user to select the evalution metrics for it's own choice

3. **Custom Benchmark Metrics**
    - Users can customize their evaluation by choosing preferred evaluation metrics.
    - Offer flexibility to integrate additional metrics in the future.

4. **Explainability Integration**
   - Implement SHAP (SHapley Additive Explanations) to analyze feature importance and understand model decisions globally.

   - Integrate LIME (Local Interpretable Model-Agnostic Explanations) for localized interpretability of individual predictions.

   - Provide feature importance charts to show which inputs contributed most to the model's output.

   - Use decision boundary plots to visualize how the model classifies different inputs.

   - Implement heatmaps for images to highlight the regions that influenced predictions.

   - Ensure transparency by helping users understand why a model made a certain decision.

5. **Real-Time Performance Monitoring**
    - Track latency, memory usage, and API response times.

6. **Reporting and Export**
    - Generate detailed reports in PDF or CSV.
    - Provide comparison summaries for different models.

### Tools and Tech Stack
- **Backend:** FastAPI (Python)
- **Frontend:** Flutter (Dart)
- **ML Libraries:** Hugging Face Transformers, Evaluate
- **Visualization:** Matplotlib, Plotly
- **Explainability:** SHAP, LIME
- **Database:** MongoDB


## Week Project Timeline  

### Week 1-2: Community Bonding and Planning  
- Engage with mentors and the community to understand project expectations.  
- Finalize project requirements and milestones.  
- Set up development environment (FastAPI, Flutter, MongoDB).  
- Research evaluation metrics and LoRA adapters for offline evaluation.  
- Design database schema and API endpoints.  


### Week 3: Initial API Evaluation Setup  
- Implement API integration for online model evaluation.  
- Develop backend routes using FastAPI.  
- Establish connection with server-hosted models for API evaluation.  


### Week 4: Offline Model Evaluation  
- Implement offline model evaluation using LoRA adapters with 4-bit quantized models.  
- Test model loading and performance in offline mode.  
- Ensure accuracy is maintained within an acceptable range.  


### Week 5: Media Type Support and Metrics Integration  
- Implement support for different media types: **text, images, audio, and video**.  
- Integrate benchmarking using metrics like BLEU-4, ROUGE-L, CLIP Score, PSNR, and WER.  
- Develop functions to compute and compare model performance.  


### Week 6: Custom Dataset and Metric Selection  
- Implement dataset upload functionality.  
- Provide options for users to select pre-defined benchmark datasets.  
- Enable users to customize their evaluation by choosing preferred metrics.  


### Week 7: Explainability Integration - SHAP and LIME  
- Implement SHAP for global interpretability and LIME for local interpretability.  
- Generate feature importance scores and visual explanations.  
- Develop feature importance charts, decision boundary plots, and heatmaps.  


### Week 8: Real-Time Monitoring  
- Implement API to monitor latency, memory usage, and response time.  
- Build a backend system to collect and store performance data.  
- Display real-time monitoring results on the frontend.  


### Week 9: Reporting and Export  
- Develop a reporting module to generate detailed reports in PDF and CSV formats.  
- Provide performance summaries and evaluation comparisons.  
- Ensure clear and professional report formatting.  


### Week 10: Frontend Development  
- Build an intuitive Flutter-based UI for API Dash.  
- Design forms for API configuration and dataset selection.  
- Implement dynamic result visualization using radar charts, graphs, and tables.  


### Week 11: Testing and Optimization  
- Conduct unit tests and integration tests across all modules.  
- Perform end-to-end testing to ensure smooth API interactions.  
- Optimize code for efficiency and reliability.  
- Fix bugs and address feedback.  


### Week 12: Documentation and Final Submission  
- Write detailed user and developer documentation.  
- Provide setup and usage instructions.  
- Create demo videos and presentations.  
- Deploy the application using FastAPI and Flutter.  
- Submit the final project and gather feedback.  


## Conclusion
This AI API Evaluation Framework will simplify model evaluation for developers, researchers, and organizations. By providing explainability, real-time metrics, customizable benchmarking, and comprehensive reporting, it will ensure efficient AI model assessment and decision-making.

