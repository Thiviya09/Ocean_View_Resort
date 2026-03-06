<%@page import="java.util.List"%>
<%@ page import="com.mycompany.ocean_view_resort.dao.RoomDAO" %>
<%@ page import="com.mycompany.ocean_view_resort.dao.GuestDAO" %>
<%@ page import="com.mycompany.ocean_view_resort.model.Guest" %>
<%@ page import="com.mycompany.ocean_view_resort.model.Room" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
//    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
//        response.sendRedirect("index.jsp");
//        return;
//    }

    RoomDAO roomDAO = new RoomDAO();
    List<Room> roomList = roomDAO.getAllRooms();
    
    GuestDAO guestDAO = new GuestDAO();
    List<Guest> guestList = guestDAO.getAllGuests();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage Reservations | Ocean View Resort</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<style>
    /* PALETTE CONSISTENCY:
       - Deep Maroon: #561C24 (Sidebar / Primary Headers)
       - Rose Wood:   #6D2932 (Button Hovers / Accents)
       - Sand Tan:    #C7B7A3 (Borders / Muted Text)
       - Cream Silk:  #E8D4C4 (Main Background)
       - Parchment:   #F5E9DF (Card Backgrounds - Replaces White)
    */

    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap');

    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
        font-family: 'Montserrat', sans-serif;
        background-color: #E8D4C4; /* Cream Silk Background */
        display: flex;
        color: #3D1419;
        min-height: 100vh;
    }

    /* --- SIDEBAR (Exact Dashboard Match) --- */
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

    /* --- MAIN CONTENT AREA --- */
    .main {
        margin-left: 260px;
        padding: 50px;
        width: calc(100% - 260px);
        background-color: #E8D4C4;
    }
    
    .header-section { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        margin-bottom: 45px; 
    }

    h1 {
        color: #561C24;
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem;
        margin: 0;
    }
    
    /* --- CARDS (Elevation Look) --- */
    .card {
        background: #F5E9DF; /* Parchment Background */
        padding: 35px;
        border-radius: 18px;
        box-shadow: 0 8px 30px rgba(86, 28, 36, 0.12);
        margin-bottom: 30px;
        border: 1px solid rgba(199, 183, 163, 0.4);
    }

    .card h2 {
        margin-top: 0;
        font-family: 'Playfair Display', serif;
        font-size: 1.6rem;
        color: #561C24;
        border-bottom: 2px solid #C7B7A3;
        padding-bottom: 18px;
        margin-bottom: 25px;
    }
    
    /* --- FORM ELEMENTS --- */
    label { 
        font-weight: 600; 
        font-size: 0.85rem; 
        color: #6D2932; 
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    input, select {
        font-family: 'Montserrat', sans-serif;
        padding: 12px 15px;
        border-radius: 8px;
        border: 1px solid #C7B7A3;
        width: 100%; 
        margin-top: 8px;
        margin-bottom: 15px;
        background: #ffffff;
        color: #3D1419;
    }

    /* --- BUTTONS --- */
    button {
        font-family: 'Montserrat', sans-serif;
        padding: 12px 24px;
        border: none;
        border-radius: 10px;
        background: #561C24;
        color: #fff;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
        cursor: pointer;
        transition: 0.3s;
        box-shadow: 0 4px 10px rgba(86, 28, 36, 0.2);
    }

    button:hover {
        background: #6D2932;
        transform: translateY(-2px);
    }

    /* --- MODALS (Dashboard Style) --- */
    .modal { 
        display: none; 
        position: fixed; 
        z-index: 1000; 
        left: 0; 
        top: 0; 
        width: 100%; 
        height: 100%; 
        background: rgba(86, 28, 36, 0.7); /* Deep Maroon Tinted Overlay */
        align-items: center; 
        justify-content: center; 
    }

    .modal-content { 
        background: #F5E9DF; 
        padding: 40px; 
        border-radius: 20px; 
        width: 550px; 
        max-width: 95%; 
        position: relative; 
        border: 1px solid #C7B7A3;
        box-shadow: 0 20px 50px rgba(0,0,0,0.3);
        animation: slideDown 0.4s ease;
    }

    @keyframes slideDown { from { transform: translateY(-30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

    .close-modal { 
        position: absolute; 
        top: 20px; 
        right: 25px; 
        font-size: 1.8rem; 
        cursor: pointer; 
        color: #6D2932; 
    }

    /* --- TABLE (Luxury Design) --- */
    .table-container { overflow-x: auto; border-radius: 12px; }
    
    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }

    th {
        background: #561C24;
        color: #E8D4C4;
        padding: 18px;
        text-align: left;
        font-family: 'Playfair Display', serif;
        text-transform: uppercase;
        font-size: 0.85rem;
        letter-spacing: 1px;
    }

    th:first-child { border-top-left-radius: 12px; }
    th:last-child { border-top-right-radius: 12px; }

    td {
        padding: 16px;
        border-bottom: 1px solid #C7B7A3;
        background: #F5E9DF;
        color: #3D1419;
    }

    tr:hover td {
        background: #EBD9D9; /* Light Maroon Glow */
    }
    
    /* --- STATUS BADGES --- */
    .status-badge { 
        padding: 6px 14px; 
        border-radius: 20px; 
        font-size: 0.7rem; 
        font-weight: 700; 
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .status-badge.confirmed { background: #2E7D32; color: white; }
    .status-badge.pending { background: #C7B7A3; color: #561C24; }
    .status-badge.cancelled { background: #6D2932; color: white; }

    /* --- ACTION BUTTONS --- */
    .action-btn {
        padding: 8px 14px;
        border-radius: 6px;
        font-size: 0.8rem;
        font-weight: 600;
        text-transform: uppercase;
        color: #fff; 
        border: none; 
        cursor: pointer;
        transition: 0.2s;
    }

    .edit-btn { background: #561C24; margin-right: 5px; }
    .delete-btn { background: #8E354A; }

    /* --- TOAST MESSAGES --- */
    .toast {
        position: fixed; top: 30px; right: 30px; 
        min-width: 300px; padding: 16px 20px; border-radius: 10px; 
        color: #fff; font-weight: 600; box-shadow: 0 10px 25px rgba(0,0,0,0.2); 
        opacity: 0; transform: translateY(-20px); transition: 0.4s; z-index: 9999;
    }
    .toast.show { opacity: 1; transform: translateY(0); }
    .toast.success { background: #2E7D32; }
    .toast.error { background: #6D2932; }
    
    .system-status {
            padding: 20px; background: rgba(0,0,0,0.15); color: var(--sand);
            font-size: 0.8rem; border-top: 1px solid rgba(199, 183, 163, 0.1); margin-top: auto;
        }
</style>
</head>
<body>

<!--<div class="sidebar">
        <div class="sidebar-header">
            <h2>Ocean View</h2>
        </div>
        <div class="sidebar-menu">
            <a href="admin_dashboard.jsp"><i class="fa fa-home"></i> Dashboard</a>
            <a href="manage-reservation" class="active"><i class="fa fa-calendar-check"></i> Reservations</a>
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
    <div class="header-section">
        <h1>Manage Reservations</h1>
        <button onclick="openAddModal()"><i class="fa fa-plus"></i> New Reservation</button>
    </div>

    <div class="card">
        <h2><i class="fa-solid fa-door-open"></i> All Reservations</h2>
        <div class="table-container">
            <table id="reservationTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Guest ID</th>
                        <th>Room ID</th>
                        <th>Check In</th>
                        <th>Check Out</th>
                        <th>Total (LKR)</th>
                        <th>Status</th>
                        <th>Bill</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<div id="reservationModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeModal()">&times;</span>
        <h2 id="modalTitle"><i class="fa fa-plus-square"></i> New Reservation</h2>
        <hr style="margin: 15px 0; border: 0; border-top: 1px solid #eee;">
        
        <form id="reservationForm">
            <input type="hidden" id="reservationId">
            
            <div style="margin-bottom: 15px;">
                <label for="guestId">Guest</label>
                <select id="guestId" required>
                    <option value="">Select Guest</option>
                    <% for(Guest g : guestList) { %>
                        <option value="<%= g.getId() %>">ID: <%= g.getId() %> - <%= g.getGuestName() %></option>
                    <% } %>
                </select>
            </div>

            <div style="margin-bottom: 15px;">
                <label for="roomId">Room</label>
                <select id="roomId" required>
                    <option value="">Select Room</option>
                    <% for(Room r : roomList){ %>
                        <option value="<%= r.getRoomId() %>" data-price="<%= r.getPricePerNight() %>">
                            <%= r.getRoomNumber() %> - <%= r.getRoomType() %> (LKR <%= r.getPricePerNight() %>/night)
                        </option>
                    <% } %>
                </select>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px;">
                <div>
                    <label for="checkIn">Check In</label>
                    <input type="date" id="checkIn" required>
                </div>
                <div>
                    <label for="checkOut">Check Out</label>
                    <input type="date" id="checkOut" required>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px;">
                <div>
                    <label for="status">Status</label>
                    <select id="status" required>
                        <option value="PENDING">PENDING</option>
                        <option value="CONFIRMED">CONFIRMED</option>
                        <option value="CANCELLED">CANCELLED</option>
                    </select>
                </div>
                <div>
                    <label>Total Amount</label>
                    <input type="text" id="totalAmountInput" value="0" readonly style="background:#f9f9f9; font-weight:bold; color:#C8102E;">
                </div>
            </div>

            <div style="text-align: right; gap: 10px; display: flex; justify-content: flex-end;">
                <button type="button" onclick="closeModal()" style="background:#6c757d;">Cancel</button>
                <button type="submit" id="saveBtn">Save Reservation</button>
            </div>
        </form>
    </div>
</div>

<div id="toastContainer"></div>
<div id="billingModal" class="modal">
    <div class="modal-content" style="width: 450px;">
        <span class="close-modal" onclick="closeBillingModal()">&times;</span>
        <h2><i class="fa fa-file-invoice-dollar"></i> Finalize Bill</h2>
        <hr style="margin: 15px 0;">
        <form id="billingForm">
            <input type="hidden" id="billResId">
            
            <label>Room Total (LKR)</label>
            <input type="number" id="billRoomCharge" readonly style="background:#f0f0f0;">
            
            <label>Food & Beverages (LKR)</label>
            <input type="number" id="billFoodCharge" value="0" oninput="calculateFinalTotal()">
            
            <label>Service Charge (10%)</label>
            <input type="number" id="billServiceCharge" readonly style="background:#f0f0f0;">
            
            <label>Discount (LKR)</label>
            <input type="number" id="billDiscount" value="0" oninput="calculateFinalTotal()">
            
            <h3 style="margin-top:15px; color:#C8102E;">Total: LKR <span id="finalTotalTxt">0.00</span></h3>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 10px;">
                <div>
                    <label>Payment Method</label>
                    <select id="paymentMethod">
                        <option value="CASH">Cash</option>
                        <option value="CARD">Credit/Debit Card</option>
                        <option value="ONLINE">Bank Transfer</option>
                    </select>
                </div>
                <div style="display: flex; align-items: center; margin-top: 25px;">
                    <input type="checkbox" id="isPaid" style="width: 20px; margin-right: 10px;">
                    <label for="isPaid">Mark as Paid</label>
                </div>
            </div>

<!--            <h3 style="margin-top:20px;">Total: LKR <span id="finalTotalTxt">0</span></h3>-->
<!--            <button type="submit" style="width:100%; margin-top:15px; background:#28a745; color:white; padding:12px; border:none; border-radius:8px; cursor:pointer;">
                Process Payment & Send Receipt
            </button>-->
            <div style="margin-top:20px; display:flex; gap:10px;">
                <button type="submit" style="flex:1; background:#28a745;">Process Payment & Send Receipt</button>
                <button type="button" onclick="closeBillingModal()" style="flex:1; background:#6c757d;">Cancel</button>
            </div>
        </form>
    </div>
</div>
<div id="deleteConfirmModal" class="modal">
    <div class="modal-content" style="width: 400px; text-align: center;">
        <i class="fa fa-exclamation-triangle" style="font-size: 3rem; color: #6D2932; margin-bottom: 20px;"></i>
        <h2 style="border: none; margin-bottom: 10px;">Are you sure?</h2>
        <p style="color: #6D2932; margin-bottom: 30px;">This action cannot be undone. Do you really want to delete this reservation?</p>
        
        <div style="display: flex; gap: 15px; justify-content: center;">
            <button onclick="closeDeleteModal()" style="background: #C7B7A3; color: #561C24;">Cancel</button>
            <button id="confirmDeleteBtn" style="background: #6D2932;">Yes, Delete</button>
        </div>
    </div>
</div>
<script>
const modal = document.getElementById("reservationModal");
const reservationForm = document.getElementById("reservationForm");
const guestId = document.getElementById("guestId");
const roomId = document.getElementById("roomId");
const checkIn = document.getElementById("checkIn");
const checkOut = document.getElementById("checkOut");
const statusSelect = document.getElementById("status");
const totalInput = document.getElementById("totalAmountInput");
const reservationTable = document.getElementById("reservationTable").querySelector("tbody");

let editingId = null;

// Modal Controls
function openAddModal() {
    editingId = null;
    reservationForm.reset();
    totalInput.value = "0";
    document.getElementById("modalTitle").innerHTML = '<i class="fa fa-plus-square"></i> New Reservation';
    modal.style.display = "flex";
}

function closeModal() {
    modal.style.display = "none";
}

// Close modal if clicking outside content
window.onclick = function(event) {
    if (event.target == modal) closeModal();
}

// Toast
function showToast(message, type){
    const toast = document.createElement("div");
    toast.className = "toast " + type;
    toast.innerHTML = message;
    document.body.appendChild(toast);
    setTimeout(()=> toast.classList.add("show"),100);
    setTimeout(()=> {toast.classList.remove("show"); setTimeout(()=> toast.remove(),400);},3000);
}

// Load all reservations
async function loadReservations(){
    const res = await fetch("/Ocean_View_Resort/api/reservations");
    if (!res.ok) {
        console.error("Server returned an error:", res.status);
        return;
    }
    const data = await res.json();
    
    reservationTable.innerHTML = "";
    data.forEach(function(item) {
        const tr = document.createElement("tr");
        const isConfirmed = item.status === 'CONFIRMED';
        
        tr.innerHTML = `
            <td>\${item.reservationId}</td>
            <td>\${item.guestId}</td>
            <td>\${item.roomId}</td>
            <td>\${item.checkIn}</td>
            <td>\${item.checkOut}</td>
            <td>\${item.totalAmount}</td>
            <td>
                <span class="status-badge \${item.status.toLowerCase()}">\${item.status}</span>
            </td>
            <td style="text-align:center;">
                <button class="action-btn" 
                        onclick="openBillingModal(\${item.reservationId}, \${item.totalAmount}, \${item.guestId})" 
                        \${isConfirmed ? '' : 'disabled'} 
                        style="background:\${isConfirmed ? '#28a745' : '#ccc'}; cursor:\${isConfirmed ? 'pointer' : 'not-allowed'}">
                    <i class="fa fa-file-invoice"></i> Bill
                </button>
            </td>
            <td>
                <button class="action-btn edit-btn" onclick="editReservation(\${item.reservationId}, \${item.guestId}, \${item.roomId}, '\${item.checkIn}', '\${item.checkOut}', \${item.totalAmount}, '\${item.status}')">
                    <i class="fa-regular fa-pen-to-square"></i>
                </button>
                <button class="action-btn delete-btn" onclick="deleteReservation(\${item.reservationId})">
                    <i class="fa-regular fa-trash-can"></i>
                </button>
            </td>
        `;
        reservationTable.appendChild(tr);
    });
}

// Calculate total dynamically
function updateTotal(){
    const roomOption = roomId.selectedOptions[0];
    if(!roomOption || !roomOption.dataset.price) return;
    const price = parseFloat(roomOption.dataset.price);
    if(checkIn.value && checkOut.value && new Date(checkOut.value) > new Date(checkIn.value)){
        const days = (new Date(checkOut.value) - new Date(checkIn.value))/(1000*60*60*24);
        totalInput.value = (price*days).toFixed(2);
    } else {
        totalInput.value = "0";
    }
}

roomId.addEventListener("change", updateTotal);
checkIn.addEventListener("change", updateTotal);
checkOut.addEventListener("change", updateTotal);

// Submit form
reservationForm.addEventListener("submit", async e=>{
    e.preventDefault();
    const payload = {
        guestId: guestId.value,
        roomId: roomId.value,
        checkIn: checkIn.value,
        checkOut: checkOut.value,
        totalAmount: parseFloat(totalInput.value),
        status: statusSelect.value
    };

    let method = "POST";
    let url = "/Ocean_View_Resort/api/reservations";
    
    if(editingId){
        method = "PUT";
        url = "/Ocean_View_Resort/api/reservations/" + editingId;
        payload.id = editingId;
    }

    const res = await fetch(url, {
        method,
        headers: {"Content-Type":"application/json"},
        body: JSON.stringify(payload)
    });

    if(res.ok){
        showToast(editingId ? "Reservation Updated!" : "Reservation Created!", "success");
        closeModal();
        loadReservations();
    } else if(res.status==409){
        showToast("Room not available for these dates!", "error");
    } else {
        showToast("An error occurred!", "error");
    }
});

// Edit reservation - Opens Modal and populates data
function editReservation(id, guest, room, checkin, checkout, total, status){
    editingId = id;
    document.getElementById("modalTitle").innerHTML = '<i class="fa fa-edit"></i> Edit Reservation (#' + id + ')';
    
    guestId.value = guest;
    roomId.value = room;
    checkIn.value = checkin;
    checkOut.value = checkout;
    totalInput.value = total;
    statusSelect.value = status;
    
    modal.style.display = "flex";
}

// Delete reservation
async function deleteReservation(id){
    if(!confirm("Are you sure you want to delete this reservation?")) return;
    const res = await fetch("/Ocean_View_Resort/api/reservations/"+id, {method:"DELETE"});
    if(res.ok){
        showToast("Deleted successfully!", "success");
        loadReservations();
    } else showToast("Error deleting", "error");
}

// Initial load
loadReservations();

// Existing functionality for disabled dates
async function disableBookedDates(roomIdVal){
    if(!roomIdVal) return;
    try {
        const res = await fetch("/Ocean_View_Resort/api/rooms/"+roomIdVal);
        const ranges = await res.json();
        const disableDates = [];
        ranges.forEach(r=>{
            let d = new Date(r.start);
            const end = new Date(r.end);
            while(d < end){
                disableDates.push(new Date(d).toISOString().split('T')[0]);
                d.setDate(d.getDate()+1);
            }
        });

        const validateDate = (e) => {
            if(disableDates.includes(e.target.value)){
                showToast("This date is already booked!", "warning");
                e.target.value="";
                updateTotal();
            }
        };

        checkIn.oninput = validateDate;
        checkOut.oninput = validateDate;
    } catch (err) { console.error("Error fetching room dates", err); }
}

roomId.addEventListener("change", ()=> disableBookedDates(roomId.value));

const billingModal = document.getElementById("billingModal");
const billingForm = document.getElementById("billingForm");
let currentGuestId = null; // Track the guest for the current bill

function openBillingModal(resId, roomTotal, gId) {
    currentGuestId = gId;
    document.getElementById("billResId").value = resId;
    document.getElementById("billRoomCharge").value = roomTotal;
    calculateFinalTotal();
    billingModal.style.display = "flex";
}

function closeBillingModal() {
    billingModal.style.display = "none";
}

function calculateFinalTotal() {
    const room = parseFloat(document.getElementById("billRoomCharge").value) || 0;
    const food = parseFloat(document.getElementById("billFoodCharge").value) || 0;
    const discount = parseFloat(document.getElementById("billDiscount").value) || 0;
    
    const serviceCharge = (room + food) * 0.10; // 10%
    const total = (room + food + serviceCharge) - discount;
    
    document.getElementById("billServiceCharge").value = serviceCharge.toFixed(2);
    document.getElementById("finalTotalTxt").innerText = total.toFixed(2);
}

document.getElementById("billingForm").onsubmit = async (e) => {
    e.preventDefault();
    const payload = {
        reservationId: parseInt(document.getElementById("billResId").value),
        guestId:currentGuestId,
        roomCharge: parseFloat(document.getElementById("billRoomCharge").value),
        foodCharge: parseFloat(document.getElementById("billFoodCharge").value),
        serviceCharge: (parseFloat(document.getElementById("billRoomCharge").value) + parseFloat(document.getElementById("billFoodCharge").value)) * 0.10,
        discount: parseFloat(document.getElementById("billDiscount").value),
        totalAmount: parseFloat(document.getElementById("finalTotalTxt").innerText),
        paymentMethod: document.getElementById("paymentMethod").value,
        isPaid: document.getElementById("isPaid").checked
    };
    
    const res = await fetch("/Ocean_View_Resort/api/billing", {
        method: "POST",
        body: JSON.stringify(payload)
    });
    
    if(res.ok) {
        showToast("Processing Payment... Check email shortly!", "success");
        document.getElementById("billingModal").style.display = "none";
    }
};
let idToDelete = null;
const deleteModal = document.getElementById("deleteConfirmModal");

// 1. Function called when clicking the trash icon
function deleteReservation(id) {
    idToDelete = id; // Store the ID globally for this page session
    deleteModal.style.display = "flex";
}

// 2. Function to close the delete modal
function closeDeleteModal() {
    deleteModal.style.display = "none";
    idToDelete = null;
}

// 3. Event listener for the "Yes, Delete" button inside the modal
document.getElementById("confirmDeleteBtn").onclick = async function() {
    if (!idToDelete) return;

    try {
        const res = await fetch("/Ocean_View_Resort/api/reservations/" + idToDelete, {
            method: "DELETE"
        });

        if (res.ok) {
            showToast("Reservation deleted successfully!", "success");
            loadReservations(); // Refresh the table
        } else {
            showToast("Error deleting reservation", "error");
        }
    } catch (error) {
        showToast("Connection error", "error");
    } finally {
        closeDeleteModal();
    }
};

// Close delete modal if clicking outside
window.addEventListener("click", function(event) {
    if (event.target == deleteModal) {
        closeDeleteModal();
    }
});
</script>

</body>
</html>