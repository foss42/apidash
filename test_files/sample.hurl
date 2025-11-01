# Sample Hurl file for testing import functionality

GET https://api.github.com/users/octocat
User-Agent: API Dash
Accept: application/json

POST https://jsonplaceholder.typicode.com/posts
Content-Type: application/json

DELETE https://jsonplaceholder.typicode.com/posts/1
Authorization: Bearer sample_token_12345

GET https://api.example.com/search?q=flutter&limit=10&page=1
Accept: application/json
X-Custom-Header: test-value
