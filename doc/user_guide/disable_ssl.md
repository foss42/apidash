## How to Disable SSL for Requests

*Note: This feature currently works on all platforms except Web*

**Step 1**

Make a GET request to https://expired-rsa-dv.ssl.com/

![ssl-1](https://raw.githubusercontent.com/foss42/apidash/refs/heads/main/doc/user_guide/images/ssl/ssl-1.png)

You will receive a certificate failed error.

**Step 2**

Visit API Dash Settings & turn on the "Disable SSL verification" switch

![ssl-2a](https://raw.githubusercontent.com/foss42/apidash/refs/heads/main/doc/user_guide/images/ssl/ssl-2a.png)

![ssl-2b](https://raw.githubusercontent.com/foss42/apidash/refs/heads/main/doc/user_guide/images/ssl/ssl-2b.png)

**Step 3**

Now, Resend the request.

![ssl-3](https://raw.githubusercontent.com/foss42/apidash/refs/heads/main/doc/user_guide/images/ssl/ssl-3.png)

You will receive a the response successfully.
