<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Bills | Ocean View Resort</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
    /* PALETTE:
       - Deep Maroon: #561C24 (Sidebar / Primary Headers)
       - Rose Wood:   #6D2932 (Accents / Hover States)
       - Sand Tan:    #C7B7A3 (Borders / Muted Text)
       - Cream Silk:  #E8D4C4 (Main Background)
       - Parchment:   #F5E9DF (Card Backgrounds)
    */

    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap');

    /* --- BASE RESET --- */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
        font-family: 'Montserrat', sans-serif;
        background-color: #E8D4C4;
        display: flex;
        color: #3D1419;
        min-height: 100vh;
    }

    /* --- SIDEBAR --- */
    .sidebar {
        width: 250px;
        min-height: 100vh;
        background: #561C24;
        color: #E8D4C4;
        position: fixed;
        top: 0; left: 0;
        display: flex;
        flex-direction: column;
        padding-top: 20px;
        box-shadow: 4px 0 15px rgba(0,0,0,0.2);
        z-index: 100;
    }

    .sidebar h2 {
        padding: 20px;
        text-align: center;
        font-family: 'Playfair Display', serif;
        font-size: 1.5rem;
        letter-spacing: 2px;
        color: #E8D4C4;
        text-transform: uppercase;
        border-bottom: 1px solid rgba(199, 183, 163, 0.2);
        margin-bottom: 20px;
    }

    .sidebar a {
        display: flex;
        align-items: center;
        padding: 15px 25px;
        color: #C7B7A3;
        text-decoration: none;
        transition: 0.3s;
        font-weight: 600;
        font-size: 0.9rem;
    }

    .sidebar a i { margin-right: 15px; width: 20px; text-align: center; }

    .sidebar a:hover {
        background: #6D2932;
        color: #ffffff;
        padding-left: 30px;
    }

    /* --- MAIN CONTENT --- */
    .main {
        margin-left: 250px;
        padding: 40px;
        width: calc(100% - 250px);
    }
    
    h1 {
        color: #561C24;
        font-family: 'Playfair Display', serif;
        font-size: 2.2rem;
        margin-bottom: 30px;
    }

    /* --- STAT CARDS --- */
/*    .stats-container {
        display: flex;
        gap: 20px;
        margin-bottom: 35px;
    }

    .stat-card {
        flex: 1;
        background: #F5E9DF;
        padding: 25px;
        border-radius: 15px;
        box-shadow: 0 8px 20px rgba(86, 28, 36, 0.1);
        border-left: 6px solid #561C24;
        transition: transform 0.3s ease;
    }

    .stat-card:hover { transform: translateY(-5px); }

    .stat-card h3 {
        margin: 0;
        color: #6D2932;
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        font-weight: 700;
    }

    .stat-card p {
        margin: 12px 0 0;
        font-size: 1.6rem;
        font-weight: 700;
        color: #3D1419;
    }

    .stat-card.stat-paid { border-left-color: #2E7D32; }
    .stat-card.stat-pending { border-left-color: #ef6c00; }*/

    /* --- FILTERS & CONTROLS --- */
    .controls {
        display: flex;
        justify-content: flex-start;
        margin-bottom: 20px;
    }

    select {
        padding: 12px 20px;
        border-radius: 10px;
        border: 1px solid #C7B7A3;
        background: #F5E9DF;
        color: #561C24;
        font-family: 'Montserrat', sans-serif;
        font-weight: 600;
        cursor: pointer;
        outline: none;
        transition: 0.3s;
    }

    select:hover { border-color: #561C24; }

    /* --- DATA TABLE CARD --- */
    .card {
        background: #F5E9DF;
        padding: 25px;
        border-radius: 18px;
        box-shadow: 0 8px 30px rgba(86, 28, 36, 0.08);
        border: 1px solid rgba(199, 183, 163, 0.4);
        overflow: hidden;
    }

    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }

    th {
        background: #561C24;
        color: #E8D4C4;
        padding: 18px 15px;
        text-align: left;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-weight: 700;
    }

    td {
        padding: 18px 15px;
        border-bottom: 1px solid rgba(199, 183, 163, 0.4);
        color: #3D1419;
        font-size: 0.9rem;
        vertical-align: middle;
    }

    tr:last-child td { border-bottom: none; }
    tr:hover td { background: rgba(199, 183, 163, 0.1); }

    /* --- STATUS BADGES --- */
    .status-badge {
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 0.7rem;
        font-weight: 800;
        text-transform: uppercase;
        display: inline-block;
    }

    .status-paid { background: #2E7D32; color: #ffffff; }
    .status-pending { background: #ef6c00; color: #ffffff; }

    /* --- ACTION BUTTONS --- */
    .btn-icon {
        font-size: 1.2rem;
        margin-right: 15px;
        cursor: pointer;
        transition: 0.3s;
        text-decoration: none;
        display: inline-block;
    }

    .btn-icon:hover { transform: scale(1.2); }
    
    .fa-print { color: #561C24; }
    .fa-download { color: #2E7D32; }
    .fa-paper-plane { 
        color: #007bff; 
        border: none; 
        background: none; 
        padding: 0; 
        font-size: 1.1rem; 
    }

    /* --- SCROLLBAR FOR CARD --- */
    .card::-webkit-scrollbar { width: 8px; }
    .card::-webkit-scrollbar-thumb { background: #C7B7A3; border-radius: 10px; }

    /* --- RESPONSIVE --- */
    @media(max-width: 992px) {
        .stats-container { flex-direction: column; }
        .sidebar { width: 80px; }
        .sidebar h2, .sidebar a span { display: none; }
        .main { margin-left: 80px; width: calc(100% - 80px); }
    }
    .system-status {
            padding: 20px; background: rgba(0,0,0,0.15); color: var(--sand);
            font-size: 0.8rem; border-top: 1px solid rgba(199, 183, 163, 0.1); margin-top: auto;
        }
</style>
</head>
<body>

<!--<div class="sidebar">
    <h2>OCEAN VIEW ADMIN</h2>
    <a href="admin_dashboard.jsp"><i class="fa fa-home"></i> Dashboard</a>
    <a href="manage-reservation"><i class="fa fa-bed"></i> Reservations</a>
    <a href="manage_guests.jsp"><i class="fa fa-users"></i> Guests</a>
    <a href="manage_staff.jsp"><i class="fa fa-user-tie"></i> Staff</a>
    <a href="<%= request.getContextPath() %>/room"><i class="fa fa-door-closed"></i> Rooms</a>
    <a href="manage_bills.jsp" style="background: rgba(255,255,255,0.1);"><i class="fa fa-file-invoice-dollar"></i> Billing</a>
    <a href="logout"><i class="fa fa-sign-out-alt"></i> Logout</a>
</div>-->
        <div class="sidebar">
            <div class="sidebar-menu">
                <h2>OCEAN VIEW</h2>
                <a href="${sessionScope.role == 'admin' ? 'admin_dashboard.jsp' : 'staff_dashboard.jsp'}">
                    <i class="fa fa-home"></i> Dashboard
                </a>
                <a href="manage-reservation"><i class="fa fa-bed"></i> Reservations</a>
                <a href="manage_guests.jsp"><i class="fa fa-users"></i> Guests</a>

                <% String role = (String)session.getAttribute("role");
                if("admin".equals(role)) {%>
                <a href="manage_staff.jsp"><i class="fa fa-user-tie"></i> Staff</a>
                <%}%>

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
        
        
<div class="main">
    <h1>Billing & Revenue</h1>

    <div class="stats-container">
    <div class="stat-card">
    <h3><i class="fa fa-chart-line"></i> Total Revenue</h3>
    <p id="stat-total">LKR 0.00</p>
    <i class="fa-solid fa-coins card-watermark"></i>
</div>

<div class="stat-card stat-paid">
    <h3><i class="fa fa-check-double"></i> Total Collected</h3>
    <p id="stat-paid">LKR 0.00</p>
    <i class="fa-solid fa-hand-holding-dollar card-watermark"></i>
</div>

<div class="stat-card stat-pending">
    <h3><i class="fa fa-clock"></i> Total Outstanding</h3>
    <p id="stat-pending">LKR 0.00</p>
    <i class="fa-solid fa-file-invoice-dollar card-watermark"></i>
</div>
</div>

    <div class="controls">
        <select id="statusFilter" onchange="applyFilter()">
            <option value="all">All Transactions</option>
            <option value="paid">PAID ONLY</option>
            <option value="pending">PENDING ONLY</option>
        </select>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>Bill ID</th>
                    <th>Res. ID</th>
                    <th>Billing Date</th>
                    <th>Amount (LKR)</th>
                    <th>Method</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="billTableBody">
                </tbody>
        </table>
    </div>
</div>

<script>
    let masterBillList = []; // Holds all data for client-side filtering

    /**
     * Fetch all data from the BillingAPI
     */
//    async function loadBills() {
//        try {
//            const res = await fetch("/Ocean_View_Resort/api/billing");
//            const data = await res.json();
//            
//            console.log("Full API Response:", data); // Check your 4 values here
//
//            const rawText = await res.text();
//        console.log("RAW SERVER RESPONSE:", rawText);
//        const data = JSON.parse(rawText);
//            // 1. Get the list of bills
//            masterBillList = data.bills || [];
//
//            // 2. Update the Summary Cards (With Fallback Calculation)
//            let totalRev, paidRev, pendingRev;
//
//            if (data.summary && data.summary.totalRevenue !== undefined) {
//                // Use Server Data if available
//                totalRev = data.summary.totalRevenue;
//                paidRev = data.summary.paidRevenue;
//                pendingRev = data.summary.pendingRevenue;
//            } else {
//                // Fallback: Calculate manually from the bills array
//                totalRev = masterBillList.reduce((sum, b) => sum + (parseFloat(b.totalAmount) || 0), 0);
//                paidRev = masterBillList.reduce((sum, b) => b.isPaid ? sum + (parseFloat(b.totalAmount) || 0) : sum, 0);
//                pendingRev = totalRev - paidRev;
//            }
//
//            // Update the HTML elements
//
//            document.getElementById("stat-total").innerText ="LKR "+ (parseFloat(totalRev) || 0).toLocaleString();
//            document.getElementById("stat-paid").innerText ="LKR "+ (parseFloat(paidRev) || 0).toLocaleString();
//            document.getElementById("stat-pending").innerText ="LKR "+ (parseFloat(pendingRev) || 0).toLocaleString();
//        
//            // 3. Render the table
//            renderTable(masterBillList);
//            
//        } catch (error) {
//            console.error("Critical Error in loadBills:", error);
//            document.getElementById("billTableBody").innerHTML = 
//                "<tr><td colspan='7' style='text-align:center; color:red;'>Error: Check Console (F12) for details.</td></tr>";
//        }
//    }
async function loadBills() {
    try {
        const res = await fetch("/Ocean_View_Resort/api/billing");
        
        // 1. Get the response as text first to handle the "Unexpected Character" error
        const rawText = await res.text();
        console.log("RAW SERVER RESPONSE:", rawText); 

        // 2. Parse the text manually
        let data;
        try {
            data = JSON.parse(rawText);
        } catch (parseError) {
            console.error("JSON Parse failed. Server sent 'dirty' data. Check the RAW RESPONSE above.");
            throw new Error("Invalid JSON format from server.");
        }

        // 3. Get the list of bills
        masterBillList = data.bills || [];

        // 4. Update the Summary Cards
        let totalRev = 0, paidRev = 0, pendingRev = 0;

        if (data.summary) {
            totalRev = data.summary.totalRevenue || 0;
            paidRev = data.summary.paidRevenue || 0;
            pendingRev = data.summary.pendingRevenue || 0;
        } else {
            // Manual Fallback if summary object is missing
            totalRev = masterBillList.reduce((sum, b) => sum + (parseFloat(b.totalAmount) || 0), 0);
            paidRev = masterBillList.reduce((sum, b) => b.isPaid ? sum + (parseFloat(b.totalAmount) || 0) : sum, 0);
            pendingRev = totalRev - paidRev;
        }

        // Update the HTML elements safely
        const totalEl = document.getElementById("stat-total");
        const paidEl = document.getElementById("stat-paid");
        const pendingEl = document.getElementById("stat-pending");

        if(totalEl) totalEl.innerText = "LKR " + parseFloat(totalRev).toLocaleString(undefined, {minimumFractionDigits: 2});
        if(paidEl) paidEl.innerText = "LKR " + parseFloat(paidRev).toLocaleString(undefined, {minimumFractionDigits: 2});
        if(pendingEl) pendingEl.innerText = "LKR " + parseFloat(pendingRev).toLocaleString(undefined, {minimumFractionDigits: 2});
    
        // 5. Render the table
        renderTable(masterBillList);
        
    } catch (error) {
        console.error("Critical Error in loadBills:", error);
        document.getElementById("billTableBody").innerHTML = 
            `<tr><td colspan='7' style='text-align:center; color:#6D2932; padding:20px;'>
                <i class="fa fa-exclamation-circle"></i> <b>Failed to load data</b><br>
                <small>${error.message}</small>
            </td></tr>`;
    }
}
    /**
     * Injects rows into the HTML table
     */
  function renderTable(bills) {
        const tbody = document.getElementById("billTableBody");
        tbody.innerHTML = "";
        
        if (!bills || bills.length === 0) {
            tbody.innerHTML = "<tr><td colspan='7' style='text-align:center;'>No records found.</td></tr>";
            return;
        }

        bills.forEach(bill => {
            const tr = document.createElement("tr");
            
            // We use \${ to tell JSP "Don't touch this, let JavaScript handle it"
            tr.innerHTML = `
                <td><b>#\${bill.billId}</b></td>
                <td>\${bill.reservationId}</td>
                <td>\${bill.billingDate}</td>
                <td>LKR \${parseFloat(bill.totalAmount).toLocaleString(undefined, {minimumFractionDigits: 2})}</td>
                <td><small>\${bill.paymentMethod || 'N/A'}</small></td>
                <td>
                    <span class="status-badge \${bill.isPaid ? 'status-paid' : 'status-pending'}">
                        \${bill.isPaid ? 'PAID' : 'PENDING'}
                    </span>
                </td>
                <td>
                    <a href="/Ocean_View_Resort/api/billing?previewId=\${bill.billId}" 
                       target="_blank" class="btn-icon" title="View/Print">
                        <i class="fa fa-print"></i>
                    </a>
                    <a href="/Ocean_View_Resort/api/billing?downloadId=\${bill.billId}" 
                       class="btn-icon" title="Download PDF">
                        <i class="fa fa-download"></i>
                    </a>
                    <i class="fa fa-paper-plane" onclick="resendEmail(\${bill.billId})" 
                       style="color: blue; cursor:pointer;" title="Resend Email"></i>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }

    /**
     * Filters the table without a page reload
     */
    function applyFilter() {
        const filterValue = document.getElementById("statusFilter").value;
        
        if (filterValue === "all") {
            renderTable(masterBillList);
        } else {
            const isPaidTarget = (filterValue === "paid");
            const filtered = masterBillList.filter(b => b.isPaid === isPaidTarget);
            renderTable(filtered);
        }
    }

    /**
     * Triggers the Resend logic in the Servlet
     */
    async function resendEmail(id) {
    // We escape the $ with a \ so JSP ignores it and JavaScript handles it
    const apiUrl = `/Ocean_View_Resort/api/billing?resendId=\${id}`; 
    
    console.log("Requesting URL:", apiUrl); // Check your F12 console to see if this looks right
    
    try {
        const res = await fetch(apiUrl);
        const data = await res.json();
        
        console.log("Server Response:", data);
        if (data.status === "success") {
            showToast(data.message || "Email resent successfully!", "success");
        } else {
            showToast(data.message || "Failed to resend email", "error");
        }
    } catch (e) {
        showToast("Connection Error: Could not reach server", "error");
    }
}

    // Initial load
    loadBills();
    
    function showToast(message, type) {
    console.log("Showing Toast with message:", message);

    // Remove old toasts
    const existingToast = document.querySelector(".toast");
    if (existingToast) existingToast.remove();

    const toast = document.createElement("div");
    // Use font-awesome classes (ensure fas/fa matches your version)
    const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
    
    toast.className = `toast \${type}`; // Added \ for JSP safety
    
    toast.innerHTML = `
        <i class="fas \${icon}"></i> 
        <span>\${message}</span>
    `;
    
    document.body.appendChild(toast);
    
    // Force browser to recognize the element before adding the 'show' class
    window.getComputedStyle(toast).opacity; 
    
    toast.classList.add("show");

    // Auto-hide after 4 seconds
    setTimeout(() => {
        toast.classList.remove("show");
        setTimeout(() => toast.remove(), 500);
    }, 4000);
}
</script>
<style>
/* --- IMPROVED STAT CARDS --- */
.stats-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 25px;
    margin-bottom: 40px;
}

.stat-card {
    position: relative;
    overflow: hidden;
    background: #F5E9DF; /* Parchment base */
    padding: 30px 25px;
    border-radius: 20px;
    box-shadow: 0 10px 25px rgba(86, 28, 36, 0.05);
    border: 1px solid rgba(199, 183, 163, 0.3);
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    display: flex;
    flex-direction: column;
    justify-content: center;
}
/* Styling for the new icon tags */
.card-watermark {
    position: absolute;
    right: -10px;
    bottom: -10px;
    font-size: 5rem;
    color: rgba(86, 28, 36, 0.04); /* Very faint maroon */
    transform: rotate(-15deg);
    transition: all 0.4s ease;
    pointer-events: none; /* Makes sure the icon doesn't interfere with clicks */
    z-index: 1;
}

.stat-card:hover .card-watermark {
    right: 5px;
    bottom: 5px;
    color: rgba(86, 28, 36, 0.08);
    transform: rotate(0deg) scale(1.1);
}

/* Ensure card content stays above the watermark */
.stat-card h3, .stat-card p {
    position: relative;
    z-index: 2;
}


/* Subtle background icon for each card */
.stat-card::after {
/*    content: '\f15a';  FontAwesome Bill Icon */
    font-family: 'Font Awesome 6 Free';
    font-weight: 900;
    position: absolute;
    right: -10px;
    bottom: -10px;
    font-size: 5rem;
    color: rgba(86, 28, 36, 0.03);
    transition: 0.4s;
}

.stat-card:hover::after {
    right: 5px;
    bottom: 5px;
    color: rgba(86, 28, 36, 0.06);
}

/*.stat-card h3 {
    margin: 0;
    color: #6D2932;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 2px;
    font-weight: 700;
    margin-bottom: 10px;
    display: flex;
    align-items: center;
    gap: 10px;
}*/

/* Colored Dot Indicators */
.stat-card h3::before {
    content: '';
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #561C24;
}

.stat-card.stat-paid h3::before { background: #2E7D32; }
.stat-card.stat-pending h3::before { background: #ef6c00; }

/*.stat-card p {
    margin: 0;
    font-size: 1.8rem;
    font-weight: 800;
    color: #3D1419;
    font-family: 'Montserrat', sans-serif;
    letter-spacing: -0.5px;
}*/

/* Specific Accent Borders */
.stat-card { border-top: 5px solid #561C24; }
.stat-card.stat-paid { border-top-color: #2E7D32; }
.stat-card.stat-pending { border-top-color: #ef6c00; }

/* TOAST MESSAGES */
/* TOAST MESSAGES - FIXED & FLOATING */
.toast {
    position: fixed !important; /* This stops it from moving the page */
    top: 30px; 
    right: 30px; 
    min-width: 300px; 
    padding: 15px 25px; 
    border-radius: 12px; 
    color: #ffffff !important; 
    font-weight: 600; 
    box-shadow: 0 10px 30px rgba(0,0,0,0.3); 
    opacity: 0; 
    transform: translateX(100%); /* Start off-screen to the right */
    transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55); 
    z-index: 9999;
    display: flex !important; 
    align-items: center !important; 
    gap: 15px;
}

.toast.show { 
    opacity: 1; 
    transform: translateX(0); /* Slide into view */
}

.toast.success { background: #2E7D32 !important; border-left: 6px solid #1B5E20; }
.toast.error { background: #6D2932 !important; border-left: 6px solid #3D1419; }

.toast i {
    color: #ffffff !important;
    font-size: 1.4rem !important;
}

.toast span {
    color: #ffffff !important;
    font-family: 'Montserrat', sans-serif;
}
</style>
</body>
</html>