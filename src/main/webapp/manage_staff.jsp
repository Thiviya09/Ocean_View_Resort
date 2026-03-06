<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("staff_dashboard.jsp?error=unauthorized");
        return;
    }
%>
<%@ page import="com.mycompany.ocean_view_resort.dao.StaffDAO" %>
<%@ page import="com.mycompany.ocean_view_resort.model.Staff" %>
<%@ page import="java.util.List" %>

<%@ page session="true" %>

<%
if(session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))){
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Staff Management | Ocean View Resort</title>
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
    
    /* --- CARDS --- */
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
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 20px;
    }

    input, select {
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

    input:focus, select:focus {
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
    .toast.warning { background: #C7B7A3; color: #561C24; }
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

                <% role = (String)session.getAttribute("role");
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
        <h1>Staff Management</h1>
        <button type="button" class="action-btn edit" onclick="openStaffModal()" style="padding: 15px 25px; font-size: 0.9rem;">
            <i class="fa fa-user-plus"></i> Add New Staff
        </button>
    </div>

<!-- Add/Edit Form -->
<!--<div class="card">
<h2><i class="fa fa-user-plus"></i> Add / Edit Staff</h2>

<form action="<%= request.getContextPath() %>/staff" method="post">
<input type="hidden" name="id" value="<%= request.getAttribute("staff") != null ? ((Staff)request.getAttribute("staff")).getId() : "" %>">

<div class="form-grid">
<input type="text" name="username" placeholder="Username" required minlength="3"
value="<%= request.getAttribute("staff") != null ? ((Staff)request.getAttribute("staff")).getUsername() : "" %>">

<input type="password" name="password" placeholder="Password" required minlength="4"
value="<%= request.getAttribute("staff") != null ? ((Staff)request.getAttribute("staff")).getPassword() : "" %>">

<select name="role" required>
<option value="">Select Role</option>
<option value="admin" <%= request.getAttribute("staff") != null && ((Staff)request.getAttribute("staff")).getRole().equals("admin") ? "selected" : "" %>>Admin</option>
<option value="staff" <%= request.getAttribute("staff") != null && ((Staff)request.getAttribute("staff")).getRole().equals("staff") ? "selected" : "" %>>Staff</option>
</select>

<input type="text" name="fullname" placeholder="Full Name"
value="<%= request.getAttribute("staff") != null ? ((Staff)request.getAttribute("staff")).getFullname() : "" %>">

<input type="text" name="contact" placeholder="Contact"
pattern="[0-9]{10,15}" title="Enter valid phone number"
value="<%= request.getAttribute("staff") != null ? ((Staff)request.getAttribute("staff")).getContact() : "" %>">

<input type="email" name="email" placeholder="Email"
value="<%= request.getAttribute("staff") != null ? ((Staff)request.getAttribute("staff")).getEmail() : "" %>">
</div>

<br>
<button type="submit">
<i class="fa fa-check"></i> <%= request.getAttribute("staff") != null ? "Update Staff" : "Add Staff" %>
</button>
</form>
</div>-->
<div id="staffModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(54, 15, 20, 0.85); z-index: 10000; justify-content: center; align-items: center;">
    <div class="card" style="width: 90%; max-width: 700px; position: relative; animation: slideIn 0.3s ease-out;">
        <span onclick="closeStaffModal()" style="position: absolute; right: 25px; top: 20px; cursor: pointer; font-size: 1.5rem; color: #561C24;"><i class="fa fa-times"></i></span>
        
        <h2 id="staffModalTitle">Add Staff Member</h2>

        <form action="<%= request.getContextPath() %>/staff" method="post" id="staffForm">
            <input type="hidden" name="id" id="staffId">

            <div class="form-grid">
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600;">Username</label>
                    <input type="text" name="username" id="staffUser" required minlength="3">
                </div>
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600;">Password</label>
                    <input type="password" name="password" id="staffPass" required minlength="4">
                </div>
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600;">Role</label>
                    <select name="role" id="staffRole" required>
                        <option value="">Select Role</option>
                        <option value="admin">Admin</option>
                        <option value="staff">Staff</option>
                    </select>
                </div>
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600;">Full Name</label>
                    <input type="text" name="fullname" id="staffName">
                </div>
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600;">Contact</label>
                    <input type="text" name="contact" id="staffContact" pattern="[0-9]{10,15}">
                </div>
                <div>
                    <label style="font-size: 0.8rem; font-weight: 600;">Email</label>
                    <input type="email" name="email" id="staffEmail">
                </div>
            </div>

            <div style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" onclick="closeStaffModal()" style="background:#6c757d; color:white; border:none; padding:12px 20px; border-radius:10px; cursor:pointer;">Cancel</button>
                <button type="submit" id="staffSubmitBtn">Save Staff</button>
            </div>
        </form>
    </div>
</div>
<!-- Staff Table -->
<div class="card">
<h2><i class="fa-solid fa-user-tie"></i> All Staff</h2>
<div class="table-container">
<table>
<tr><th>ID</th><th>Username</th><th>Role</th><th>Full Name</th><th>Contact</th><th>Email</th><th>Actions</th></tr>
<%
StaffDAO dao = new StaffDAO();
List<Staff> staffList = dao.getAllStaff();
for(Staff s : staffList){
%>
<tr>
<td><%= s.getId() %></td>
<td><%= s.getUsername() %></td>
<td><%= s.getRole() %></td>
<td><%= s.getFullname() != null ? s.getFullname() : "" %></td>
<td><%= s.getContact() != null ? s.getContact() : "" %></td>
<td><%= s.getEmail() != null ? s.getEmail() : "" %></td>
<td>
<!--<a href="<%= request.getContextPath() %>/staff?action=edit&id=<%= s.getId() %>" class="action-btn edit"><i class="fa fa-pen"></i> Edit</a>-->
    <button class="action-btn edit" 
   onclick="prepareStaffEdit('<%= s.getId() %>', '<%= s.getUsername() %>', '<%= s.getRole() %>', '<%= s.getFullname() %>', '<%= s.getContact() %>', '<%= s.getEmail() %>')">
   <i class="fa fa-pencil"></i> Edit
</button>
<a href="#" class="action-btn delete" onclick="openDeleteModal(<%= s.getId() %>)"><i class="fa-regular fa-trash-can"></i> Delete</a>
</td>
</tr>
<% } %>
</table>
</div>
</div>
</div>

<!-- Delete Modal -->
<div id="deleteModal">
    <div class="modal-content">
        <h3>Confirm Delete</h3>
        <p>Are you sure you want to delete this staff member?</p>
        <div class="modal-buttons">
            <button class="confirm" id="confirmDeleteBtn">Yes</button>
            <button class="cancel" onclick="closeDeleteModal()">Cancel</button>
        </div>
    </div>
</div>

<script>
let deleteStaffId = null;
function openDeleteModal(id){ deleteStaffId = id; document.getElementById('deleteModal').style.display='flex'; }
function closeDeleteModal(){ deleteStaffId=null; document.getElementById('deleteModal').style.display='none'; }
document.getElementById('confirmDeleteBtn').addEventListener('click', function(){
    if(deleteStaffId){ window.location.href='<%= request.getContextPath() %>/staff?action=delete&id='+deleteStaffId; }
});

function showToast(message,type){
    const toast=document.createElement("div");
    toast.className="toast "+type; toast.innerHTML=message; document.body.appendChild(toast);
    setTimeout(()=>toast.classList.add("show"),100);
    setTimeout(()=>{ toast.classList.remove("show"); setTimeout(()=>toast.remove(),400); },3000);
}

function openStaffModal() {
    document.getElementById('staffForm').reset();
    document.getElementById('staffId').value = "";
    document.getElementById('staffPass').required = true; // Required for new staff
    document.getElementById('staffModalTitle').innerText = "Add New Staff Member";
    document.getElementById('staffSubmitBtn').innerHTML = '<i class="fa fa-check"></i> Add Staff';
    document.getElementById('staffModal').style.display = 'flex';
}

function closeStaffModal() {
    document.getElementById('staffModal').style.display = 'none';
}

function prepareStaffEdit(id, user, role, name, contact, email) {
    document.getElementById('staffId').value = id;
    document.getElementById('staffUser').value = user;
    document.getElementById('staffRole').value = role;
    document.getElementById('staffName').value = (name === "null") ? "" : name;
    document.getElementById('staffContact').value = (contact === "null") ? "" : contact;
    document.getElementById('staffEmail').value = (email === "null") ? "" : email;
    
    // For editing, password might be optional depending on your Servlet logic
    document.getElementById('staffPass').required = false; 
    document.getElementById('staffPass').placeholder = "(Leave blank to keep current)";

    document.getElementById('staffModalTitle').innerText = "Edit Staff Details";
    document.getElementById('staffSubmitBtn').innerHTML = '<i class="fa fa-save"></i> Update Staff';
    document.getElementById('staffModal').style.display = 'flex';
}

// Update your window.onclick to handle this modal too
window.onclick = function(event) {
    let sModal = document.getElementById('staffModal');
    let dModal = document.getElementById('deleteModal');
    if (event.target == sModal) closeStaffModal();
    if (event.target == dModal) closeDeleteModal();
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
