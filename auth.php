<?php
/**
 * File: auth.php
 * Path: /feedsjm/auth.php
 * Description: Authentication handler for login/logout operations
 */

require_once 'config.php';

// Handle authentication requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Verify CSRF token
    if (!isset($_POST['csrf_token']) || !verifyCSRFToken($_POST['csrf_token'])) {
        header('Location: login.php?error=csrf');
        exit();
    }
    
    $action = $_POST['action'] ?? '';
    
    if ($action === 'login') {
        handleLogin();
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $action = $_GET['action'] ?? '';
    
    if ($action === 'logout') {
        handleLogout();
    }
}

// Login handler
function handleLogin() {
    $email = sanitize($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $remember = isset($_POST['remember']);
    
    if (empty($email) || empty($password)) {
        header('Location: login.php?error=1');
        exit();
    }
    
    try {
        $db = getDB();
        
        // Get user data
        $stmt = $db->prepare("SELECT u.*, b.branch_name, b.is_hq 
                              FROM users u 
                              LEFT JOIN branches b ON u.branch_id = b.id 
                              WHERE u.email = ? AND u.status = 'active'");
        $stmt->execute([$email]);
        $user = $stmt->fetch();
        
        if ($user && password_verify($password, $user['password'])) {
            // Regenerate session ID for security
            if (REGENERATE_SESSION) {
                session_regenerate_id(true);
            }
            
            // Set session variables
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['user_name'] = $user['first_name'] . ' ' . $user['last_name'];
            $_SESSION['user_email'] = $user['email'];
            $_SESSION['user_role'] = $user['role'];
            $_SESSION['branch_id'] = $user['branch_id'];
            $_SESSION['branch_name'] = $user['branch_name'];
            $_SESSION['is_hq'] = $user['is_hq'];
            $_SESSION['last_activity'] = time();
            $_SESSION['login_time'] = time();
            
            // Set remember me cookie if requested
            if ($remember) {
                setcookie('jmfeeds_remember', $user['email'], time() + (86400 * 30), '/');
            }
            
            // Update last login
            $updateStmt = $db->prepare("UPDATE users SET last_login = NOW() WHERE id = ?");
            $updateStmt->execute([$user['id']]);
            
            // Log successful login
            logActivity('login', 'authentication', 'User logged in successfully');
            
            // Redirect to dashboard
            header('Location: dashboard.php');
            exit();
            
        } else {
            // Log failed login attempt
            $db->prepare("INSERT INTO activity_logs (user_id, action, module, description, ip_address) 
                          VALUES (NULL, 'failed_login', 'authentication', ?, ?)")
               ->execute(['Failed login attempt for: ' . $email, $_SERVER['REMOTE_ADDR']]);
            
            header('Location: login.php?error=1');
            exit();
        }
        
    } catch (Exception $e) {
        error_log('Login error: ' . $e->getMessage());
        header('Location: login.php?error=system');
        exit();
    }
}

// Logout handler
function handleLogout() {
    if (isLoggedIn()) {
        // Log logout activity
        logActivity('logout', 'authentication', 'User logged out');
    }
    
    // Destroy session
    session_unset();
    session_destroy();
    
    // Clear remember me cookie
    if (isset($_COOKIE['jmfeeds_remember'])) {
        setcookie('jmfeeds_remember', '', time() - 3600, '/');
    }
    
    header('Location: login.php?logout=1');
    exit();
}