<%@ page import="jakarta.servlet.http.*" %>
<%@ page session="true" %>
<%
    // Security Check
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Ocean View Resort</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

<!--    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Ocean View</h2>
        </div>
        <div class="sidebar-menu">
            <a href="admin_dashboard.jsp" class="active"><i class="fa fa-home"></i> Dashboard</a>
            <a href="manage-reservation"><i class="fa fa-calendar-check"></i> Reservations</a>
            <a href="manage_guests.jsp"><i class="fa fa-users"></i> Guests</a>
            <a href="manage_staff.jsp"><i class="fa fa-user-tie"></i> Staff</a>
            <a href="<%= request.getContextPath() %>/room"><i class="fa fa-door-open"></i> Rooms</a>
            <a href="manage_bills.jsp"><i class="fa fa-file-invoice-dollar"></i> Billing</a>
            
            <div style="margin-top: auto;">
                <a href="logout" style="color: var(--sand-tan);"><i class="fa fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        <div class="system-status">
            <span style="display: inline-block; width: 10px; height: 10px; background: #28a745; border-radius: 50%; margin-right: 5px;"></span>
            <small>System Live: <%= new java.text.SimpleDateFormat("HH:mm").format(new java.util.Date()) %></small>
        </div>
    </div>-->
    <div class="sidebar">
        <div class="sidebar-menu">
            <h2>OCEAN VIEW</h2>
            <a href="${sessionScope.role == 'admin' ? 'admin_dashboard.jsp' : 'staff_dashboard.jsp'}">
                <i class="fa fa-home"></i> Dashboard
            </a>
            <a href="manage-reservation"><i class="fa fa-bed"></i> Reservations</a>
            <a href="manage_guests.jsp"><i class="fa fa-users"></i> Guests</a>

            <c:if test="${sessionScope.role == 'admin'}">
                <a href="manage_staff.jsp"><i class="fa fa-user-tie"></i> Staff</a>
            </c:if>

            <a href="<%= request.getContextPath() %>/room"><i class="fa fa-door-closed"></i> Rooms</a>

            <c:if test="${sessionScope.role == 'admin'}">
                <a href="manage_bills.jsp"><i class="fa fa-file-invoice-dollar"></i> Billing & Revenue</a>
            </c:if>

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
                <h1>Dashboard Overview</h1>
                <p>Hello,  ${sessionScope.user.fullname}. Here's what's happening today.</p>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon bg-res"><i class="fa fa-calendar-check"></i></div>
                <div class="stat-info">
                    <h3>Reservations</h3>
                    <p id="count-res">...</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon bg-gst"><i class="fa fa-users"></i></div>
                <div class="stat-info">
                    <h3>Total Guests</h3>
                    <p id="count-gst">...</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon bg-stf"><i class="fa fa-user-tie"></i></div>
                <div class="stat-info">
                    <h3>Active Staff</h3>
                    <p id="count-stf">...</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon bg-rev"><i class="fa fa-money-bill-wave"></i></div>
                <div class="stat-info">
                    <h3>Total Revenue</h3>
                    <p id="count-rev">LKR 0.00</p>
                </div>
            </div>
        </div>

        <div class="content-card">
            <h2>Quick Management Links</h2>
            <div class="quick-actions">
                <a href="manage-reservation" class="action-link"><i class="fa-solid fa-door-open"></i><br>New Booking</a>
                <a href="manage_bills.jsp" class="action-link"><i class="fa fa-print"></i><br>Invoices</a>
                <a href="manage_guests.jsp" class="action-link"><i class="fa fa-user-plus"></i><br>Add Guest</a>
                <a href="<%= request.getContextPath() %>/room" class="action-link"><i class="fa fa-key"></i><br>Room Status</a>
            </div>
        </div>

        <div class="content-card" style="margin-top: 30px;">
            <h2>Live Reservation</h2>
            <div class="live-status-container">
                <div class="status-box">
                    <div id="reserv-conf" class="val" style="color: #28a745;">0</div>
                    <div class="label">CONFIRMED</div>
                </div>
                <div class="status-box">
                    <div id="reserv-pen" class="val" style="color: var(--rose-wood);">0</div>
                    <div class="label">PENDING</div>
                </div>
                <div class="status-box">
                    <div id="reserv-can" class="val" style="color: #666;">0</div>
                    <div class="label">CANCELLED</div>
                </div>
            </div>
        </div>
            
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 25px; margin-top: 30px;">
            <div class="content-card">
                <h2>Daily Revenue Trend (Current Month)</h2> <canvas id="revenueChart" height="100"></canvas>
            </div>

            <div class="content-card">
                <h2>Booking Distribution</h2>
                <canvas id="roomTypeChart"></canvas>
            </div>
        </div>
        </div>
            
            <style>.progress-bar {
    width: 100%;
    height: 12px;
    background: #E8D4C4;
    border-radius: 10px;
    overflow: hidden;
    margin-top: 5px;
}
.progress-bar div {
    height: 100%;
    transition: width 1s ease-in-out;
}</style>

    <script>
        
        let revenueChart, roomTypeChart; // Declare globally to update them later

async function fetchDashboardStats() {
    try {
        const response = await fetch("/Ocean_View_Resort/api/dashboard-stats/");
        const data = await response.json();

        if (data.error) return;

        // --- Update Top Counters ---
        document.getElementById("count-res").innerText = data.reservations || 0;
        document.getElementById("count-gst").innerText = data.guests || 0;
        document.getElementById("count-stf").innerText = data.staff || 0;
        document.getElementById("count-rev").innerText = "LKR " + (parseFloat(data.revenue) || 0).toLocaleString();

        // --- Update Live Status ---
        document.getElementById("reserv-conf").innerText = data.confirmed_reservation || 0;
        document.getElementById("reserv-pen").innerText = data.pending_reservation || 0;
        document.getElementById("reserv-can").innerText = data.cancelled_reservation || 0;

        // --- Update Revenue Trend (Line Chart) ---
                // --- Update Daily Revenue Trend (Line Chart) ---
        if (data.revenueTrend && data.revenueTrend.length > 0) {
            // console.log(data.revenueTrend); // Uncomment this to see if data is arriving in browser console
            const labels = data.revenueTrend.map(row => row.label);
            const values = data.revenueTrend.map(row => row.amount);

            revenueChart.data.labels = labels;
            revenueChart.data.datasets[0].data = values;

            const currentMonth = new Date().toLocaleString('default', { month: 'long' });
            revenueChart.data.datasets[0].label = `Revenue in ${currentMonth} (LKR)`;

            revenueChart.update();
        } else {
            // If no revenue exists for the current month yet
            revenueChart.data.labels = ["No Data"];
            revenueChart.data.datasets[0].data = [0];
            revenueChart.update();
        }

        // --- Update Room Distribution (Pie Chart) ---
        if (data.roomTypeData) {
            const labels = data.roomTypeData.map(row => row.label);
            const values = data.roomTypeData.map(row => row.value);
            
            roomTypeChart.data.labels = labels;
            roomTypeChart.data.datasets[0].data = values;
            roomTypeChart.update();

            // --- Update Progress Bars (Occupancy) ---
            const totalRooms = values.reduce((a, b) => a + b, 0);
            data.roomTypeData.forEach(item => {
                let percent = ((item.value / totalRooms) * 100).toFixed(0);
                if (item.label.toLowerCase().includes("deluxe")) {
                    document.getElementById("bar-deluxe").style.width = percent + "%";
                } else if (item.label.toLowerCase().includes("standard")) {
                    document.getElementById("bar-standard").style.width = percent + "%";
                }
            });
        }

    } catch (error) {
        console.error("Dashboard Error:", error);
    }
}

function initCharts() {
    // Initial Revenue Chart (Empty or Placeholders)
    const revCtx = document.getElementById('revenueChart').getContext('2d');
    revenueChart = new Chart(revCtx, {
        type: 'line',
        data: {
            labels: [], // Will be filled by API
            datasets: [{
                label: 'Monthly Revenue (LKR)',
                data: [], 
                borderColor: '#561C24',
                backgroundColor: 'rgba(86, 28, 36, 0.1)',
                fill: true
            }]
        }
    });

    // Initial Room Distribution Chart
    const roomCtx = document.getElementById('roomTypeChart').getContext('2d');
    roomTypeChart = new Chart(roomCtx, {
        type: 'pie',
        data: {
            labels: [],
            datasets: [{
                data: [],
                backgroundColor: ['#561C24', '#6D2932', '#C7B7A3']
            }]
        }
    });
}

function updateRevenueChart(trendData) {
    // trendData format: { "Jan": 100, "Feb": 200 }
    revenueChart.data.labels = Object.keys(trendData);
    revenueChart.data.datasets[0].data = Object.values(trendData);
    revenueChart.update();
}

function updateRoomChart(distData) {
    // distData format: { "Deluxe": 10, "Suite": 5 }
    roomTypeChart.data.labels = Object.keys(distData);
    roomTypeChart.data.datasets[0].data = Object.values(distData);
    roomTypeChart.update();
}

// Start
initCharts();
fetchDashboardStats();
// Optional: Auto-refresh every 30 seconds
setInterval(fetchDashboardStats, 30000);
    </script>
</body>
</html>