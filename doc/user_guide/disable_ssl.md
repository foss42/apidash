## How to Disable SSL for Requests

*Note: This feature currently works on all platforms except Web*

**Step 1**

Make a GET request to https://expired-rsa-dv.ssl.com/

![ssl-1](https://github.com/user-attachments/assets/2348e45e-2d8d-4f29-9994-31668f4cf828)

You will receive a certificate failed error.

**Step 2**

Visit API Dash Settings & turn on the "Disable SSL verification" switch

![ssl-2a](https://github.com/user-attachments/assets/6c86437a-7f6c-4d27-8de4-ea327d2fbe43)

![ssl-2b](https://github.com/user-attachments/assets/cf67c20e-c8b5-43be-ac78-75a72dd85303)

**Step 3**

Now, Resend the request.

![ssl-3](https://github.com/user-attachments/assets/2eb186f4-44b2-4478-9a34-e6324c441901)

You will receive a the response successfully.
