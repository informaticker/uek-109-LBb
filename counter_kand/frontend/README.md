# Frontend


## Environment Variables

```
# React Dev Port
PORT=3000
REACT_APP_VERSION=1.0.0
REACT_APP_NAME=$npm_package_name
```

## Build Arguments

These variables need to be injected when creating a production build

```
REACT_APP_BACKEND_URL=http://localhost:8080
```

## Run the app

### Run the development environment

`npm run dev`

Runs the app in the development mode.

Open [http://localhost:3000](http://localhost:3000) to view the frontend in the browser.

The page will reload if you make edits. You will also see any lint errors in the console.

### Run the production environment

`npm start`

Runs the app in the production mode.

Open [http://localhost:3100](http://localhost:3100) to view the frontend in the browser.


### `npm run build` - only available for frontend

Builds the app for production to the `build` folder.
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes. Your app is ready to be deployed!
