@echo off
echo ===================================================
echo     Booting API Dash Eval PoC (Windows)
echo ===================================================

echo [1/2] Checking and starting FastAPI Backend...
start "API Dash Backend" cmd /k "cd backend && if not exist venv (echo Creating venv... && python -m venv venv && call venv\Scripts\activate && pip install -r requirements.txt) else (call venv\Scripts\activate) && echo Starting Uvicorn... && uvicorn main:app --reload"

echo [2/2] Checking and starting Vite Frontend...
start "API Dash Frontend" cmd /k "cd frontend && if not exist node_modules (echo Installing NPM modules... && npm install) && echo Starting Vite... && npm run dev"

echo.
echo Both servers are booting in separate windows! 
echo Open http://localhost:5173 in your browser.
echo Close the new command windows to stop the servers.