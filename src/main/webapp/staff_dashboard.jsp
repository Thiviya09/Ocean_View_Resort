<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Dashboard | Ocean View</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
    /* PALETTE REFERENCE:
       Deep Maroon: #561C24
       Rose Wood:   #6D2932
       Sand Tan:    #C7B7A3
       Cream Silk:  #E8D4C4
       Parchment:   #F5E9DF (Card Background)
    */

        :root {
        --deep-maroon: #561C24;
        --rose-wood: #6D2932;
        --sand-tan: #C7B7A3;
        --cream-silk: #E8D4C4;
        --card-bg: #F5E9DF; 
        --text-dark: #3D1419;
        --text-muted: #6D2932;
        --shadow: 0 8px 30px rgba(86, 28, 36, 0.12);
    }

    /* Scrollbar Styling for Luxury Feel */
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: var(--cream-silk); }
    ::-webkit-scrollbar-thumb { background: var(--sand-tan); border-radius: 10px; }
    ::-webkit-scrollbar-thumb:hover { background: var(--rose-wood); }

    body { 
        margin: 0; 
        font-family: 'Montserrat', sans-serif; 
        background-color: var(--cream-silk); 
        color: var(--text-dark);
        display: flex;
        min-height: 100vh;
    }

    /* --- SIDEBAR --- */
    .sidebar {
        width: 260px; /* Matched to Admin Dashboard */
        height: 100vh;
        background: #561C24; /* Deep Maroon */
        color: #E8D4C4;
        position: fixed;
        top: 0;
        left: 0;
        display: flex;
        flex-direction: column;
        box-shadow: 4px 0 15px rgba(0,0,0,0.2);
        z-index: 100;
    }

    .sidebar h2 {
        padding: 40px 20px;
        text-align: center;
        font-family: 'Playfair Display', serif;
        font-size: 1.8rem;
        letter-spacing: 2px;
        color: #E8D4C4;
        text-transform: uppercase;
        border-bottom: 1px solid rgba(199, 183, 163, 0.2);
        margin: 0;
    }

    .sidebar a {
        display: flex;
        align-items: center;
        padding: 16px 28px;
        color: #C7B7A3; /* Sand Tan */
        text-decoration: none;
        transition: all 0.3s ease;
        font-weight: 500;
        font-size: 0.95rem;
        letter-spacing: 0.5px;
    }

    .sidebar a i {
        margin-right: 15px;
        width: 25px;
        font-size: 1.2rem;
    }

    .sidebar a:hover, .sidebar a.active {
        background: #6D2932; /* Rose Wood */
        color: #ffffff;
        padding-left: 35px;
    }

    .system-status {
            padding: 20px; background: rgba(0,0,0,0.15); color: var(--sand);
            font-size: 0.8rem; border-top: 1px solid rgba(199, 183, 163, 0.1); margin-top: auto;
        }

    /* --- MAIN CONTENT --- */
    .main-content {
        margin-left: 260px;
        padding: 50px;
        width: calc(100% - 260px);
        background-color: var(--cream-silk);
    }

    .header-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 45px;
    }

    .welcome-text h1 {
        margin: 0;
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem;
        color: var(--deep-maroon);
    }

    .welcome-text p {
        margin: 8px 0 0;
        color: var(--rose-wood);
        font-weight: 400;
        font-size: 1.1rem;
    }

    /* --- STAT CARDS --- */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
        gap: 30px;
        margin-bottom: 50px;
    }

    .stat-card {
        background: var(--card-bg); 
        padding: 30px;
        border-radius: 15px;
        box-shadow: var(--shadow);
        display: flex;
        align-items: center;
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        border: 1px solid rgba(199, 183, 163, 0.5);
    }

    .stat-card:hover {
        transform: translateY(-8px);
        background: #FDF5EE; /* Slight glow */
        border-color: var(--sand-tan);
    }

    .stat-icon {
        width: 65px;
        height: 65px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.6rem;
        margin-right: 22px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    /* Contextual Icon Colors */
    .bg-res { background: #EBD9D9; color: var(--deep-maroon); }
    .bg-gst { background: #E1E8ED; color: #2C3E50; }
    .bg-stf { background: #F2EBE1; color: var(--rose-wood); }
    .bg-rev { background: #E2EDE2; color: #2E7D32; }

    .stat-info h3 {
        margin: 0;
        font-size: 0.8rem;
        color: var(--rose-wood);
        text-transform: uppercase;
        letter-spacing: 1.5px;
        opacity: 0.8;
    }

    .stat-info p {
        margin: 5px 0 0;
        font-size: 1.7rem;
        font-weight: 700;
        color: var(--deep-maroon);
        font-family: 'Playfair Display', serif;
    }

    /* --- CONTENT CARDS --- */
    .content-card {
        background: var(--card-bg);
        border-radius: 18px;
        padding: 35px;
        box-shadow: var(--shadow);
        border: 1px solid rgba(199, 183, 163, 0.4);
        margin-bottom: 30px;
    }

    .content-card h2 {
        margin-top: 0;
        font-family: 'Playfair Display', serif;
        font-size: 1.6rem;
        color: var(--deep-maroon);
        border-bottom: 2px solid var(--sand-tan);
        padding-bottom: 18px;
        margin-bottom: 25px;
    }

    /* Quick Action Links */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
        gap: 20px;
    }

    .action-link {
        text-align: center;
        padding: 25px 15px;
        background: var(--cream-silk);
        border-radius: 12px;
        text-decoration: none;
        color: var(--deep-maroon);
        font-weight: 600;
        transition: all 0.3s ease;
        border: 1px solid var(--sand-tan);
    }

    .action-link i { font-size: 1.5rem; margin-bottom: 10px; display: block; }

    .action-link:hover {
        background: var(--rose-wood);
        color: #ffffff;
        transform: scale(1.03);
        box-shadow: 0 5px 15px rgba(86, 28, 36, 0.2);
    }

    /* --- LIVE STATUS WIDGET --- */
    .live-status-container {
        display: flex; 
        gap: 30px; 
        text-align: center; 
        padding: 15px 0;
    }

    .status-box { flex: 1; padding: 10px; }
    .status-box:not(:last-child) { border-right: 2px solid var(--sand-tan); }
    
    .status-box .val { 
        font-size: 2.8rem; 
        font-weight: bold; 
        font-family: 'Playfair Display', serif;
        margin-bottom: 5px;
    }
    .status-box .label { 
        font-size: 0.85rem; 
        color: var(--rose-wood); 
        letter-spacing: 2px; 
        font-weight: 600;
    }

    /* --- CHARTS --- */
    canvas {
        background: rgba(232, 212, 196, 0.3); /* Subtle blend with background */
        border-radius: 12px;
        padding: 15px;
    }

    /* Responsive Adjustments */
    @media (max-width: 1024px) {
        .main-content { padding: 30px; }
        .stats-grid { gap: 20px; }
    }
</style>
</head>
<body>

    <div class="sidebar">
            <div class="sidebar-menu">
                <h2>OCEAN VIEW</h2>
                <a href="${sessionScope.role == 'admin' ? 'admin_dashboard.jsp' : 'staff_dashboard.jsp'}">
                    <i class="fa fa-home"></i> Dashboard
                </a>
                <a href="manage-reservation"><i class="fa fa-bed"></i> Reservations</a>
                <a href="manage_guests.jsp"><i class="fa fa-users"></i> Guests</a>

                

                <a href="<%= request.getContextPath() %>/room"><i class="fa fa-door-closed"></i> Rooms</a>

                <a href="manage_bills.jsp"><i class="fa fa-file-invoice-dollar"></i> Billing & Revenue</a>

                <a href="logout"><i class="fa fa-sign-out-alt"></i> Logout</a>
            </div>
             <div class="system-status">
                <span style="display: inline-block; width: 10px; height: 10px; background: #28a745; border-radius: 50%; margin-right: 5px;"></span>
                <small>System Live: <%= new java.text.SimpleDateFormat("HH:mm").format(new java.util.Date()) %></small>
            </div>
        </div>

    <div class="main-content">
    <div class="header-bar">
        <div class="welcome-text">
            <h1>Welcome back, ${sessionScope.user.fullname}</h1>
            <p>Your shift started at <%= new java.text.SimpleDateFormat("hh:mm a").format(new java.util.Date()) %></p>
        </div>
        <div class="date-display">
            <span id="current-date" style="font-weight: 600; color: var(--deep-maroon);"></span>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon bg-res"><i class="fa fa-calendar-check"></i></div>
            <div class="stat-info">
                <h3>Today's Arrivals</h3>
                <p>12 Arrivals</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-gst"><i class="fa fa-door-open"></i></div>
            <div class="stat-info">
                <h3>Available Rooms</h3>
                <p>08 Units</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-rev"><i class="fa fa-user-clock"></i></div>
            <div class="stat-info">
                <h3>Pending Invoices</h3>
                <p>04 Drafts</p>
            </div>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px;">
        
        <div class="content-card">
            <h2><i class="fa fa-bolt" style="margin-right: 10px; font-size: 1.2rem;"></i> Primary Operations</h2>
            <div class="quick-actions">
                <a href="manage-reservation" class="action-link">
                    <i class="fa fa-plus-circle"></i>
                    <span>New Booking</span>
                </a>
                <a href="manage_guests.jsp" class="action-link">
                    <i class="fa fa-address-book"></i>
                    <span>Guest Registry</span>
                </a>
                <a href="<%= request.getContextPath() %>/room" class="action-link">
                    <i class="fa fa-key"></i>
                    <span>Room Status</span>
                </a>
<!--                <a href="manage_bills.jsp" class="action-link">
                    <i class="fa fa-file-invoice"></i>
                    <span>Quick Bill</span>
                </a>-->
            </div>
        </div>

        <div class="content-card">
            <h2><i class="fa fa-bell" style="margin-right: 10px; font-size: 1.2rem;"></i> Shift Notes</h2>
            <ul style="list-style: none; padding: 0; font-size: 0.9rem; color: var(--text-muted);">
                <li style="margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                    <i class="fa fa-circle" style="font-size: 0.5rem; color: #28a745;"></i>
                    System is up to date
                </li>
                <li style="margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                    <i class="fa fa-circle" style="font-size: 0.5rem; color: #ffc107;"></i>
                    Check room 302 for maintenance
                </li>
                <li style="margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                    <i class="fa fa-circle" style="font-size: 0.5rem; color: var(--sand-tan);"></i>
                    New Guest Policy effective today
                </li>
            </ul>
        </div>

    </div>

    <div class="content-card">
        <div class="live-status-container">
            <div class="status-box">
                <div class="val">85%</div>
                <div class="label">Occupancy Rate</div>
            </div>
            <div class="status-box">
                <div class="val">02</div>
                <div class="label">VIP Check-ins</div>
            </div>
            <div class="status-box">
                <div class="val">14</div>
                <div class="label">Housekeeping Done</div>
            </div>
        </div>
    </div>
</div>

<script>
    // Professional Date Display
    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    document.getElementById('current-date').textContent = new Date().toLocaleDateString(undefined, options);
</script>

</body>
</html>