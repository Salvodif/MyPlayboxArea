# Project M


***

## API Documentation

### Authentication

##### Signup
- Requires Bearer Token: NO
- URL: ```/auth/signup```
- Method: ```POST```
- Payload: ```{"email": String, "password": String}```
- Response: ```200 SIGNUP_OK```
- Set-Cookie: NO

Note: _Password MUST be hashed_

##### Confirm Email
- Requires Bearer Token: YES
- URL: ```/auth/confirm_email/<email_token>```
- Method: ```GET```
- Payload: EMPTY
- Response: ```200 EMAIL_CONFIRMED```
- Set-Cookie: NO

Note: _Confirmation links are sent to the email address via Twilio' SendGrid_

##### Login
- Requires Bearer Token: NO
- URL: ```/auth/login```
- Method: ```POST```
- Payload: ```{"email": String, "password": String}```
- Response: ```200 LOGIN_OK```
- Set-Cookie ```Authentication: Bearer <token>```


##### Logout
- Requires Bearer Token: YES
- URL: ```/auth/logout```
- Method: ```POST```
- Payload: EMPTY
- Response: ```200 LOGOUT_OK```
- Set-Cookie: ```Authentication: ```

##### Token
- Requires Bearer Token: YES
- URL: ```/auth/token```
- Method: ```POST```
- Payload: ```{"context": String, "id": String}```
- Response: ```{"expires_at": Integer, "token": String}```
- Params:
  - ```context: ```
     - ```world:create``` To create a new character
     - ```world:auth``` To authorize an existing character