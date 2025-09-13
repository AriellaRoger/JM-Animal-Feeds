<?php
/**
 * File: refresh_session.php
 * Path: /feedsjm/refresh_session.php
 * Description: Refresh user session to prevent timeout
 */

require_once 'config.php';

if (isLoggedIn()) {
    $_SESSION['last_activity'] = time();
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Not logged in']);
}