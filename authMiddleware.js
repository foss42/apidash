const basicAuth = require("basic-auth"); 

function authenticate(req, res, next) {
    const user = basicAuth(req);
    if (!user || user.name !== "admin" || user.pass !== "password123") {
        res.set("WWW-Authenticate", 'Basic realm="Restricted Access"');
        return res.status(401).json({ message: "Unauthorized Access" });
    }
    next(); 
}

module.exports = authenticate; 
