import { useState } from 'react';
import type { EvalConfig } from '../lib/api';

interface Props {
  onRun: (config: EvalConfig) => void;
  isRunning: boolean;
}

export default function ConfigPanel({ onRun, isRunning }: Props) {
  const [apiKey, setApiKey] = useState('');
  const [model, setModel] = useState('llama-3.3-70b-versatile');
  const [task, setTask] = useState('gsm8k');
  const [limit, setLimit] = useState(5);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!apiKey) return alert("API Key is required");
    onRun({ api_key: apiKey, model, task, limit });
  };

  return (
    <div className="p-6 border border-gray-200 rounded-xl bg-white shadow-sm">
      <h2 className="text-xl font-bold text-gray-800 mb-4">Configuration</h2>
      
      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <label className="flex flex-col text-sm font-semibold text-gray-700">
          API Key:
          <input 
            type="password" 
            value={apiKey} 
            onChange={e => setApiKey(e.target.value)} 
            placeholder="AIzaSy..."
            disabled={isRunning}
            className="mt-1 p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 outline-none disabled:bg-gray-100 disabled:text-gray-400"
          />
        </label>

        <label className="flex flex-col text-sm font-semibold text-gray-700">
          Model:
          <input 
            type="text" 
            value={model} 
            onChange={e => setModel(e.target.value)} 
            disabled={isRunning}
            className="mt-1 p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 outline-none disabled:bg-gray-100"
          />
        </label>

        <label className="flex flex-col text-sm font-semibold text-gray-700">
          Task (lm-eval):
          <input 
            type="text" 
            value={task} 
            onChange={e => setTask(e.target.value)} 
            disabled={isRunning}
            className="mt-1 p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 outline-none disabled:bg-gray-100"
          />
        </label>

        <label className="flex flex-col text-sm font-semibold text-gray-700">
          Sample Limit (Questions):
          <input 
            type="number" 
            min="1"
            value={limit} 
            onChange={e => setLimit(Number(e.target.value))} 
            disabled={isRunning}
            className="mt-1 p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 outline-none disabled:bg-gray-100"
          />
        </label>

        <button 
          type="submit" 
          disabled={isRunning}
          className={`mt-2 p-2.5 rounded-md font-bold text-white transition-colors ${
            isRunning 
              ? 'bg-gray-400 cursor-not-allowed' 
              : 'bg-blue-600 hover:bg-blue-700 active:bg-blue-800 cursor-pointer'
          }`}
        >
          {isRunning ? 'Evaluation Running...' : 'Run Evaluation'}
        </button>
      </form>
    </div>
  );
}