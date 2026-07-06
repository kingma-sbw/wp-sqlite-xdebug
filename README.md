# wp-sqlite-xdebug

ARCHIVED look at : https://github.com/kingma-sbw/docker-sqlite-wordpress

THe ultimate WP environment for plugin and theme development including with the low resource impact of sqlite.

- XDEBUG step debugging and profiling.
- Easy access to `wp-content` folder
- Predefined `launch.json` and `xdebug.ini` files for Visual Studio Code debugging.

## Wordpress (current version & php 8.4)

Creates the following

* `/logs`
* `/wp-content`

And links the `xdebug.ini` file.

## Install
For wordpress stubs run `composer update` to create the `/vendor`
Install [XDEBUG extension](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)

After editing the `xdebug.ini` make sure to restart the container.
