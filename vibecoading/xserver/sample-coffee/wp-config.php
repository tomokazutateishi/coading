<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'toretoko_wp5' );

/** Database username */
define( 'DB_USER', 'toretoko_wpqnb' );

/** Database password */
define( 'DB_PASSWORD', '13ya7t84ox' );

/** Database hostname */
define( 'DB_HOST', 'mysql2206.xserver.jp' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'dDWW;:M`@TT3a~r:y*P/$mJ1y84XrMR+~s.4 tbnu,Kjb]KOVVmY,:oaFYjoEwf8' );
define( 'SECURE_AUTH_KEY',  'A,^E%VBtFxo!!+YPlPJjeJjeWAu)rNX,dQDW,Uz0ri$XhD=1be$fY7(9dh.~g45;' );
define( 'LOGGED_IN_KEY',    '7G{xs*Byfqm;O3^$#mp__9TU5@wUbo.hyZzgK?&&D;D$Oa:nru7Z/[S:9AGuTvyN' );
define( 'NONCE_KEY',        'xWt(-@Z5ac?7HeB24bGovZYEG;ys-mDy+i.t@Lz23:c%NbFjPR5BRU!?Bq,ZPWp3' );
define( 'AUTH_SALT',        ',2_]hi|)<B@NoWjvzzHnlwsk&>@rvE5U<B<5OZ>7Wv#:d6O%&rDjFi ^iU5bye$]' );
define( 'SECURE_AUTH_SALT', 'i4[)3vuL1v^}UOYJ|$W.E;.DoD[ ED <P<AB@V!Wy1VqwwL,f:<;,lshx? y[5Q@' );
define( 'LOGGED_IN_SALT',   'z`[B zizyHm@EJEL!G(y_}E7XL B5rlUF|`<S}#Vt ]gI3#,>]4]E#u3%X4m)^5Z' );
define( 'NONCE_SALT',       'lM>KItx{XXPbLiBw{^>)F1^mV/<Puo?PXilPg~*Cf0n|Fi?uqibH:CHV33/7J!JF' );
define( 'WP_SITEURL', 'https://tomokazu-tateishi.site/sample-coffee' );
/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
