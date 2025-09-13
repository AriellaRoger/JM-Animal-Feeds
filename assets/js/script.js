
/**
 * File: assets/js/script.js
 * Path: /feedsjm/assets/js/script.js
 * Description: Main JavaScript file for common functionality
 */

// Common JavaScript functions
$(document).ready(function() {
    // Initialize DataTables on all tables with class 'datatable'
    $('.datatable').DataTable({
        responsive: true,
        pageLength: 25,
        language: {
            search: "Search:",
            lengthMenu: "Show _MENU_ entries",
            info: "Showing _START_ to _END_ of _TOTAL_ entries",
            paginate: {
                first: "First",
                last: "Last",
                next: "Next",
                previous: "Previous"
            }
        }
    });
    
    // Confirm delete actions
    $('.delete-confirm').click(function(e) {
        e.preventDefault();
        const href = $(this).attr('href');
        
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = href;
            }
        });
    });
    
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        $('.alert').not('.alert-permanent').fadeOut('slow');
    }, 5000);
    
    // Form validation
    $('form.needs-validation').on('submit', function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        $(this).addClass('was-validated');
    });
    
    // Print functionality
    $('.btn-print').click(function() {
        window.print();
    });
    
    // Export to Excel functionality
    $('.btn-export-excel').click(function() {
        const table = $(this).data('table');
        const filename = $(this).data('filename') || 'export';
        
        // Simple Excel export (you can enhance this)
        const uri = 'data:application/vnd.ms-excel;base64,';
        const template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>';
        
        const base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))); };
        const format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }); };
        
        const ctx = {
            worksheet: filename,
            table: $(table).html()
        };
        
        const link = document.createElement('a');
        link.download = filename + '.xls';
        link.href = uri + base64(format(template, ctx));
        link.click();
    });
});

// Format number with thousand separators
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Show loading spinner
function showLoader() {
    $('body').append('<div class="spinner-overlay"><div class="spinner-border text-light" role="status"><span class="visually-hidden">Loading...</span></div></div>');
}

// Hide loading spinner
function hideLoader() {
    $('.spinner-overlay').remove();
}

// AJAX error handler
function handleAjaxError(xhr, status, error) {
    hideLoader();
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'An error occurred. Please try again later.'
    });
    console.error('AJAX Error:', status, error);
}

// Format date
function formatDate(date) {
    const d = new Date(date);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[d.getMonth()] + ' ' + d.getDate() + ', ' + d.getFullYear();
}

// Debounce function for search inputs
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}
