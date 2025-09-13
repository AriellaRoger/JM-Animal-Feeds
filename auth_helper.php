<?php
/**
 * File: helpers/auth_helper.php
 * Path: /feedsjm/helpers/auth_helper.php
 * Description: Additional authentication helper functions
 */

/**
 * Generate a secure random token
 */
function generateToken($length = 32) {
    return bin2hex(random_bytes($length));
}

/**
 * Validate password strength
 */
function validatePassword($password) {
    $errors = [];
    
    if (strlen($password) < PASSWORD_MIN_LENGTH) {
        $errors[] = "Password must be at least " . PASSWORD_MIN_LENGTH . " characters long";
    }
    
    if (!preg_match('/[A-Z]/', $password)) {
        $errors[] = "Password must contain at least one uppercase letter";
    }
    
    if (!preg_match('/[a-z]/', $password)) {
        $errors[] = "Password must contain at least one lowercase letter";
    }
    
    if (!preg_match('/[0-9]/', $password)) {
        $errors[] = "Password must contain at least one number";
    }
    
    return $errors;
}

/**
 * Check if user has specific permission
 */
function hasPermission($permission) {
    if (!isLoggedIn()) {
        return false;
    }
    
    // Define granular permissions per role
    $rolePermissions = [
        'Administrator' => ['*'], // All permissions
        'Branch Operator' => [
            'pos.view', 'pos.create', 'pos.edit',
            'customers.view', 'customers.create', 'customers.edit',
            'orders.view', 'orders.create',
            'expenses.view', 'expenses.create',
            'fleet.view', 'fleet.request'
        ],
        'Supervisor' => [
            'orders.view', 'orders.approve', 'orders.reject',
            'production.view', 'production.approve',
            'reports.view'
        ],
        'Production Operator' => [
            'production.view', 'production.create', 'production.edit'
        ],
        'Transport Officer' => [
            'fleet.view', 'fleet.manage',
            'orders.view', 'orders.deliver'
        ]
    ];
    
    $userRole = $_SESSION['user_role'];
    
    // Admin has all permissions
    if ($userRole === 'Administrator') {
        return true;
    }
    
    // Check specific permission
    return isset($rolePermissions[$userRole]) && 
           in_array($permission, $rolePermissions[$userRole]);
}

/**
 * Redirect to login if not authenticated
 */
function requireAuth() {
    if (!isLoggedIn()) {
        header('Location: ' . SITE_URL . '/login.php');
        exit();
    }
}

/**
 * Require specific role
 */
function requireRole($roles) {
    requireAuth();
    
    if (!is_array($roles)) {
        $roles = [$roles];
    }
    
    if (!in_array($_SESSION['user_role'], $roles)) {
        header('Location: ' . SITE_URL . '/dashboard.php?error=unauthorized');
        exit();
    }
}

/**
 * Get user's accessible branches
 */
function getUserBranches() {
    if ($_SESSION['user_role'] === 'Administrator') {
        // Admin can access all branches
        $db = getDB();
        $stmt = $db->query("SELECT * FROM branches WHERE status = 'active' ORDER BY branch_name");
        return $stmt->fetchAll();
    } else {
        // Other users can only access their assigned branch
        return [
            [
                'id' => $_SESSION['branch_id'],
                'branch_name' => $_SESSION['branch_name']
            ]
        ];
    }
}

/**
 * Update user password
 */
function updatePassword($userId, $currentPassword, $newPassword) {
    $db = getDB();
    
    // Verify current password
    $stmt = $db->prepare("SELECT password FROM users WHERE id = ?");
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    
    if (!password_verify($currentPassword, $user['password'])) {
        return ['success' => false, 'message' => 'Current password is incorrect'];
    }
    
    // Validate new password
    $errors = validatePassword($newPassword);
    if (!empty($errors)) {
        return ['success' => false, 'message' => implode(', ', $errors)];
    }
    
    // Update password
    $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
    $updateStmt = $db->prepare("UPDATE users SET password = ?, updated_at = NOW() WHERE id = ?");
    $success = $updateStmt->execute([$hashedPassword, $userId]);
    
    if ($success) {
        logActivity('password_change', 'security', 'User changed password');
        return ['success' => true, 'message' => 'Password updated successfully'];
    }
    
    return ['success' => false, 'message' => 'Failed to update password'];
}
