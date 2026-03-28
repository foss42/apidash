import { useState } from "react";

interface ImagePreviewProps {
  src: string;
  alt?: string;
  className?: string;
}

export default function ImagePreview({ src, alt = "Preview", className = "" }: ImagePreviewProps) {
  const [zoomed, setZoomed] = useState(false);

  return (
    <>
      <img
        src={src}
        alt={alt}
        onClick={() => setZoomed(true)}
        className={`cursor-zoom-in rounded border border-gray-700 object-cover transition hover:border-gray-500 ${className}`}
      />

      {zoomed && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 p-8"
          onClick={() => setZoomed(false)}
        >
          <img
            src={src}
            alt={alt}
            className="max-h-[90vh] max-w-[90vw] rounded-lg shadow-2xl"
          />
          <button
            onClick={() => setZoomed(false)}
            className="absolute right-6 top-6 rounded-full bg-gray-800 px-3 py-1 text-sm text-white hover:bg-gray-700"
          >
            Close
          </button>
        </div>
      )}
    </>
  );
}
