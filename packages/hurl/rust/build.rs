fn main() {
    // Link libxml2 on macOS
    #[cfg(target_os = "macos")]
    {
        // Try Homebrew installation first
        if std::path::Path::new("/opt/homebrew/opt/libxml2/lib").exists() {
            println!("cargo:rustc-link-search=native=/opt/homebrew/opt/libxml2/lib");
            println!("cargo:rustc-link-lib=xml2");
        } else if std::path::Path::new("/usr/local/opt/libxml2/lib").exists() {
            println!("cargo:rustc-link-search=native=/usr/local/opt/libxml2/lib");
            println!("cargo:rustc-link-lib=xml2");
        } else {
            // Fall back to system libxml2
            println!("cargo:rustc-link-lib=xml2");
        }
    }
    
    // For other platforms, rely on pkg-config (handled by hurl_core)
}
