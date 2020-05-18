# IMDB Search

Create a prove-of-concept for a system that utilises IMDB distributed indices (available for download as Tab Separated Values) to create an IMDB search that can function on a closed network without an external internet connection.

## The API

The API can be deployed using one of two alternative environments:

1. Development - A local environment used for the development of the app. All
   required software needs to be available on the local host.

2. Test - An immutable environment used to deploy current codebase for testing. All required software is installed as part of the docker build.

Docker build will also run all of the project tests and will fail to deploy unless all of the tests have passed.

### Development environment

1. Ensure that you have all of the following installed:

  - rbenv >= 1.1.1
  - sqlite >= 3.19.3

2. Build ruby:

  ```
  cd backend
  rbenv install
  rbenv init -
  ```
3. Install required gems:

  ```
  gem install bundler
  bundle install
  ```

4. Import TSV data and launch the backend:

  ```
  bundle exec rake db:migrate
  bundle exec rake import:title_basics[PATH_TO_TSV_OR_TSV.GZ]
  ```

5. Start the server

  ```
  bundle exec rake start
  ```

### Test environment

Alternatively, if you have **docker** available on your system then instead of doing all of the above, you can deploy the API with:

  ```
  cd backend
  docker build --tag movie-search .
  docker run -it --publish 9292:9292 movie-search start
  ```

**NOTE:** Sinatra on Test and Production environments is configured to hide
stack traces for failed requests.

## Web Client

Once the server is up and running, the API can be accessed on <http://localhost:9292/>.

The final step is to connect to the API server via the web client. The front page is already configured to connect to <http://localhost:9292/>, but if you need to change that, then the settings are at the top of `frontend/moviesearch.js`.
