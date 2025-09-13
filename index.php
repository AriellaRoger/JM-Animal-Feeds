<?php
/**
 * File: index.php
 * Path: /feedsjm/index.php
 * Description: Application entry point - redirects to appropriate page
 */

require_once 'config.php';

// Check if user is logged in
if (isLoggedIn()) {
    // User is logged in, redirect to dashboard
    header('Location: dashboard.php');
} else {
    // User is not logged in, redirect to login page
    header('Location: login.php');
}
exit();
