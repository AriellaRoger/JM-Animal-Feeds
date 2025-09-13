<?php
/**
 * File: config.php
 * Path: /feedsjm/config.php
 * Description: System configuration and database connection settings
 */

// Error reporting for development (disable in production)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'feedsjm');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

// System configuration
define('SITE_NAME', 'JM Animal Feeds');
define('SITE_URL', 'http://localhost/feedsjm');
define('SESSION_TIMEOUT', 1800); // 30 minutes in seconds
define('DEFAULT_TIMEZONE', 'Africa/Dar_es_Salaam');
define('CURRENCY', 'TZS');
define('DATE_FORMAT', 'Y-m-d');
define('TIME_FORMAT', 'H:i:s');

// Set timezone
date_default_timezone_set(DEFAULT_TIMEZONE);

// Directory paths
define('ROOT_PATH', dirname(__FILE__));
define('INCLUDES_PATH', ROOT_PATH . '/includes');
define('ASSETS_PATH', SITE_URL . '/assets');
define('MODULES_PATH', ROOT_PATH . '/modules');

// Security settings
define('SECURE_SESSION', true);
define('REGENERATE_SESSION', true);
define('PASSWORD_MIN_LENGTH', 8);

// Create database connection
class Database {
    private static $instance = null;
    private $conn;
    
    private function __construct() {
        try {
            $this->conn = new PDO(
                "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET,
                DB_USER,
                DB_PASS,
                array(
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false
                )
            );
        } catch(PDOException $e) {
            die("Connection failed: " . $e->getMessage());
        }
    }
    
    public static function getInstance() {
        if (self::$instance == null) {
            self::$instance = new Database();
        }
        return self::$instance;
    }
    
    public function getConnection() {
        return $this->conn;
    }
}

// Get database connection
function getDB() {
    return Database::getInstance()->getConnection();
}

// Session configuration
if (session_status() == PHP_SESSION_NONE) {
    session_name('jmfeeds_session');
    session_start();
}

// Auto logout after inactivity
function checkSessionTimeout() {
    if (isset($_SESSION['last_activity']) && (time() - $_SESSION['last_activity'] > SESSION_TIMEOUT)) {
        session_unset();
        session_destroy();
        header("Location: " . SITE_URL . "/login.php?timeout=1");
        exit();
    }
    $_SESSION['last_activity'] = time();
}

// Check if user is logged in
function isLoggedIn() {
    return isset($_SESSION['user_id']) && !empty($_SESSION['user_id']);
}

// Get current user data
function getCurrentUser() {
    if (!isLoggedIn()) {
        return null;
    }
    
    $db = getDB();
    $stmt = $db->prepare("SELECT u.*, b.branch_name, b.is_hq 
                          FROM users u 
                          LEFT JOIN branches b ON u.branch_id = b.id 
                          WHERE u.id = ? AND u.status = 'active'");
    $stmt->execute([$_SESSION['user_id']]);
    return $stmt->fetch();
}

// Check user permission for module
function hasAccess($module) {
    if (!isLoggedIn()) {
        return false;
    }
    
    $role = $_SESSION['user_role'];
    
    // Define module access permissions
    $permissions = [
        'Administrator' => [
            'dashboard', 'inventory', 'formula', 'production', 'orders', 'pos', 
            'customers', 'suppliers', 'purchases', 'fleet', 'expenses', 'reports', 
            'users', 'branches', 'settings', 'notifications', 'profile'
        ],
        'Branch Operator' => [
            'dashboard', 'pos', 'expenses', 'orders', 'customers', 'fleet', 
            'profile', 'settings', 'notifications'
        ],
        'Supervisor' => [
            'dashboard', 'orders', 'production', 'profile', 'settings', 'notifications'
        ],
        'Production Operator' => [
            'dashboard', 'production', 'profile', 'settings', 'notifications'
        ],
        'Transport Officer' => [
            'dashboard', 'fleet', 'orders', 'profile', 'settings', 'notifications'
        ]
    ];
    
    return isset($permissions[$role]) && in_array($module, $permissions[$role]);
}

// Log user activity
function logActivity($action, $module, $description = '', $reference_id = null) {
    if (!isLoggedIn()) {
        return false;
    }
    
    $db = getDB();
    $stmt = $db->prepare("INSERT INTO activity_logs (user_id, action, module, description, ip_address, user_agent) 
                          VALUES (?, ?, ?, ?, ?, ?)");
    
    $ip = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
    $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
    
    return $stmt->execute([
        $_SESSION['user_id'],
        $action,
        $module,
        $description,
        $ip,
        $userAgent
    ]);
}

// Sanitize input
function sanitize($input) {
    return htmlspecialchars(strip_tags(trim($input)));
}

// Generate CSRF token
function generateCSRFToken() {
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

// Verify CSRF token
function verifyCSRFToken($token) {
    return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
}

// Format currency
function formatCurrency($amount) {
    return CURRENCY . ' ' . number_format($amount, 2);
}

// Format date
function formatDate($date, $format = null) {
    if ($format === null) {
        $format = DATE_FORMAT;
    }
    return date($format, strtotime($date));
}

// Get branch filter for queries
function getBranchFilter($tableAlias = '') {
    if ($_SESSION['user_role'] === 'Administrator') {
        return ''; // No filter for administrators
    }
    
    $prefix = $tableAlias ? $tableAlias . '.' : '';
    return " AND {$prefix}branch_id = " . intval($_SESSION['branch_id']);
}