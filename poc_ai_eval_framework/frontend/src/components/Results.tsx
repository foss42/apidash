import type { EvalResults } from '../lib/api';

interface Props {
  data: EvalResults;
}

export default function Results({ data }: Props) {
  return (
    <div className="p-6 border border-gray-200 rounded-xl bg-white shadow-sm mt-6">
      <h2 className="text-xl font-bold text-gray-800 mb-6 flex items-center gap-2">
        <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        Evaluation Complete
      </h2>
      
      <div className="grid grid-cols-1 gap-6">
        {Object.entries(data).map(([taskName, metrics]) => (
          <div key={taskName} className="border border-gray-100 rounded-lg p-5 bg-gray-50 shadow-inner">
            <h3 className="text-lg font-bold text-blue-900 mb-4 uppercase tracking-wide">{taskName}</h3>
            
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
              {Object.entries(metrics).map(([metricName, value]) => (
                <div key={metricName} className="bg-white p-4 rounded-md border border-gray-200 shadow-sm flex flex-col justify-between">
                  <span 
                    className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 break-words" 
                    title={metricName}
                  >
                    {metricName}
                  </span>
                  <span className="text-2xl font-bold text-gray-900">
                    {typeof value === 'number' ? value.toFixed(4) : value}
                  </span>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}