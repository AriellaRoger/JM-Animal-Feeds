<?php
/**
 * File: includes/footer.php
 * Path: /feedsjm/includes/footer.php
 * Description: Common footer file for all pages
 */
?>
    </div> <!-- End main-content -->
    
    <!-- Footer -->
    <footer class="footer mt-auto py-3 bg-light">
        <div class="container text-center">
            <span class="text-muted">
                &copy; <?php echo date('Y'); ?> JM Animal Feeds. All rights reserved. | 
                Version 1.0 | 
                <a href="#" data-bs-toggle="modal" data-bs-target="#supportModal">Support</a>
            </span>
        </div>
    </footer>
    
    <!-- Support Modal -->
    <div class="modal fade" id="supportModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Support Information</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Technical Support:</strong></p>
                    <p>Email: support@jmfeeds.co.tz<br>
                    Phone: +255 123 456 789<br>
                    Hours: Monday-Friday 8:00 AM - 5:00 PM EAT</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Custom JS -->
    <script src="<?php echo ASSETS_PATH; ?>/js/script.js"></script>
    
    <?php if (isset($additionalJS)): ?>
        <?php foreach ($additionalJS as $js): ?>
            <script src="<?php echo ASSETS_PATH; ?>/js/<?php echo $js; ?>"></script>
        <?php endforeach; ?>
    <?php endif; ?>
    
    <script>
        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });
        
        // Session timeout warning
        let warningTimer;
        let timeoutTimer;
        
        function resetTimers() {
            clearTimeout(warningTimer);
            clearTimeout(timeoutTimer);
            
            // Show warning 5 minutes before timeout
            warningTimer = setTimeout(function() {
                Swal.fire({
                    title: 'Session Expiring',
                    text: 'Your session will expire in 5 minutes. Do you want to continue?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Continue Working',
                    cancelButtonText: 'Logout'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Make AJAX call to refresh session
                        $.get('refresh_session.php');
                        resetTimers();
                    } else {
                        window.location.href = 'logout.php';
                    }
                });
            }, <?php echo (SESSION_TIMEOUT - 300) * 1000; ?>); // 5 minutes before timeout
            
            // Auto logout after timeout
            timeoutTimer = setTimeout(function() {
                window.location.href = 'logout.php?timeout=1';
            }, <?php echo SESSION_TIMEOUT * 1000; ?>);
        }
        
        // Reset timers on user activity
        document.addEventListener('click', resetTimers);
        document.addEventListener('keypress', resetTimers);
        
        // Initialize timers
        resetTimers();
    </script>
</body>
</html>