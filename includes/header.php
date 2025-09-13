<?php
/**
 * File: includes/header.php
 * Path: /feedsjm/includes/header.php
 * Description: Common header file for all pages
 */

// Ensure user is logged in
if (!isLoggedIn()) {
    header('Location: login.php');
    exit();
}

// Check session timeout
checkSessionTimeout();

// Get current user
$currentUser = getCurrentUser();
if (!$currentUser) {
    header('Location: auth.php?action=logout');
    exit();
}

// Get notification count
$db = getDB();
$notifStmt = $db->prepare("SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND is_read = 0");
$notifStmt->execute([$_SESSION['user_id']]);
$notificationCount = $notifStmt->fetchColumn();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $pageTitle ?? 'Dashboard'; ?> - JM Animal Feeds</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<?php echo ASSETS_PATH; ?>/css/style.css">
    <?php if (isset($additionalCSS)): ?>
        <?php foreach ($additionalCSS as $css): ?>
            <link rel="stylesheet" href="<?php echo ASSETS_PATH; ?>/css/<?php echo $css; ?>">
        <?php endforeach; ?>
    <?php endif; ?>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="dashboard.php">
                <i class="fas fa-cow"></i> JM Animal Feeds
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <!-- Main Navigation -->
                <ul class="navbar-nav me-auto">
                    <?php if (hasAccess('dashboard')): ?>
                        <li class="nav-item">
                            <a class="nav-link" href="dashboard.php">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                        </li>
                    <?php endif; ?>
                    
                    <?php if (hasAccess('pos')): ?>
                        <li class="nav-item">
                            <a class="nav-link" href="modules/pos/index.php">
                                <i class="fas fa-cash-register"></i> POS
                            </a>
                        </li>
                    <?php endif; ?>
                    
                    <?php if (hasAccess('inventory')): ?>
                        <li class="nav-item">
                            <a class="nav-link" href="modules/inventory/index.php">
                                <i class="fas fa-warehouse"></i> Inventory
                            </a>
                        </li>
                    <?php endif; ?>
                    
                    <?php if (hasAccess('production')): ?>
                        <li class="nav-item">
                            <a class="nav-link" href="modules/production/index.php">
                                <i class="fas fa-industry"></i> Production
                            </a>
                        </li>
                    <?php endif; ?>
                    
                    <?php if (hasAccess('orders')): ?>
                        <li class="nav-item">
                            <a class="nav-link" href="modules/orders/index.php">
                                <i class="fas fa-shopping-cart"></i> Orders
                            </a>
                        </li>
                    <?php endif; ?>
                    
                    <?php if (hasAccess('reports')): ?>
                        <li class="nav-item">
                            <a class="nav-link" href="modules/reports/index.php">
                                <i class="fas fa-chart-bar"></i> Reports
                            </a>
                        </li>
                    <?php endif; ?>
                    
                    <!-- Dropdown for more modules -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" 
                           data-bs-toggle="dropdown">
                            <i class="fas fa-th"></i> Modules
                        </a>
                        <ul class="dropdown-menu">
                            <?php if (hasAccess('customers')): ?>
                                <li><a class="dropdown-item" href="modules/customers/index.php">
                                    <i class="fas fa-users"></i> Customers
                                </a></li>
                            <?php endif; ?>
                            
                            <?php if (hasAccess('suppliers')): ?>
                                <li><a class="dropdown-item" href="modules/suppliers/index.php">
                                    <i class="fas fa-truck"></i> Suppliers
                                </a></li>
                            <?php endif; ?>
                            
                            <?php if (hasAccess('fleet')): ?>
                                <li><a class="dropdown-item" href="modules/fleet/index.php">
                                    <i class="fas fa-car"></i> Fleet Management
                                </a></li>
                            <?php endif; ?>
                            
                            <?php if (hasAccess('expenses')): ?>
                                <li><a class="dropdown-item" href="modules/expenses/index.php">
                                    <i class="fas fa-money-bill-wave"></i> Expenses
                                </a></li>
                            <?php endif; ?>
                            
                            <?php if (hasAccess('formula')): ?>
                                <li><a class="dropdown-item" href="modules/formula/index.php">
                                    <i class="fas fa-flask"></i> Formula Management
                                </a></li>
                            <?php endif; ?>
                            
                            <?php if (hasAccess('users')): ?>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="modules/users/index.php">
                                    <i class="fas fa-user-cog"></i> User Management
                                </a></li>
                            <?php endif; ?>
                            
                            <?php if (hasAccess('branches')): ?>
                                <li><a class="dropdown-item" href="modules/branches/index.php">
                                    <i class="fas fa-building"></i> Branch Management
                                </a></li>
                            <?php endif; ?>
                        </ul>
                    </li>
                </ul>
                
                <!-- Right side navigation -->
                <ul class="navbar-nav">
                    <!-- Branch Display -->
                    <li class="nav-item">
                        <span class="nav-link">
                            <i class="fas fa-map-marker-alt"></i> <?php echo $_SESSION['branch_name']; ?>
                        </span>
                    </li>
                    
                    <!-- Notifications -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="notificationDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-bell"></i>
                            <?php if ($notificationCount > 0): ?>
                                <span class="badge bg-danger"><?php echo $notificationCount; ?></span>
                            <?php endif; ?>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><h6 class="dropdown-header">Notifications</h6></li>
                            <li><a class="dropdown-item" href="modules/notifications/index.php">
                                View All Notifications
                            </a></li>
                        </ul>
                    </li>
                    
                    <!-- User Menu -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle"></i> <?php echo $_SESSION['user_name']; ?>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><h6 class="dropdown-header"><?php echo $_SESSION['user_role']; ?></h6></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="modules/profile/index.php">
                                <i class="fas fa-user"></i> Profile
                            </a></li>
                            <li><a class="dropdown-item" href="modules/settings/index.php">
                                <i class="fas fa-cog"></i> Settings
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.php">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Main Content Container -->
    <div class="main-content">
