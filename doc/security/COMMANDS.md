# Useful Commands

### Check for outdated dependency vulnerabilities

```bash
dart pub outdated
```

### Run static analysis

```bash
flutter analyze
```

### Check dependencies

```bash
flutter pub deps --style=compact
```

### Generate SBOM with License

```bash
brew install cdxgen

export FETCH_LICENSE=true

cdxgen -t dart -o sbom.json
```
