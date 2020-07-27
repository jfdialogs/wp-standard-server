<?php

global $redis_server;

if ($_ENV['REDIS_URL']) {
    if (file_exists(WP_CONTENT_DIR . '/plugins/wp-redis/object-cache.php')) {
        $connection = parse_url($_ENV['REDIS_URL']);
    
        $connection['path'] = trim($connection['path'] ?? '', '/') ?: $_ENV['WEB_HOSTNAME'];
    
        if (!defined('WP_CACHE_KEY_SALT') && $connection['path']) {
            define('WP_CACHE_KEY_SALT', $connection['path']);
        }
    
        $protocol = $_ENV['DEPLOY_ENV'] === 'local' ? '' : 'tls://';
    
        $redis_server = array(
            'host'     => $protocol.$connection['host'],
            'port'     => $connection['port'] ?? 6379,
            'database' => 0,
        );
    
        if ($connection['pass'] ?? '') {
            $redis_server['auth'] = $connection['pass'] ?? '';
        }
        
        require_once WP_CONTENT_DIR . '/plugins/wp-redis/object-cache.php';
    }
}
