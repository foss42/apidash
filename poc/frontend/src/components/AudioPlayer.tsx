interface AudioPlayerProps {
  src: string;
  label?: string;
}

export default function AudioPlayer({ src, label }: AudioPlayerProps) {
  return (
    <div className="rounded border border-gray-700 bg-gray-800 p-3">
      {label && (
        <p className="mb-2 text-xs font-medium text-gray-400">{label}</p>
      )}
      <audio controls className="w-full" preload="metadata">
        <source src={src} />
        Your browser does not support audio playback.
      </audio>
    </div>
  );
}
