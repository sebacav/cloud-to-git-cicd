FROM ruby:2.6-alpine3.11
#set bundler version
ENV BUNDLER_VERSION=2.1.4
# update necessary packages
RUN apk add --update --no-cache \
binutils-gold \
build-base \
curl \
file \
g++ \
gcc \
git \
less \
libstdc++ \
libffi-dev \
libc-dev \ 
linux-headers \
libxml2-dev \
libxslt-dev \
libgcrypt-dev \
make \
netcat-openbsd \
nodejs \
openssl \
pkgconfig \
postgresql-dev \
python \
tzdata \
yarn
# install bundler version used for this project
RUN gem install bundler -v 2.1.4
# Go to app directory
WORKDIR /app
# Copy Gems config files
COPY Gemfile Gemfile.lock ./
# Install dependencies
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install
# Copy all file from app to root
COPY . ./ 
# Set privilege to run script, this script remove any rails process if this exist, just for precaution
RUN ["chmod", "+x","./entrypoints/docker-entrypoint.sh"]
# Run script
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# Never set this variable in real life, only if you wanna drop you database
# ENV DISABLE_DATABASE_ENVIRONMENT_CHECK=1
ENV TEST_USERNAME=rails
ENV TEST_PASSWORD=B6yCwsrdHc
ENV DB_USERNAME=xxxxx
ENV DB_PASSWORD=xxxxx
# Create database if it dosen't exist
# RUN ["rails", "db:create"]
# Migrate news schemas
# RUN ["rails", "db:migrate"]
# Charge the database schema if it doesn't exist
# RUN ["rails", "db:schema:load"]
# drop database, just for this example
# RUN ["rails", "db:reset"]
# Run the controller test API
RUN ["rails", "test"]
# set rails to production
ENV RAILS_ENV=production
# Start the main process in production.
CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
