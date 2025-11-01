# Comprehensive Hurl file for testing all features

# Simple GET request
GET https://api.example.com/users

# GET with headers
GET https://api.example.com/users/123
Authorization: Bearer token123
Accept: application/json

# GET with query parameters (in URL)
GET https://api.example.com/search?q=flutter&limit=10

# GET with query parameters (Hurl format)
GET https://api.example.com/search
[QueryStringParams]
q: flutter
limit: 10
page: 1

# POST with JSON body
POST https://api.example.com/users
Content-Type: application/json
{
  "name": "John Doe",
  "email": "john@example.com"
}

# POST with form data
POST https://api.example.com/login
[FormParams]
username: john
password: secret123

# POST with multipart form data
POST https://api.example.com/upload
[MultipartFormData]
file: file,example.txt; text/plain
description: A test file

# Request with Basic Auth
GET https://api.example.com/private
[BasicAuth]
admin: secret

# Request with cookies
GET https://api.example.com/dashboard
[Cookies]
session: abc123
preferences: dark_mode

# Request with options
GET https://api.example.com/slow
[Options]
max-redirs: 10
retry: 3
