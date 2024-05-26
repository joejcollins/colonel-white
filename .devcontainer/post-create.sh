# Install the php vendor packages
composer install
# Then generate an encryption key and the database
php artisan key:generate
php artisan migrate --force