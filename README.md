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
  After successfully register, we can try to login. POST http://localhost:3000/auth/login
  ```
  {
    "username": "your username",
    "password": "your password"
  }
  ```
  - Refresh Token API
  Additionally, we can try to refresh our token. POST http://localhost:3000/auth/refresh use refresh_token from login API.
  ```
  {
    "refresh_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM1NDY5OTd9.82gLA5rQWrmNT503WVZ4iCuMbf4jTqfppac5hmCgFG8"
  }
  ```
  - Add Account API V1
  Authorization: Bearer access_token
  We need to add account first to have ewallet, POST http://localhost:3000/api/v1/accounts/create
  ```
  {
    "account": {
      "currency": "EUR", 
      "balance": 1000.0
    }
  }
  ```
  - Get All Accounts based on User login API V1
  Authorization: Bearer access_token
  GET http://localhost:3000/api/v1/accounts
  - Get Account by ID V1
  Authorization: Bearer access_token
  GET http://localhost:3000/api/v1/accounts/:id
  - Update Account Balance V1
  Authorization: Bearer access_token
  POST http://localhost:3000/api/v1/accounts/:id/update_balance
  ```
  {
    "balance": 1500.0
  }
  ```
  - Transfer Balance V1
  Authorization: Bearer access_token
  POST http://localhost:3000/api/v1/accounts/create
  ```
  {
    "to_account_id": 4,
    "amount": 100.0
  }
  ```

* Testing real application
  - Register 2 users
  Register first user
  ```
  {
    "username": "akasaru",
    "email": "akasaru@gmail.com",
    "full_name": "Akasaru",
    "password": "secret",
    "role": "team"
  }
  ```
  Register second user
  ```
  {
    "username": "meyfolk",
    "email": "meyfolk@gmail.com",
    "full_name": "Meyfolk",
    "password": "secret",
    "role": "stock"
  }
  ```
  - Login first user
  Login first user
  ```
  {
    "username": "akasaru",
    "password": "secret"
  }
  ```
  - Create Account first user
  ```
  {
    "account": {
      "currency": "EUR", 
      "balance": 1000.0
    }
  }
  ```
  - Login second user
  Login second user
  ```
  {
    "username": "meyfolk",
    "password": "secret"
  }
  ```
  - Create Account second user
  ```
  {
    "account": {
      "currency": "EUR", 
      "balance": 1500.0
    }
  }
  ```
  - Transfer balance second user to first user
  Transfer the balance from second user (which decided from our access_token login), and to_account_id, assume the account_id is 1
  ```
  {
    "to_account_id": 1,
    "amount": 100.0
  }
  ```
  - Check balance second account
  After transfering the balance, second user try to hit Get Account ID to know the balance, assume the balance is deducted 100, so it would be 1400
  ```
  {
    "id": 2,
    "owner_id": 2,
    "balance": "1400.0",
    "currency": "EUR",
    "created_at": "2024-11-07T05:03:44.315Z",
    "updated_at": "2024-11-07T08:02:44.174Z"
  }
  ```
  - Login first user
  Login first user first
  ```
  {
    "username": "akasaru",
    "password": "secret"
  }
  ```
  - Check balance first account
  First user try to hit Get Account ID to know the balance, assume the balance is added 100, so it would be 1100
  ```
  {
    "id": 1,
    "owner_id": 1,
    "balance": "1100.0",
    "currency": "EUR",
    "created_at": "2024-11-07T05:03:44.315Z",
    "updated_at": "2024-11-07T08:02:44.174Z"
  }
  ```

* Database
  - ERD
  ![erd](https://github.com/emzhofb/ewallet-ruby/blob/master/Screenshot%202024-11-07%20at%2015.46.39.png)
  - Description
    - Users can have multiple accounts based on currency, they can have EUR, USD, or IDR, or anything.
    - Only account that have same currency can transfer balance, cannot transfer minus balance.
    - Entries contains all recorded transfer, it can have minus and addition to from account and to account for transfer API
  - Approach
  We are using the DB Transaction Lock to prevent inserting any data to database if the whole process is not successful (either it one of them or all of them), any error will make the database rollback the data transfer balance, so it would savely executed later.

* Library
  - The library is in this dir
  ```
  /ewallet
  ├── lib
  │   └── latest_stock_price
  │       ├── client.rb
  │       └── latest_stock_price.rb
  ├── bin
  │   └── stock_price_script.rb
  ├── spec
  │   └── latest_stock_price
  │       └── client_spec.rb
  └── Gemfile
  ```
  - Run the library
  ```
  ruby bin/stock_price_script.rb
  ```

* Thank you
  Thanks for following all the steps, I really appreciate it. Please let me know if you have any question!
