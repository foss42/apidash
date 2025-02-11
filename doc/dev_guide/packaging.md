# Packaging API Dash

## Windows

[Packaging and Distributing Flutter Desktop Apps : Creating Windows .exe installer](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-for-open-source-indie-0b468d5e9e70)

## macOS

[Packaging and Distributing Flutter Desktop Apps: Creating macOS .app & .dmg](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-1-macos-b36438269285)

## Linux Debian (.deb) & RPM (.rpm)

[Packaging and Distributing Flutter Desktop Apps: Creating Linux Debian (.deb) & RPM (.rpm) builds](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-for-open-source-indie-24ef8d30a5b4)

## Arch Linux (PKGBUILD)

TODO Instructions

## FlatHub (Flatpak)

TODO Instructions

## Homebrew
# apidash Homebrew Formula Submission

## 1. Prepare Tap Repository
```
# Create Homebrew tap
gh repo create homebrew-tap --public --clone
mkdir -p homebrew-tap/Formula
cd homebrew-tap
```

## 2. Package apidash
```
# Build macOS bundle
flutter build macos

# Create versioned tarball
tar -czvf apidash-v1.0.0.tar.gz \
  -C build/macos/Build/Products/Release/ \
  Apidash.app

# Generate SHA256 checksum
shasum -a 256 apidash-v1.0.0.tar.gz
```

## 3. Create Formula File
`Formula/apidash.rb`:
```
class Apidash < Formula
  desc "Modern API dashboard for developers"
  homepage "https://apidash.dev"
  url "https://github.com/<user>/<repo>/releases/download/v1.0.0/apidash-v1.0.0.tar.gz"
  sha256 "PASTE_YOUR_SHA256_HERE"

  def install
    prefix.install "Apidash.app"
    bin.write_exec_script prefix/"Apidash.app/Contents/MacOS/Apidash"
  end

  test do
    system "#{bin}/Apidash", "--version"
  end
end
```

## 4. Local Validation
```
# Check formula syntax
brew audit --strict Formula/apidash.rb

# Test installation
brew install --build-from-source Formula/apidash.rb

# Verify execution
brew test apidash
```
## 5. Custom Tap Submission
```
# Commit formula to your tap repo
git add Formula/Apidash.rb
git commit -m "added apidash formula"
git push

# Create release for tarball
gh release create v1.0.0 apidash-v1.0.0.tar.gz
```
## 6. Installation
```
brew tap homebrew-tap/Formula
brew install apidash

```

## Chocolatey

TODO Instructions

## WinGet

TODo Instructions
