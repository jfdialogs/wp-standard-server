<?php

if (!defined('APP_ENV')) {
    define('APP_ENV', $_ENV['APP_ENV'] ?? 'prod');
}

if (!function_exists('dump')) {
    function is_prod_env() {
        return !defined('APP_ENV') || APP_ENV === 'prod';
    }
    
    function is_cli() {
        return php_sapi_name() === 'cli';;
    }
    
    function dump(...$arguments) {
        if (!is_prod_env() || is_cli()) {
            if (!is_cli()) echo '<pre>';
            var_dump(...$arguments);
            if (!is_cli()) echo '</pre>';
        }
    }
    
    function dd(...$arguments) {
        dump(...$arguments);
        exit;
    }
}

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * Changed from default value of "wordpress_test_cookie" to avoid varnish MISS
 * on caching pages when this cookie is present (after logout).
 */
define('TEST_COOKIE', 'www_test_cookie');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * You may want to examine $_ENV['PANTHEON_ENVIRONMENT'] to set this to be
 * "true" in dev, but false in test and live.
 */
if ($_ENV['DEPLOY_ENV'] === 'local') {
    define('DISALLOW_FILE_MODS', false);
    define('SCRIPT_DEBUG', true);
    define('WP_DEBUG_LOG', WP_DEBUG === true);
    define('WP_DEBUG_DISPLAY', WP_DEBUG === true);
} elseif ($_ENV['DEPLOY_ENV'] === 'dev') {
    define('DISALLOW_FILE_MODS', true);
    define('SCRIPT_DEBUG', true);
    define('WP_DEBUG_LOG', WP_DEBUG === true);
    define('WP_DEBUG_DISPLAY', false);
} else {
    define('DISALLOW_FILE_MODS', true);
    define('SCRIPT_DEBUG', false);
    define('WP_DEBUG_LOG', false);
    define('WP_DEBUG_DISPLAY', false);
}

/**
 * Disable post revisions bc they make the database too big
 * https://www.wpbeginner.com/wp-tutorials/how-to-disable-post-revisions-in-wordpress-and-reduce-database-size/
 */
if ( ! defined( 'WP_POST_REVISIONS' ) ) {
    define('WP_POST_REVISIONS', false );
}

/**
 * Amazon Access Keys
 * https://deliciousbrains.com/wp-offload-s3/doc/quick-start-guide/#save-access-keys
 */
define('AS3CF_AWS_ACCESS_KEY_ID', $_ENV['AS3CF_AWS_ACCESS_KEY_ID']);
define('AS3CF_AWS_SECRET_ACCESS_KEY', $_ENV['AS3CF_AWS_SECRET_ACCESS_KEY']);

if ($_ENV['APP_ENV'] !== 'prod') {
    if (!isset($_ENV['AS3CF_BUCKET'])) {
        throw new RuntimeException(
            'AS3CF_BUCKET environment variable is required in non-prod mode.'
        );
    }
    
    if ($_ENV['AS3CF_BUCKET']) {
        define('AS3CF_BUCKET', $_ENV['AS3CF_BUCKET']);
    
        define('AS3CF_SETTINGS', serialize(array(
            'provider' => 'aws',
            'access-key-id' => $_ENV['AS3CF_AWS_ACCESS_KEY_ID'],
            'secret-access-key' => $_ENV['AS3CF_AWS_SECRET_ACCESS_KEY'],
        )));
    }
}

/** A couple extra tweaks to help things run. **/
if (isset($_SERVER['HTTP_HOST'])) {
    // HTTP is still the default scheme for now.
    $scheme = 'http';
    
    // If we have detected that the end use is HTTPS, make sure we pass that
    // through here, so <img> tags and the like don't generate mixed-mode
    // content warnings.
    if (isset($_SERVER['HTTP_USER_AGENT_HTTPS']) && $_SERVER['HTTP_USER_AGENT_HTTPS'] == 'ON'
        || isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') {
        $scheme = 'https';
        $_SERVER['HTTPS'] = 'on';
    }
    
    define('WP_HOME', $scheme . '://' . $_SERVER['HTTP_HOST']);
    define('WP_SITEURL', $scheme . '://' . $_SERVER['HTTP_HOST']);
}

// Don't show deprecations; useful under PHP 5.5
error_reporting(E_ALL ^ E_DEPRECATED);

if (file_exists($redirects = ABSPATH . 'wp-content/redirects.php')) {
    require_once $redirects;
}
