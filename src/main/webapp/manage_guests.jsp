<%@ page import="com.mycompany.ocean_view_resort.dao.GuestDAO" %>
<%@ page import="com.mycompany.ocean_view_resort.model.Guest" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Guest Management | Ocean View Resort</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
    /* PALETTE CONSISTENCY:
       - Deep Maroon: #561C24 (Sidebar / Primary Headers)
       - Rose Wood:   #6D2932 (Accents / Hover States)
       - Sand Tan:    #C7B7A3 (Borders / Muted Text)
       - Cream Silk:  #E8D4C4 (Main Background)
       - Parchment:   #F5E9DF (Card Backgrounds)
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
        width: 260px;
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

    .sidebar a:hover {
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
    
    h1 {
        color: #561C24;
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem;
        margin-bottom: 35px;
    }
    
    /* --- CARDS (Elevation Look) --- */
    .card {
        background: #F5E9DF; /* Parchment Background */
        padding: 35px;
        border-radius: 18px;
        box-shadow: 0 8px 30px rgba(86, 28, 36, 0.12);
        margin-bottom: 35px;
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
    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }

    input {
        font-family: 'Montserrat', sans-serif;
        padding: 14px 18px;
        border-radius: 10px;
        border: 1px solid #C7B7A3;
        width: 100%; 
        background: #ffffff;
        color: #3D1419;
        font-size: 0.95rem;
        transition: border-color 0.3s ease;
    }

    input:focus {
        outline: none;
        border-color: #561C24;
        box-shadow: 0 0 0 3px rgba(86, 28, 36, 0.05);
    }

    /* --- BUTTONS --- */
    button[type="submit"] {
        font-family: 'Montserrat', sans-serif;
        padding: 14px 28px;
        border: none;
        border-radius: 10px;
        background: #561C24;
        color: #fff;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(86, 28, 36, 0.2);
        display: inline-flex;
        align-items: center;
        gap: 10px;
    }

    button[type="submit"]:hover {
        background: #6D2932;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(86, 28, 36, 0.3);
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
        padding: 20px 15px;
        text-align: left;
        font-family: 'Playfair Display', serif;
        text-transform: uppercase;
        font-size: 0.85rem;
        letter-spacing: 1px;
    }

    th:first-child { border-top-left-radius: 12px; }
    th:last-child { border-top-right-radius: 12px; }

    td {
        padding: 18px 15px;
        border-bottom: 1px solid #C7B7A3;
        background: #F5E9DF;
        color: #3D1419;
        font-size: 0.95rem;
    }

    tr:hover td {
        background: #EBD9D9; /* Light Maroon Glow */
    }
    
    /* --- ACTION BUTTONS --- */
    .action-btn {
        padding: 10px 16px;
        border-radius: 8px;
        font-size: 0.8rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: #fff; 
        border: none; 
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s ease;
    }

    .edit { background: #561C24; }
    .edit:hover { background: #6D2932; transform: scale(1.05); }

    .delete { background: #8E354A; }
    .delete:hover { background: #561C24; transform: scale(1.05); }

    /* --- DELETE MODAL --- */
    #deleteModal { 
        display: none; 
        position: fixed; 
        top: 0; left: 0; 
        width: 100%; height: 100%; 
        background: rgba(54, 15, 20, 0.8); 
        z-index: 10000; 
        justify-content: center; 
        align-items: center; 
    }

    #deleteModal .modal-content { 
        background: #F5E9DF; 
        padding: 40px; 
        border-radius: 20px; 
        max-width: 450px; 
        width: 90%; 
        text-align: center; 
        box-shadow: 0 15px 50px rgba(0,0,0,0.4);
        border: 1px solid #C7B7A3;
        animation: slideIn 0.3s ease-out;
    }

    @keyframes slideIn {
        from { transform: scale(0.9); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }

    #deleteModal h3 { 
        color: #561C24; 
        font-family: 'Playfair Display', serif; 
        font-size: 1.8rem;
        margin-bottom: 15px;
    }

    .modal-buttons { display: flex; gap: 15px; justify-content: center; margin-top: 30px; }
    
    .modal-buttons button { 
        padding: 12px 25px; 
        border-radius: 8px; 
        cursor: pointer; 
        font-weight: 600; 
        text-transform: uppercase;
        border: none;
    }

    .confirm { background: #8E354A; color: #fff; }
    .cancel { background: #6c757d; color: #fff; }

    /* --- TOAST MESSAGES --- */
    .toast {
        position: fixed; top: 30px; right: 30px; 
        min-width: 320px; padding: 18px 24px; border-radius: 12px; 
        color: #fff; font-weight: 600; box-shadow: 0 10px 30px rgba(0,0,0,0.2); 
        opacity: 0; transform: translateY(-20px); transition: all 0.4s ease; z-index: 9999;
    }
    .toast.show { opacity: 1; transform: translateY(0); }
    .toast.success { background: #2E7D32; }
    .toast.error { background: #6D2932; }

    /* Responsive Adjustments */
    @media(max-width: 1024px) {
        .main { padding: 30px; }
        .sidebar { width: 220px; }
        .main { margin-left: 220px; width: calc(100% - 220px); }
    }
    .system-status {
            padding: 20px; background: rgba(0,0,0,0.15); color: var(--sand);
            font-size: 0.8rem; border-top: 1px solid rgba(199, 183, 163, 0.1); margin-top: auto;
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
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px;">
        <h1>Guest Management</h1>
        <button type="button" class="action-btn edit" onclick="openGuestModal()" style="padding: 15px 25px; font-size: 0.9rem;">
            <i class="fa fa-user-plus"></i> Add New Guest
        </button>
    </div>

<!-- Form -->
<!--<div class="card">
<h2><i class="fa fa-user-plus"></i> Add / Edit Guest</h2>

<form action="<%= request.getContextPath() %>/guest" method="post">
<input type="hidden" name="id" value="<%= request.getAttribute("guest") != null ? ((Guest)request.getAttribute("guest")).getId() : "" %>">

<div class="form-grid">
<input type="text" name="guestName" placeholder="Full Name" required minlength="3"
value="<%= request.getAttribute("guest") != null ? ((Guest)request.getAttribute("guest")).getGuestName() : "" %>">

<input type="text" name="address" placeholder="Address" required
value="<%= request.getAttribute("guest") != null ? ((Guest)request.getAttribute("guest")).getAddress() : "" %>">

<input type="text" name="contact_number" placeholder="Contact Number" pattern="[0-9]{10,15}" required
title="Enter valid phone number"
value="<%= request.getAttribute("guest") != null ? ((Guest)request.getAttribute("guest")).getContactNumber() : "" %>">

<input type="email" name="email" placeholder="Email" required
value="<%= request.getAttribute("guest") != null ? ((Guest)request.getAttribute("guest")).getEmail() : "" %>">
</div>

<br>
<button type="submit">
<i class="fa fa-check"></i>
<%= request.getAttribute("guest") != null ? "Update Guest" : "Add Guest" %>
</button>
</form>
</div>-->

<!-- Table -->
<div class="card">
<h2><i class="fa-solid fa-person-walking-luggage"></i> All Guests</h2>

<div class="table-container">
<table>
<tr>
<th>ID</th>
<th>Name</th>
<th>Address</th>
<th>Contact</th>
<th>Email</th>
<th>Actions</th>
</tr>

<%
GuestDAO dao = new GuestDAO();
List<Guest> guestList = dao.getAllGuests();
for(Guest g : guestList){
%>

<tr>
<td><%= g.getId() %></td>
<td><%= g.getGuestName() %></td>
<td><%= g.getAddress() %></td>
<td><%= g.getContactNumber() %></td>
<td><%= g.getEmail() %></td>
<td>
<!--<a href="<%= request.getContextPath() %>/guest?action=edit&id=<%= g.getId() %>" class="action-btn edit">
<i class="fa fa-pen"></i> Edit
</a>-->
    <a href="javascript:void(0)" 
   class="action-btn edit" 
   onclick="prepareEdit('<%= g.getId() %>', '<%= g.getGuestName() %>', '<%= g.getAddress() %>', '<%= g.getContactNumber() %>', '<%= g.getEmail() %>')">
   <i class="fa-solid fa-pencil"></i> Edit
</a>
<a href="#" class="action-btn delete" onclick="openDeleteModal(<%= g.getId() %>)">
<i class="fa-regular fa-trash-can"></i> Delete
</a>
</td>
</tr>

<% } %>
</table>
</div>
</div>
</div>
<div id="guestModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(54, 15, 20, 0.8); z-index: 10000; justify-content: center; align-items: center;">
    <div class="card" style="width: 90%; max-width: 600px; position: relative; animation: slideIn 0.3s ease-out;">
        <span onclick="closeGuestModal()" style="position: absolute; right: 20px; top: 20px; cursor: pointer; font-size: 1.5rem; color: #561C24;"><i class="fa fa-times"></i></span>
        
        <h2 id="modalTitle"><i class="fa fa-user-plus"></i> Add Guest</h2>

        <form action="<%= request.getContextPath() %>/guest" method="post" id="guestForm">
            <input type="hidden" name="id" id="guestId">

            <div style="display: flex; flex-direction: column; gap: 15px;">
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600; color: #561C24;">Full Name</label>
                    <input type="text" name="guestName" id="guestName" placeholder="Full Name" required minlength="3">
                </div>
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600; color: #561C24;">Address</label>
                    <input type="text" name="address" id="address" placeholder="Address" required>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div>
                        <label style="font-size: 0.8rem; font-weight: 600; color: #561C24;">Contact</label>
                        <input type="text" name="contact_number" id="contact" placeholder="07XXXXXXXX" pattern="[0-9]{10,15}" required>
                    </div>
                    <div>
                        <label style="font-size: 0.8rem; font-weight: 600; color: #561C24;">Email</label>
                        <input type="email" name="email" id="email" placeholder="Email" required>
                    </div>
                </div>
            </div>

            <br>
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" class="cancel" onclick="closeGuestModal()" style="padding: 12px 20px; background: #6c757d; color: white; border-radius: 10px; border: none; cursor: pointer;">Cancel</button>
                <button type="submit" id="submitBtn">
                    <i class="fa fa-check"></i> Save Guest
                </button>
            </div>
        </form>
    </div>
</div>
<!-- Delete Confirmation Modal -->
<div id="deleteModal">
    <div class="modal-content">
        <h3>Confirm Delete</h3>
        <p>Are you sure you want to delete this geuest?</p>
        <div class="modal-buttons">
            <button class="confirm" id="confirmDeleteBtn">Yes</button>
            <button class="cancel" onclick="closeDeleteModal()">Cancel</button>
        </div>
    </div>
</div>

<!-- Toast Script -->
<script>
let deleteGuestId = null;

function openDeleteModal(id){ deleteGuestId = id; document.getElementById('deleteModal').style.display='flex'; }
function closeDeleteModal(){ deleteGuestId = null; document.getElementById('deleteModal').style.display='none'; }
document.getElementById('confirmDeleteBtn').addEventListener('click', function(){
    if(deleteGuestId){
        window.location.href = '<%= request.getContextPath() %>/guest?action=delete&id=' + deleteGuestId;
    }
});

function showToast(message,type){
    const toast=document.createElement("div");
    toast.className="toast "+type;
    toast.innerHTML=message;
    document.body.appendChild(toast);
    setTimeout(()=>toast.classList.add("show"),100);
    setTimeout(()=>{toast.classList.remove("show"); setTimeout(()=>toast.remove(),400);},3000);
}
function openGuestModal() {
    // Reset form for "Add" mode
    document.getElementById('guestForm').reset();
    document.getElementById('guestId').value = "";
    document.getElementById('modalTitle').innerHTML = '<i class="fa fa-user-plus"></i> Add New Guest';
    document.getElementById('submitBtn').innerHTML = '<i class="fa fa-check"></i> Add Guest';
    document.getElementById('guestModal').style.display = 'flex';
}

function closeGuestModal() {
    document.getElementById('guestModal').style.display = 'none';
}

function prepareEdit(id, name, address, contact, email) {
    // Fill form for "Edit" mode
    document.getElementById('guestId').value = id;
    document.getElementById('guestName').value = name;
    document.getElementById('address').value = address;
    document.getElementById('contact').value = contact;
    document.getElementById('email').value = email;
    
    document.getElementById('modalTitle').innerHTML = '<i class="fa fa-pen"></i> Edit Guest';
    document.getElementById('submitBtn').innerHTML = '<i class="fa fa-save"></i> Update Guest';
    document.getElementById('guestModal').style.display = 'flex';
}

// Close modal if user clicks outside of the card
window.onclick = function(event) {
    let modal = document.getElementById('guestModal');
    let delModal = document.getElementById('deleteModal');
    if (event.target == modal) closeGuestModal();
    if (event.target == delModal) closeDeleteModal();
}
</script>

<%
String toastMessage=(String)session.getAttribute("toastMessage");
String toastType=(String)session.getAttribute("toastType");
if(toastMessage!=null){
%>
<script>showToast("<%=toastMessage%>","<%=toastType%>");</script>
<%
session.removeAttribute("toastMessage");
session.removeAttribute("toastType");
}
%>

</body>
</html>
