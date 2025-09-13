<?php
/**
 * File: dashboard.php
 * Path: /feedsjm/dashboard.php
 * Description: Main dashboard after login with role-specific content
 */

require_once 'config.php';
$pageTitle = 'Dashboard';
require_once 'includes/header.php';

// Get dashboard statistics based on user role
$db = getDB();
$stats = [];

// Get branch filter for non-admin users
$branchFilter = getBranchFilter();

// Common statistics for all users
if (hasAccess('dashboard')) {
    // Today's sales
    $salesQuery = "SELECT COUNT(*) as count, COALESCE(SUM(total_amount), 0) as total 
                   FROM sales 
                   WHERE DATE(sale_date) = CURDATE() 
                   AND status = 'completed'" . getBranchFilter('sales');
    $salesStmt = $db->query($salesQuery);
    $stats['today_sales'] = $salesStmt->fetch();
    
    // Get recent activities for current user (or all for admin)
    $activityQuery = "SELECT a.*, u.first_name, u.last_name 
                      FROM activity_logs a 
                      JOIN users u ON a.user_id = u.id ";
    
    if ($_SESSION['user_role'] !== 'Administrator') {
        $activityQuery .= "WHERE a.user_id = " . $_SESSION['user_id'] . " ";
    }
    
    $activityQuery .= "ORDER BY a.created_at DESC LIMIT 10";
    $activities = $db->query($activityQuery)->fetchAll();
}

// Role-specific statistics
switch ($_SESSION['user_role']) {
    case 'Administrator':
        // Total inventory value
        $invQuery = "SELECT COALESCE(SUM(s.quantity * i.cost_price), 0) as total_value 
                     FROM inventory_stock s 
                     JOIN inventory_items i ON s.item_id = i.id";
        $stats['inventory_value'] = $db->query($invQuery)->fetchColumn();
        
        // Active users
        $stats['active_users'] = $db->query("SELECT COUNT(*) FROM users WHERE status = 'active'")->fetchColumn();
        
        // Pending orders
        $stats['pending_orders'] = $db->query("SELECT COUNT(*) FROM orders WHERE status = 'pending'")->fetchColumn();
        
        // Low stock items
        $lowStockQuery = "SELECT COUNT(DISTINCT i.id) 
                          FROM inventory_items i 
                          JOIN inventory_stock s ON i.id = s.item_id 
                          WHERE s.quantity <= i.reorder_level";
        $stats['low_stock'] = $db->query($lowStockQuery)->fetchColumn();
        break;
        
    case 'Branch Operator':
        // Branch stock value
        $branchInvQuery = "SELECT COALESCE(SUM(s.quantity * i.retail_price), 0) as total_value 
                           FROM inventory_stock s 
                           JOIN inventory_items i ON s.item_id = i.id 
                           WHERE s.branch_id = " . $_SESSION['branch_id'];
        $stats['branch_stock_value'] = $db->query($branchInvQuery)->fetchColumn();
        
        // Today's customers
        $custQuery = "SELECT COUNT(DISTINCT customer_id) 
                      FROM sales 
                      WHERE DATE(sale_date) = CURDATE() 
                      AND branch_id = " . $_SESSION['branch_id'];
        $stats['today_customers'] = $db->query($custQuery)->fetchColumn();
        
        // Pending credit payments
        $creditQuery = "SELECT COUNT(*) as count, COALESCE(SUM(balance_amount), 0) as total 
                        FROM sales 
                        WHERE payment_status IN ('pending', 'partial') 
                        AND branch_id = " . $_SESSION['branch_id'];
        $creditStmt = $db->query($creditQuery);
        $stats['pending_credits'] = $creditStmt->fetch();
        break;
        
    case 'Supervisor':
        // Today's production
        $prodQuery = "SELECT COUNT(*) as batches, COALESCE(SUM(total_output_kg), 0) as total_kg 
                      FROM production_batches 
                      WHERE DATE(start_time) = CURDATE()";
        $prodStmt = $db->query($prodQuery);
        $stats['today_production'] = $prodStmt->fetch();
        
        // Pending approvals
        $stats['pending_approvals'] = $db->query("SELECT COUNT(*) FROM orders WHERE status = 'pending'")->fetchColumn();
        break;
        
    case 'Production Operator':
        // My production today
        $myProdQuery = "SELECT COUNT(*) as batches, COALESCE(SUM(total_output_kg), 0) as total_kg 
                        FROM production_batches 
                        WHERE operator_id = " . $_SESSION['user_id'] . " 
                        AND DATE(start_time) = CURDATE()";
        $myProdStmt = $db->query($myProdQuery);
        $stats['my_production'] = $myProdStmt->fetch();
        
        // Active formulas
        $stats['active_formulas'] = $db->query("SELECT COUNT(*) FROM formulas WHERE status = 'active'")->fetchColumn();
        break;
        
    case 'Transport Officer':
        // Today's deliveries
        $deliveryQuery = "SELECT COUNT(*) as count 
                          FROM orders 
                          WHERE transport_officer_id = " . $_SESSION['user_id'] . " 
                          AND DATE(order_date) = CURDATE()";
        $stats['today_deliveries'] = $db->query($deliveryQuery)->fetchColumn();
        
        // Active vehicles
        $stats['active_vehicles'] = $db->query("SELECT COUNT(*) FROM vehicles WHERE status = 'active'")->fetchColumn();
        break;
}

// Get pending notifications
$notifQuery = "SELECT * FROM notifications 
               WHERE user_id = ? AND is_read = 0 
               ORDER BY created_at DESC LIMIT 5";
$notifStmt = $db->prepare($notifQuery);
$notifStmt->execute([$_SESSION['user_id']]);
$notifications = $notifStmt->fetchAll();
?>

<div class="container-fluid py-4">
    <!-- Welcome Section -->
    <div class="row mb-4">
        <div class="col-12">
            <h1 class="h3 mb-0">
                Welcome back, <?php echo htmlspecialchars($_SESSION['user_name']); ?>!
            </h1>
            <p class="text-muted">
                <?php echo $_SESSION['user_role']; ?> at <?php echo $_SESSION['branch_name']; ?>
                | Last login: <?php echo formatDate($currentUser['last_login'], 'M d, Y H:i'); ?>
            </p>
        </div>
    </div>
    
    <!-- Statistics Cards -->
    <div class="row g-3 mb-4">
        <?php if (isset($stats['today_sales'])): ?>
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Today's Sales</h6>
                            <h3 class="mb-0"><?php echo formatCurrency($stats['today_sales']['total']); ?></h3>
                            <small class="text-success">
                                <i class="fas fa-arrow-up"></i> <?php echo $stats['today_sales']['count']; ?> transactions
                            </small>
                        </div>
                        <div class="fs-1 text-primary opacity-25">
                            <i class="fas fa-chart-line"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php endif; ?>
        
        <?php if ($_SESSION['user_role'] === 'Administrator'): ?>
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Inventory Value</h6>
                            <h3 class="mb-0"><?php echo formatCurrency($stats['inventory_value']); ?></h3>
                            <small class="text-warning">
                                <i class="fas fa-exclamation-triangle"></i> <?php echo $stats['low_stock']; ?> low stock
                            </small>
                        </div>
                        <div class="fs-1 text-success opacity-25">
                            <i class="fas fa-warehouse"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Pending Orders</h6>
                            <h3 class="mb-0"><?php echo $stats['pending_orders']; ?></h3>
                            <small class="text-info">Awaiting approval</small>
                        </div>
                        <div class="fs-1 text-warning opacity-25">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Active Users</h6>
                            <h3 class="mb-0"><?php echo $stats['active_users']; ?></h3>
                            <small class="text-success">System users</small>
                        </div>
                        <div class="fs-1 text-info opacity-25">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php endif; ?>
        
        <?php if ($_SESSION['user_role'] === 'Branch Operator'): ?>
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Branch Stock Value</h6>
                            <h3 class="mb-0"><?php echo formatCurrency($stats['branch_stock_value']); ?></h3>
                            <small>Current inventory</small>
                        </div>
                        <div class="fs-1 text-info opacity-25">
                            <i class="fas fa-store"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Today's Customers</h6>
                            <h3 class="mb-0"><?php echo $stats['today_customers']; ?></h3>
                            <small>Unique customers</small>
                        </div>
                        <div class="fs-1 text-success opacity-25">
                            <i class="fas fa-user-friends"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-lg-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Pending Credits</h6>
                            <h3 class="mb-0"><?php echo formatCurrency($stats['pending_credits']['total']); ?></h3>
                            <small class="text-warning">
                                <?php echo $stats['pending_credits']['count']; ?> unpaid
                            </small>
                        </div>
                        <div class="fs-1 text-warning opacity-25">
                            <i class="fas fa-credit-card"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php endif; ?>
    </div>
    
    <div class="row">
        <!-- Quick Actions -->
        <div class="col-lg-4 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <?php if (hasAccess('pos')): ?>
                            <a href="modules/pos/index.php" class="btn btn-outline-primary text-start">
                                <i class="fas fa-cash-register me-2"></i> New Sale
                            </a>
                        <?php endif; ?>
                        
                        <?php if (hasAccess('orders')): ?>
                            <a href="modules/orders/create.php" class="btn btn-outline-success text-start">
                                <i class="fas fa-plus-circle me-2"></i> Create Order
                            </a>
                        <?php endif; ?>
                        
                        <?php if (hasAccess('production')): ?>
                            <a href="modules/production/start.php" class="btn btn-outline-info text-start">
                                <i class="fas fa-industry me-2"></i> Start Production
                            </a>
                        <?php endif; ?>
                        
                        <?php if (hasAccess('expenses')): ?>
                            <a href="modules/expenses/request.php" class="btn btn-outline-warning text-start">
                                <i class="fas fa-money-bill me-2"></i> Request Expense
                            </a>
                        <?php endif; ?>
                        
                        <?php if (hasAccess('reports')): ?>
                            <a href="modules/reports/daily.php" class="btn btn-outline-secondary text-start">
                                <i class="fas fa-file-alt me-2"></i> Daily Report
                            </a>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Activities -->
        <div class="col-lg-8 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">
                        <i class="fas fa-history text-primary"></i> 
                        <?php echo $_SESSION['user_role'] === 'Administrator' ? 'System Activities' : 'My Recent Activities'; ?>
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Time</th>
                                    <?php if ($_SESSION['user_role'] === 'Administrator'): ?>
                                        <th>User</th>
                                    <?php endif; ?>
                                    <th>Action</th>
                                    <th>Module</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($activities as $activity): ?>
                                <tr>
                                    <td>
                                        <small class="text-muted">
                                            <?php echo formatDate($activity['created_at'], 'H:i'); ?>
                                        </small>
                                    </td>
                                    <?php if ($_SESSION['user_role'] === 'Administrator'): ?>
                                        <td>
                                            <?php echo htmlspecialchars($activity['first_name'] . ' ' . $activity['last_name']); ?>
                                        </td>
                                    <?php endif; ?>
                                    <td>
                                        <span class="badge bg-info">
                                            <?php echo htmlspecialchars($activity['action']); ?>
                                        </span>
                                    </td>
                                    <td><?php echo htmlspecialchars($activity['module']); ?></td>
                                    <td>
                                        <small><?php echo htmlspecialchars($activity['description']); ?></small>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Notifications Section -->
    <?php if (count($notifications) > 0): ?>
    <div class="row">
        <div class="col-12">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-warning bg-opacity-10">
                    <h5 class="mb-0">
                        <i class="fas fa-bell text-warning"></i> Pending Notifications
                    </h5>
                </div>
                <div class="card-body">
                    <div class="list-group list-group-flush">
                        <?php foreach ($notifications as $notif): ?>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-1"><?php echo htmlspecialchars($notif['title']); ?></h6>
                                <p class="mb-1"><?php echo htmlspecialchars($notif['message']); ?></p>
                                <small class="text-muted">
                                    <?php echo formatDate($notif['created_at'], 'M d, Y H:i'); ?>
                                </small>
                            </div>
                            <button class="btn btn-sm btn-outline-primary mark-read" data-id="<?php echo $notif['id']; ?>">
                                Mark as Read
                            </button>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>
</div>

<!-- Dashboard specific JavaScript -->
<script>
$(document).ready(function() {
    // Mark notification as read
    $('.mark-read').click(function() {
        const notifId = $(this).data('id');
        const button = $(this);
        
        $.post('modules/notifications/mark_read.php', {
            id: notifId
        }, function(response) {
            if (response.success) {
                button.closest('.list-group-item').fadeOut();
            }
        }, 'json');
    });
    
    // Auto-refresh dashboard every 5 minutes
    setInterval(function() {
        location.reload();
    }, 300000);
});
</script>

<?php require_once 'includes/footer.php'; ?>
