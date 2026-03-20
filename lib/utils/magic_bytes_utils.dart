import 'dart:typed_data';

(String, String) detectMimeTypeFromBytes(Uint8List bytes) {
  if (bytes.length < 4) return ('application', 'octet-stream');

  // PNG: 89 50 4E 47
  if (bytes[0] == 0x89 && bytes[1] == 0x50 &&
      bytes[2] == 0x4E && bytes[3] == 0x47) return ('image', 'png');

  // JPEG: FF D8 FF
  if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF)
    return ('image', 'jpeg');

  // GIF: 47 49 46 38
  if (bytes[0] == 0x47 && bytes[1] == 0x49 &&
      bytes[2] == 0x46 && bytes[3] == 0x38) return ('image', 'gif');

  // BMP: 42 4D
  if (bytes[0] == 0x42 && bytes[1] == 0x4D) return ('image', 'bmp');

  // WebP: RIFF....WEBP
  if (bytes.length >= 12 &&
      bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
      bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50)
    return ('image', 'webp');

  // PDF: 25 50 44 46 (%PDF)
  if (bytes[0] == 0x25 && bytes[1] == 0x50 &&
      bytes[2] == 0x44 && bytes[3] == 0x46) return ('application', 'pdf');

  // MP3: FF FB or ID3
  if ((bytes[0] == 0xFF && (bytes[1] == 0xFB || bytes[1] == 0xF3)) ||
      (bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33))
    return ('audio', 'mpeg');

  // WAV: RIFF....WAVE
  if (bytes.length >= 12 &&
      bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
      bytes[8] == 0x57 && bytes[9] == 0x41 && bytes[10] == 0x56 && bytes[11] == 0x45)
    return ('audio', 'wav');

  // MP4: ftyp at offset 4
  if (bytes.length >= 8 &&
      bytes[4] == 0x66 && bytes[5] == 0x74 &&
      bytes[6] == 0x79 && bytes[7] == 0x70) return ('video', 'mp4');

  return ('application', 'octet-stream');
}