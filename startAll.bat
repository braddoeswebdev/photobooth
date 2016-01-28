echo "Starting Web App"
start ruby app.rb -o 0.0.0.0

echo "Starting Faye"
start rackup faye.ru -s thin -E production

echo "Starting File Listener"
start ruby listener.rb
