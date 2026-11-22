# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Authentication (added by Hurnan)

Every page except the login page requires a logged-in user.

**Sample account (development only):**

- Email: `user@example.com`
- Password: `password123`

**Setup after pulling these changes:**

    docker compose up -d
    docker compose exec web bundle install
    docker compose exec web bin/rails db:migrate
    docker compose exec web bin/rails db:seed

**Running the tests** needs one-time database permissions, because Rails runs tests in parallel against several test databases:

    docker compose exec db mysql -uroot -ppassword -e 'GRANT ALL PRIVILEGES ON `department_student_application_test%`.* TO "rails"@"%"; FLUSH PRIVILEGES;'
    docker compose exec web bin/rails db:prepare
    docker compose exec web bin/rails test

Four older tests fail for reasons unrelated to login (two slug-URL "update" tests, "create section" and "create classlist").
