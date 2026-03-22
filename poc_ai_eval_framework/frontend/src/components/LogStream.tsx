import { useEffect, useRef } from 'react';
import type { EvalResults } from '../lib/api'; 

interface Props {
  runId: string | null;
  logs: string[];
  setLogs: React.Dispatch<React.SetStateAction<string[]>>;
  onComplete: (results: EvalResults) => void; // <-- Replaced 'any'
}

export default function LogStream({ runId, logs, setLogs, onComplete }: Props) {
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [logs]);

  useEffect(() => {
    if (!runId) return;

    const eventSource = new EventSource(`http://localhost:8000/api/stream/${runId}`);

    eventSource.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.log) setLogs(prev => [...prev, data.log]);
      else if (data.done) {
        onComplete(data.results);
        eventSource.close();
      } 
      else if (data.error) {
        setLogs(prev => [...prev, `[ERROR] ${data.error}`]);
        eventSource.close();
      }
    };

    eventSource.onerror = () => eventSource.close();
    return () => eventSource.close();
  }, [runId, setLogs, onComplete]);

  return (
    <div className="p-6 border border-gray-800 rounded-xl bg-gray-900 shadow-lg">
      <div className="flex items-center gap-2 mb-4">
        <div className="w-3 h-3 rounded-full bg-red-500"></div>
        <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
        <div className="w-3 h-3 rounded-full bg-green-500"></div>
        <h2 className="text-sm font-semibold text-gray-400 ml-2 font-mono">live-terminal-logs</h2>
      </div>
      
      <div 
        ref={scrollRef}
        className="h-[300px] overflow-y-auto font-mono text-sm text-gray-300 whitespace-pre-wrap leading-relaxed custom-scrollbar"
      >
        {logs.length === 0 && <span className="text-gray-600 italic">Waiting for evaluation to start...</span>}
        {logs.map((log, index) => (
          <div key={index} className="mb-1">{log}</div>
        ))}
      </div>
    </div>
  );
}