<?php
/**
 * File: logout.php
 * Path: /feedsjm/logout.php
 * Description: Session termination handler
 */

require_once 'config.php';

// Redirect to auth handler for logout
header('Location: auth.php?action=logout');
exit();
