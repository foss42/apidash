#!/bin/bash

echo "==================================================="
echo "     Booting API Dash Eval PoC (Mac/Linux)"
echo "==================================================="
echo "NOTE: First run will take 2-5 minutes to install dependencies."

# Catch Ctrl+C to cleanly kill both background processes
trap 'echo "Shutting down servers..."; kill $BACKEND_PID $FRONTEND_PID; exit' INT

echo "[1/2] Checking and starting FastAPI Backend..."
cd backend
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install fastapi uvicorn httpx lm-eval[api]
else
    source venv/bin/activate
fi
uvicorn main:app --reload > /dev/null 2>&1 &
BACKEND_PID=$!
cd ..

echo "[2/2] Checking and starting Vite Frontend..."
cd frontend
if [ ! -d "node_modules" ]; then
    echo "Installing NPM modules..."
    npm install
fi
npm run dev > /dev/null 2>&1 &
FRONTEND_PID=$!
cd ..

echo ""
echo "✅ Both servers are running!"
echo "➡️ Open http://localhost:5173 in your browser."
echo "🛑 Press Ctrl+C in this terminal to stop both servers."

# Wait indefinitely so the script doesn't exit until Ctrl+C is pressed
wait