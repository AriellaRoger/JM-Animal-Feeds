
/**
 * File: assets/js/login.js
 * Path: /feedsjm/assets/js/login.js
 * Description: Login page specific JavaScript
 */

document.addEventListener('DOMContentLoaded', function() {
    // Toggle password visibility
    const togglePassword = document.getElementById('togglePassword');
    const passwordField = document.getElementById('password');
    
    if (togglePassword) {
        togglePassword.addEventListener('click', function() {
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);
            
            // Toggle icon
            const icon = this.querySelector('i');
            icon.classList.toggle('fa-eye');
            icon.classList.toggle('fa-eye-slash');
        });
    }
    
    // Remember me functionality
    const rememberCheckbox = document.getElementById('remember');
    const emailField = document.getElementById('email');
    
    // Check if there's a saved email
    const savedEmail = getCookie('jmfeeds_remember');
    if (savedEmail) {
        emailField.value = savedEmail;
        if (rememberCheckbox) {
            rememberCheckbox.checked = true;
        }
    }
    
    // Form validation
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const email = emailField.value.trim();
            const password = passwordField.value;
            
            if (!email || !password) {
                e.preventDefault();
                showError('Please fill in all fields');
                return false;
            }
            
            if (!validateEmail(email)) {
                e.preventDefault();
                showError('Please enter a valid email address');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                showError('Password must be at least 6 characters');
                return false;
            }
            
            // Show loading state
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Signing in...';
            submitBtn.disabled = true;
        });
    }
    
    // Helper functions
    function validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }
    
    function showError(message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-danger alert-dismissible fade show';
        alertDiv.innerHTML = `
            <i class="fas fa-exclamation-triangle"></i> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        const form = document.getElementById('loginForm');
        form.parentNode.insertBefore(alertDiv, form);
        
        setTimeout(() => {
            alertDiv.remove();
        }, 5000);
    }
    
    function getCookie(name) {
        const value = `; ${document.cookie}`;
        const parts = value.split(`; ${name}=`);
        if (parts.length === 2) return parts.pop().split(';').shift();
    }
});