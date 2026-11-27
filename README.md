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

### User Roles and Permissions (Issue #43 edited by vhien)

The application has two user roles: Administrator (Admin) and Regular User (User).

**Administrator (Admin):**

- Can view, create, edit, and delete students, teachers, subjects, departments, laboratories, sections, and class lists.
- Can import students using spreadsheets.
- Can view sensitive `per_unit_rate` information for teachers and subjects.
- Can delete departments and their associated students, teachers, and laboratories.

**Regular User (User):**

- Can view students, teachers, subjects, departments, laboratories, sections, and class lists.
- Cannot create, edit, or delete records.
- Cannot import students.
- Cannot view sensitive `per_unit_rate` information.

**Authorization Rules:**

- Permissions are enforced through controller-level authorization.
- Restricted URLs are blocked for Regular Users.
- Admin-only buttons are hidden from Regular Users.
- Users cannot change their own roles through forms or request parameters.
- New users automatically receive the `user` role by default.
- Ransack does not provide user or role searching.

**Sample Admin account (development only):**

- Email: `admin@example.com`
- Password: `admin123`

**Setup after pulling these changes:**

```bash
docker compose up -d
docker compose exec web bundle install
docker compose exec web bin/rails db:migrate
docker compose exec web bin/rails db:seed
```

**Running the tests** requires one-time database permissions because Rails runs tests in parallel against several test databases:

```bash
docker compose exec db mysql -uroot -ppassword -e 'GRANT ALL PRIVILEGES ON `department_student_application_test%`.* TO "rails"@"%"; FLUSH PRIVILEGES;'
docker compose exec web bin/rails db:prepare
docker compose exec web bin/rails test
```