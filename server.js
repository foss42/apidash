const express = require("express");
const path = require("path");

const authenticate = require(path.join(__dirname, "authMiddleware"));

const app = express();

if (typeof authenticate !== "function") {
    console.error("Error: authenticate is not a function");
    process.exit(1);
}

// Protected Route
app.get("/secure-data", authenticate, (req, res) => {
    res.json({ message: "Access Granted: Secure Data" });
});

// Start Server
const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
