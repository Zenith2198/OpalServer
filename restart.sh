echo "Restarting gunicorn server..."
kill -HUP `ps -C gunicorn fch -o pid | head -n 1`
echo "Gunicorn server restarted"