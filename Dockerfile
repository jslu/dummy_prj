# === 1 ===
FROM phusion/passenger-ruby19:0.9.18
MAINTAINER Joe Lu "joe.lu@aylanetworks.com"

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# === 2 ===
# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# === 3 ====
# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx info
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf

# === 4 ===
# Prepare folders
RUN mkdir -p /ayla/dummy_prj

# === 5 ===
# Run Bundle in a cache efficient way
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# === 6 ===
# Add the rails app
#ADD . /ayla/dummy_prj

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  