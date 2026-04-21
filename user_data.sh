#!/bin/bash
set -e

# Update system packages
apt-get update
apt-get upgrade -y

# Install Nginx
apt-get install -y nginx

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Create a simple health check page
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Nginx on Azure!</h1>
        <p>Your web server is successfully running on Azure VM.</p>
        <p><strong>Hostname:</strong> $(hostname)</p>
        <p><strong>IP Address:</strong> $(hostname -I)</p>
        <p><strong>Time:</strong> $(date)</p>
    </div>
</body>
</html>
EOF

# Configure Nginx to log properly
systemctl restart nginx

echo "Nginx installation and configuration completed successfully!"
