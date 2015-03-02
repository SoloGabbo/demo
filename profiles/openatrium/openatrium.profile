<?php

/**
 * @file
 * Install profile for Open Atrium.
 */

include_once 'install_from_db/install_from_db.profile';

/**
 * Implements hook_appstore_stores_info().
 */
function openatrium_apps_servers_info() {
 $info =  drupal_parse_info_file(dirname(__file__) . '/openatrium.info');
 return array(
   'openatrium' => array(
     'title' => 'OpenAtrium',
     'description' => "Apps for the OpenAtrium distribution",
     // @CHANGE this to -stable for stable releases.
     'manifest' => 'http://appserver.openatrium.com/app/query/openatrium-development',
     'profile' => 'openatrium',
     'profile_version' => isset($info['version']) ? $info['version'] : '7.x-2.x-dev',
     'server_name' => !empty($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] : '',
     'server_ip' => !empty($_SERVER['SERVER_ADDR']) ? $_SERVER['SERVER_ADDR'] : '',
   ),
 );
}

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form.
 */
function openatrium_form_install_configure_form_alter(&$form, &$form_state) {
  openatrium_remove_message('offers a wide range of customization options', 'warning');
  openatrium_remove_message('The image resize filter has been installed', 'warning');
  openatrium_remove_message('To use menu blocks, find the "Add menu block');
}

/**
 * Implements hook_form_FORM_ID_alter() for panopoly_theme_selection_form.
 */
function openatrium_form_panopoly_theme_selection_form_alter(&$form, &$form_state, $form_id) {
  // Change the default theme in the selection form.
  unset($form['theme_wrapper']['theme']['#options']['radix']);
  unset($form['theme_wrapper']['theme']['#options']['radix_starter']);
  $form['theme_wrapper']['theme']['#default_value'] = 'oa_radix';
}

/**
 * Implements hook_features_post_restore().
 */
function openatrium_features_post_restore($op, $items) {
  openatrium_remove_message('The following views were using the index', 'warning');
}

/**
 * Remove a message as set by drupal_set_message().
 *
 * This is used during install to remove irrelavent messages.
 */
function openatrium_remove_message($partial_message, $type = 'status') {
  if (!empty($_SESSION['messages'][$type])) {
    foreach ($_SESSION['messages'][$type] as $key => $message) {
      if (strpos($message, $partial_message) !== FALSE) {
        unset($_SESSION['messages'][$type][$key]);
      }
    }
    if (empty($_SESSION['messages'][$type])) {
      unset($_SESSION['messages'][$type]);
    }
  }
}
