# README

This is ewallet API use ruby on rails.

* Installation
```
git clone https://github.com/emzhofb/ewallet-ruby.git
cd ewallet-ruby
bundle install
bin/rails server
go to http://localhost:3000
```

* API list
  - Register API
  For example, we are use http://localhost:3000. Then please hit the API POST into http://localhost:3000/auth/register with this kind of data.
  ```
  {
    "username": "your username",
    "email": "your.email@gmail.com",
    "full_name": "Your Full Name",
    "password": "your password",
    "role": "user/team/stock"
  }
  ```
  - Login API
  - Refresh Token API
  - Add Account API V1
  - Get All Accounts based on User login API V1
  - Get Account by ID V1
  - Update Account Balance V1
  - Transfer Balance V1
