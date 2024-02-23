echo "Restarting gunicorn server..."
kill -HUP `<app.pid`
echo "Gunicorn server restarted"