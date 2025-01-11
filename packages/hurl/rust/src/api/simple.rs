use hurlfmt::format::format_json;
use hurl_core::parser::parse_hurl_file;
use std::fmt::Write;

#[flutter_rust_bridge::frb(sync)] 
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}
pub fn hello(a: String) -> String { a.repeat(2) }

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

/// Parses a Hurl file content and returns its JSON representation
#[flutter_rust_bridge::frb(sync)]
pub fn parse_hurl_to_json(content: String) -> Result<String, String> {
    // Parse the Hurl file content
    match parse_hurl_file(&content) {
        Ok(hurl_file) => {
            // Convert to JSON using hurlfmt's format_json
            Ok(format_json(&hurl_file))
        }
        Err(errors) => {
            let mut error_msg = String::new();
            write!(error_msg, "Failed to parse Hurl file: {:?}", errors).unwrap();
            Err(error_msg)
        }
    }
}