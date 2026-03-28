export interface PresetModel {
  providerId: string;
  modelId: string;
  requiresAuth: boolean;
}

export interface Preset {
  id: string;
  name: string;
  description: string;
  emoji: string;
  modality: 'text' | 'image' | 'audio' | 'code';
  tasks: string[];
  cloudModel: PresetModel;
  localModel?: PresetModel;
  sampleCount: number;
}

export interface PresetResponse {
  presets: Preset[];
}