echo "Starting Faye"
start rackup faye.ru -s thin -E production

echo "Starting Web App"
start ruby app.rb

echo "Starting File Listener"
start ruby listener.rb
