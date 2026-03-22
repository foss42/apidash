import { useState } from 'react';
import ConfigPanel from './components/ConfigPanel';
import LogStream from './components/LogStream';
import Results from './components/Results';
import { startEvaluation, type EvalConfig, type EvalResults } from './lib/api';

function App() {
  const [runId, setRunId] = useState<string | null>(null);
  const [isRunning, setIsRunning] = useState(false);
  const [logs, setLogs] = useState<string[]>([]);
  const [results, setResults] = useState<EvalResults | null>(null);

  const handleRun = async (config: EvalConfig) => {
    setIsRunning(true);
    setLogs([]);
    setResults(null);
    try {
      const data = await startEvaluation(config);
      setRunId(data.run_id);
    } catch (error) {
      console.error("Failed to start:", error);
      setIsRunning(false);
    }
  };

  const handleEvalComplete = (finalResults: EvalResults) => {
    setResults(finalResults);
    setIsRunning(false);
  };
  return (
    <div className="min-h-screen bg-gray-50 p-8 text-gray-900">
      <div className="max-w-5xl mx-auto space-y-6">
        <header>
          <h1 className="text-3xl font-bold">API Dash Eval PoC</h1>
          <p className="text-gray-500">Local-first llm-harness evaluation</p>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="col-span-1">
            <ConfigPanel onRun={handleRun} isRunning={isRunning} />
          </div>
          
          <div className="col-span-1 md:col-span-2 space-y-6">
            <LogStream 
              runId={runId} 
              logs={logs} 
              setLogs={setLogs} 
              onComplete={handleEvalComplete} 
            />
            
            {results && <Results data={results} />}
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;