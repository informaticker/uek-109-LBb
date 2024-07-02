# Backend

## Environment Variables

```
NODE_ENV=development

# Database Information
DB_HOST=localhost
DB_NAME=database
DB_USER=postgres
DB_PASSWORD=password

# Test Secret for /api/health/secret
PASSPHRASE=secret
```

## Available Scripts

### Migrations

The backend provides the following commands to initiate the database and run the migrations.

```
# create database
npx sequelize-cli db:create

# run migrations
npx sequelize-cli db:migrate
```

## Run the app

### Run the development environment

`npm run dev`

Runs the app in the development mode.

Open [http://localhost:8080](http://localhost:8080) to view the backend in the browser.
Open [http://localhost:3100](http://localhost:3100) to view the frontend in the browser.

The page will reload if you make edits. You will also see any lint errors in the console.

### Run the production environment

`npm start`

Runs the app in the production mode.
Open [http://localhost:8080](http://localhost:8080) to view the backend in the browser.
Open [http://localhost:3100](http://localhost:3100) to view the frontend in the browser.
