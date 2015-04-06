bind "tcp://127.0.0.1:8080"
workers 2
threads 8,32
preload_app!
