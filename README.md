# Dummy HelloWorld

To run this app with nginx+passenger in docker

```
  docker run -p 3210:80 -v /path/to/dummy_prj:/ayla/dummy_prj jslu/passenger-dummy:0.0.1
  curl http://localhost:3210/
```
