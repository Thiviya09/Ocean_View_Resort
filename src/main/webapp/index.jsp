<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort | Staff Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --deep-maroon: #561C24;
            --rose-wood: #6D2932;
            --sand-tan: #C7B7A3;
            --cream-silk: #E8D4C4;
            --white: #ffffff;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; font-family: 'Montserrat', sans-serif; background: var(--cream-silk); color: var(--deep-maroon); }

        .container { display: flex; min-height: 100vh; }

        /* Left Section: Branding */
        .left-section {
            flex: 1.2;
            background: linear-gradient(rgba(86, 28, 36, 0.9), rgba(109, 41, 50, 0.5)), 
                        url('https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=1000');
            background-size: cover;
            background-position: center;
            color: var(--cream-silk);
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px;
            box-shadow: 10px 0 30px rgba(0,0,0,0.2);
        }

        .left-section h1 {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            margin-bottom: 20px;
            letter-spacing: 1px;
        }

        .left-section p {
            font-size: 1.1rem;
            margin-bottom: 40px;
            line-height: 1.8;
            font-weight: 300;
            border-left: 3px solid var(--sand-tan);
            padding-left: 20px;
        }

        .guide-trigger {
            align-self: flex-start;
            padding: 12px 25px;
            background: var(--sand-tan);
            color: var(--deep-maroon);
            border: none;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .guide-trigger:hover { background: var(--white); transform: scale(1.05); }

        /* Right Section: Login */
        .right-section {
            flex: 0.8;
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--cream-silk);
        }

        .login-card {
            background: var(--white);
            width: 420px;
            padding: 50px;
            border-radius: 5px; /* Minimalist sharp luxury look */
            box-shadow: 0 15px 35px rgba(86, 28, 36, 0.1);
            border-top: 5px solid var(--deep-maroon);
        }

        .login-card h2 {
            text-align: center;
            margin-bottom: 35px;
            font-family: 'Playfair Display', serif;
            color: var(--deep-maroon);
        }

        .input-group { position: relative; margin-bottom: 25px; }
        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--rose-wood);
        }

        .input-group input {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 1px solid #ddd;
            background: #fafafa;
            border-radius: 4px;
            transition: 0.3s;
        }

        .input-group input:focus { border-color: var(--rose-wood); outline: none; background: #fff; }

        .btn-login {
            width: 100%;
            padding: 15px;
            background: var(--deep-maroon);
            color: var(--white);
            border: none;
            font-weight: 600;
            letter-spacing: 1px;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-login:hover { background: var(--rose-wood); }

        /* MODAL STYLES */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0; width: 100%; height: 100%;
            background: rgba(86, 28, 36, 0.8);
            backdrop-filter: blur(5px);
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: var(--white);
            width: 700px;
            border-radius: 12px;
            overflow: hidden;
            animation: fadeIn 0.4s ease;
        }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .modal-header {
            background: var(--deep-maroon);
            color: var(--cream-silk);
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-body { padding: 40px; }
        
        .step { display: flex; gap: 20px; margin-bottom: 25px; }
        .step-num {
            width: 40px; height: 40px; background: var(--sand-tan);
            border-radius: 50%; display: flex; align-items: center; 
            justify-content: center; font-weight: bold; flex-shrink: 0;
        }

        .step-text h4 { color: var(--deep-maroon); margin-bottom: 5px; }
        .step-text p { font-size: 0.9rem; color: #666; }

        .close-btn { cursor: pointer; font-size: 1.5rem; }

        @media (max-width: 900px) { .container { flex-direction: column; } }
    </style>
</head>
<body>

<div class="container">
    <div class="left-section">
        <h1>Ocean View Resort</h1>
        <p>A sophisticated management interface designed for excellence. Authenticate to access reservations, guest relations, and financial oversight.</p>
        
        <button class="guide-trigger" onclick="toggleModal(true)">
            <i class="fa fa-book-open"></i> New Staff? View System Guide
        </button>
    </div>

    <div class="right-section">
        <div class="login-card">
            <h2>Portal Access</h2>
            <form action="login" method="post">
                <div class="input-group">
                    <i class="fa fa-user-circle"></i>
                    <input type="text" name="username" placeholder="Username" required>
                </div>
                <div class="input-group">
                    <i class="fa fa-key"></i>
                    <input type="password" name="password" placeholder="Password" required>
                </div>
                <button type="submit" class="btn-login"><i class="fa-solid fa-arrow-right-to-bracket"></i> SIGN IN</button>
                
                <c:if test="${not empty error}">
                    <p style="color:#C8102E; margin-top:15px; text-align:center; font-size:0.9rem;">
                        <i class="fa fa-exclamation-circle"></i> ${error}
                    </p>
                </c:if>
            </form>
        </div>
    </div>
</div>

<div id="guideModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa fa-map-signs"></i> Staff Operations Guide</h3>
            <span class="close-btn" onclick="toggleModal(false)">&times;</span>
        </div>
        <div class="modal-body">
            <div class="step">
                <div class="step-num">1</div>
                <div class="step-text">
                    <h4>Reservations</h4>
                    <p>Navigate to 'Manage Reservations' to create a new booking. Ensure you check room availability first to avoid conflicts.</p>
                </div>
            </div>
            <div class="step">
                <div class="step-num">2</div>
                <div class="step-text">
                    <h4>Guest Registration</h4>
                    <p>Always verify Guest ID and Email. The system uses the email to send automated PDF invoices once payment is processed.</p>
                </div>
            </div>
            <div class="step">
                <div class="step-num">3</div>
                <div class="step-text">
                    <h4>Billing & Invoicing</h4>
                    <p>Click the 'Bill' button on a confirmed reservation. Add food charges or discounts. Mark as 'Paid' to finalize the transaction.</p>
                </div>
            </div>
            <div class="step">
                <div class="step-num">4</div>
                <div class="step-text">
                    <h4>Room Management</h4>
                    <p>Use the Rooms section to add or update rooms, manage room types, search by room number, type, or AC category, and check room availability.</p>
                </div>
            </div>
            <div class="step">
                <div class="step-num">5</div>
                <div class="step-text">
                    <h4>Dashboard Monitoring</h4>
                    <p>Use the Dashboard to track real-time revenue trends and room occupancy rates throughout the day.</p>
                </div>
            </div>
            <button class="btn-login" style="margin-top:20px;" onclick="toggleModal(false)">Got it, let's work!</button>
        </div>
    </div>
</div>


<script>
    function toggleModal(show) {
        document.getElementById('guideModal').style.display = show ? 'flex' : 'none';
    }

    // Close on outside click
    window.onclick = function(event) {
        let modal = document.getElementById('guideModal');
        if (event.target == modal) toggleModal(false);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    /* Styling for the toast to match your Deep Maroon theme */
    .swal2-toast-maroon {
        background: #561C24 !important;
        color: #E8D4C4 !important;
    }
    .input-error {
        border: 1.5px solid #C8102E !important;
        background: #fff0f0 !important;
    }
</style>

<!--<form id="loginForm" action="login" method="post" onsubmit="return validateLogin(event)">
    <div class="input-group">
        <i class="fa fa-user-circle"></i>
        <input type="text" id="username" name="username" placeholder="Employee Username">
    </div>
    <div class="input-group">
        <i class="fa fa-key"></i>
        <input type="password" id="password" name="password" placeholder="Password">
    </div>
    <button type="submit" class="btn-login">SIGN IN</button>
</form>-->

<script>
    // 1. Toast Notification Setup
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        customClass: {
            popup: 'swal2-toast-maroon'
        }
    });

    // 2. Client-side Validation
    function validateLogin(event) {
        const user = document.getElementById('username');
        const pass = document.getElementById('password');
        let isValid = true;

        // Reset styles
        user.classList.remove('input-error');
        pass.classList.remove('input-error');

        if (user.value.trim() === "") {
            user.classList.add('input-error');
            isValid = false;
        }
        if (pass.value.trim() === "") {
            pass.classList.add('input-error');
            isValid = false;
        }

        if (!isValid) {
            event.preventDefault(); // Stop form submission
            Toast.fire({
                icon: 'warning',
                title: 'Please enter both username and password'
            });
        }
        return isValid;
    }

    // 3. Handle Server-side Errors (Redirects/Forwards)
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        
        // If Servlet used response.sendRedirect("index.jsp?error=1")
        if (urlParams.has('error')) {
            Toast.fire({
                icon: 'error',
                title: 'Authentication Failed',
                text: 'Invalid username or password'
            });
        }

        // If Servlet used request.setAttribute("error", "message") and forward
        const serverError = "${error}"; 
        if (serverError && serverError !== "") {
            Toast.fire({
                icon: 'error',
                title: 'Access Denied',
                text: serverError
            });
        }
    };
</script>
</body>
</html>