
export type EvalResults = Record<string, Record<string, number | string>>;

export interface EvalConfig {
  model: string;
  api_key: string;
  task: string;
  limit: number;
}

export const startEvaluation = async (config: EvalConfig): Promise<{ run_id: string }> => {
  const response = await fetch('http://localhost:8000/api/evaluate', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(config),
  });

  if (!response.ok) {
    throw new Error('Failed to start evaluation');
  }

  return response.json();
};