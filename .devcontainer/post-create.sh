# Install the php vendor packages
composer install
# Use the development environment settings
cp .env.example .env
# Then generate an encryption key and the database
php artisan key:generate
php artisan migrate --force
