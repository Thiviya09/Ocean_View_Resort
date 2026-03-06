<%@ page import="com.mycompany.ocean_view_resort.model.Room" %>
<%@ page import="com.mycompany.ocean_view_resort.model.RoomType" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Data Retrieval from Servlet
    List<Room> roomList = (List<Room>) request.getAttribute("rooms");
    List<RoomType> types = (List<RoomType>) request.getAttribute("roomTypes");
    Room editRoom = (Room) request.getAttribute("room");
    
    // Check if we should auto-open the Room Modal (for Edit mode)
    String openEditModal = (editRoom != null) ? "flex" : "none";
%>
<%
    double maxFound = 100000; // Default fallback
    if(roomList != null) {
        for(Room r : roomList) {
            if(r.getPricePerNight() > maxFound) maxFound = r.getPricePerNight();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Rooms | Ocean View Resort</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">

    <style>
        /* PALETTE CONSISTENCY (Matched to Reservations) */
        :root {
            --maroon: #561C24;
            --rose: #6D2932;
            --sand: #C7B7A3;
            --cream: #E8D4C4;
            --parchment: #F5E9DF;
            --text-dark: #3D1419;
            --transition: all 0.3s ease;
        }

        * { margin:0; padding:0; box-sizing:border-box; }
        
        body { 
            font-family: 'Montserrat', sans-serif; 
            background-color: var(--cream); 
            color: var(--text-dark); 
            display: flex; 
            min-height: 100vh;
        }

        /* --- SIDEBAR (Exact Match) --- */
        .sidebar {
            width: 260px; height: 100vh; background: var(--maroon); color: var(--cream);
            position: fixed; top: 0; left: 0; display: flex; flex-direction: column;
            box-shadow: 4px 0 15px rgba(0,0,0,0.2); z-index: 100;
        }
        .sidebar h2 { 
            padding: 40px 20px; text-align: center; font-family: 'Playfair Display', serif; 
            font-size: 1.8rem; letter-spacing: 2px; text-transform: uppercase;
            border-bottom: 1px solid rgba(199, 183, 163, 0.2);
        }
        .sidebar a { 
            display: flex; align-items: center; padding: 16px 28px; color: var(--sand); 
            text-decoration: none; transition: var(--transition); font-weight: 500; font-size: 0.95rem;
        }
        .sidebar a i { margin-right: 15px; width: 25px; font-size: 1.2rem; }
        .sidebar a:hover, .sidebar a.active { background: var(--rose); color: #fff; padding-left: 35px; }

        /* --- MAIN CONTENT --- */
        .main { margin-left: 260px; padding: 50px; width: calc(100% - 260px); }
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 45px; }
        h1 { font-family: 'Playfair Display', serif; font-size: 2.5rem; color: var(--maroon); }

        /* --- SEARCH BAR --- */
        .search-container {
            background: var(--parchment); padding: 20px 25px; border-radius: 12px; 
            box-shadow: 0 8px 30px rgba(86, 28, 36, 0.08); display: flex; gap: 15px; 
            margin-bottom: 40px; align-items: center; border: 1px solid rgba(199, 183, 163, 0.4);
        }
        .search-container input { 
            flex: 1; border: 1px solid var(--sand); padding: 12px; border-radius: 8px; 
            outline: none; font-family: 'Montserrat', sans-serif;
        }

        /* --- BUTTONS --- */
        .btn { 
            padding: 12px 24px; border: none; border-radius: 10px; cursor: pointer; 
            font-weight: 600; text-transform: uppercase; letter-spacing: 1px;
            transition: var(--transition); display: inline-flex; align-items: center; gap: 8px;
            font-family: 'Montserrat', sans-serif;
        }
        .btn-primary { background: var(--maroon); color: #fff; box-shadow: 0 4px 10px rgba(86, 28, 36, 0.2); }
        .btn-primary:hover { background: var(--rose); transform: translateY(-2px); }
        .btn-outline { background: transparent; border: 1px solid var(--maroon); color: var(--maroon); }
        .btn-outline:hover { background: var(--maroon); color: #fff; }

        /* --- ROOM GRID --- */
        .room-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 25px; }
        .room-card { 
            background: var(--parchment); border-radius: 18px; overflow: hidden; 
            box-shadow: 0 8px 25px rgba(86, 28, 36, 0.1); transition: var(--transition); 
            border: 1px solid rgba(199, 183, 163, 0.4); display: flex; flex-direction: column;
            transition: transform 0.3s ease, opacity 0.3s ease;
        }
        .room-card:hover { transform: translateY(-8px); box-shadow: 0 12px 35px rgba(86, 28, 36, 0.15); }
        .room-img-container { position: relative; width: 100%; height: 200px; }
        .room-img { width: 100%; height: 100%; object-fit: cover; }
        
        .status-badge { 
            position: absolute; top: 15px; right: 15px; padding: 6px 14px; border-radius: 20px; 
            font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .badge-available { background: #2E7D32; color: white; }
        .badge-unavailable { background: var(--maroon); color: white; }

        .room-body { padding: 25px; flex-grow: 1; }
        .room-title { font-family: 'Playfair Display', serif; font-size: 1.4rem; font-weight: 700; color: var(--maroon); margin-bottom: 12px; }
        .info-item { 
    display: flex; 
    justify-content: space-between; 
    align-items: center; /* Vertically centers icon and text */
    margin-bottom: 8px; 
    font-size: 0.85rem; 
    color: var(--rose); 
}
@keyframes fadeInCard {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.room-card[style*="display: flex"] {
    animation: fadeInCard 0.4s ease forwards;
}
/* Group the icon and label together */
.info-item span {
    display: flex;
    align-items: center;
    gap: 10px; /* Space between icon and text */
}

/* Set a fixed width for the icon so labels align perfectly */
.info-item i {
    width: 18px; 
    text-align: center;
    color: var(--maroon);
}

.info-item b { 
    color: var(--text-dark); 
}
        .price-night { margin-top: 15px; font-size: 1.25rem; font-weight: 700; color: var(--maroon); border-top: 1px solid var(--sand); padding-top: 15px; }

        .card-actions { display: flex; gap: 10px; padding: 15px 20px; background: rgba(199, 183, 163, 0.1); border-top: 1px solid var(--sand); }
        .action-btn { 
            flex: 1; padding: 10px; text-align: center; border-radius: 6px; text-decoration: none; 
            font-size: 0.75rem; font-weight: 700; cursor: pointer; border: none; text-transform: uppercase;
        }
        .edit-btn { background: var(--maroon); color: #fff; }
        .delete-btn { background: #8E354A; color: #fff; }

        /* --- MODALS --- */
        .modal {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(86, 28, 36, 0.7); display: none; justify-content: center; align-items: center; z-index: 1000;
        }
        .modal-content { 
            background: var(--parchment); width: 550px; border-radius: 20px; padding: 40px; 
            box-shadow: 0 20px 50px rgba(0,0,0,0.3); border: 1px solid var(--sand);
            animation: slideDown 0.4s ease; position: relative;
        }
        @keyframes slideDown { from { transform: translateY(-30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        
        .close-modal { position: absolute; top: 20px; right: 25px; font-size: 1.8rem; cursor: pointer; color: var(--maroon); }

        .field { margin-bottom: 18px; }
        .field label { display: block; margin-bottom: 8px; font-size: 0.85rem; font-weight: 600; color: var(--rose); text-transform: uppercase; letter-spacing: 0.5px;}
        .field input, .field select { 
            width: 100%; padding: 12px; border: 1px solid var(--sand); border-radius: 8px; outline: none; 
            font-family: 'Montserrat', sans-serif; background: #fff;
        }

        /* --- TOASTS --- */
        .toast {
            position: fixed; top: 30px; right: 30px; min-width: 300px; padding: 16px 20px; border-radius: 10px; 
            color: #fff; font-weight: 600; box-shadow: 0 10px 25px rgba(0,0,0,0.2); 
            opacity: 0; transform: translateY(-20px); transition: 0.4s; z-index: 9999;
        }
        .toast.show { opacity: 1; transform: translateY(0); }
        .toast.success { background: #2E7D32; }
        .toast.error { background: var(--maroon); }

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
        <div class="header-section">
            <h1>Room Inventory</h1>
            <div style="display:flex; gap: 12px;">
                <button class="btn btn-outline" onclick="openTypeModal()"><i class="fa fa-sliders"></i> Room Types</button>
                <button class="btn btn-primary" onclick="openRoomModal()"><i class="fa fa-plus"></i> Add New Room</button>
            </div>
        </div>

        <div class="search-container">
            <i class="fa fa-search" style="color: var(--sand);"></i>
            <form action="room" method="get" style="display:contents;">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="Search by Room Name">
                <button type="submit" class="btn btn-primary">Search</button>
                <a href="room" class="btn btn-outline" style="text-decoration:none;">Clear</a>
            </form>
        </div>
        
        <div class="search-container" style="margin-top: -20px; background: rgba(199, 183, 163, 0.15); display: flex; flex-wrap: wrap;">
    <div style="display:flex; align-items:center; gap:10px;">
        <i class="fa fa-filter" style="color: var(--maroon);"></i>
        <span style="font-size: 0.8rem; font-weight: 700; color: var(--rose); text-transform: uppercase;">Quick Filters:</span>
    </div>

    <select id="filterRoomType" onchange="filterRooms()" style="padding: 8px 15px; border-radius: 8px; border: 1px solid var(--sand); font-family: 'Montserrat';">
        <option value="all">All Room Types</option>
        <% if(types != null) { for(RoomType t : types) { %>
            <option value="<%= t.getTypeName() %>"><%= t.getTypeName() %></option>
        <% } } %>
    </select>

    <select id="filterAcType" onchange="filterRooms()" style="padding: 8px 15px; border-radius: 8px; border: 1px solid var(--sand); font-family: 'Montserrat';">
        <option value="all">All Climate</option>
        <option value="AC">AC Only</option>
        <option value="Non-AC">Non-AC Only</option>
    </select>

    <button class="btn btn-outline" style="padding: 8px 15px; font-size: 0.7rem;" onclick="resetFilters()">Reset</button>
    
    <div style="display:flex; align-items:center; gap:15px; background: white; padding: 5px 15px; border-radius: 8px; border: 1px solid var(--sand); flex-grow: 1; min-width: 250px;">
    <span style="font-size: 0.75rem; font-weight: 700; color: var(--maroon);">MAX PRICE:</span>
    
    <input type="range" id="priceRange" min="0" max="<%= (int)maxFound %>" step="1000" value="100000" 
           oninput="updatePriceLabel(this.value)" onchange="filterRooms()" 
           style="flex: 1; accent-color: var(--maroon); cursor: pointer;">
    <span id="priceValue" style="font-size: 0.85rem; font-weight: 700; color: var(--rose); min-width: 90px;">LKR 100,000</span>
</div>
</div>

        <div class="room-grid">
            <% if(roomList != null && !roomList.isEmpty()) { 
                for(Room r : roomList) { 
                    String statusClass = "Available".equalsIgnoreCase(r.getStatus()) ? "badge-available" : "badge-unavailable";
                    int cap = 0;
                    if(types != null) {
                        for(RoomType t : types) {
                            if(t.getTypeId() == r.getTypeId()) { cap = t.getCapacity(); break; }
                        }
                    }
            %>
            <div class="room-card" data-type="<%= r.getRoomType() %>" 
     data-ac="<%= r.getAcType() %>" data-price="<%= r.getPricePerNight() %>">
                <div class="room-img-container">
                    <% if(r.getImagePath() != null && !r.getImagePath().isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/<%= r.getImagePath() %>?t=<%= System.currentTimeMillis() %>" 
     class="room-img" 
     onerror="this.src='https://via.placeholder.com/300x200?text=No+Image+Found'">
                    <% } else { %>
                        <div class="room-img" style="background:var(--sand); display:flex; align-items:center; justify-content:center; opacity:0.3;">
                            <i class="fa fa-bed fa-3x" style="color:var(--maroon);"></i>
                        </div>
                    <% } %>
                    <span class="status-badge <%= statusClass %>"><%= r.getStatus() %></span>
                </div>
                
                <div class="room-body">
    <div class="room-title">Room <%= r.getRoomNumber() %></div>
    
    <div class="info-item">
        <span><i class="fa fa-tag"></i> Type:</span>
        <b><%= r.getRoomType() %></b>
    </div>
    
    <div class="info-item">
        <span><i class="fa fa-users"></i> Capacity:</span>
        <b><%= cap %> Persons</b>
    </div>
    
    <div class="info-item">
        <span><i class="fa fa-snowflake"></i> Climate:</span>
        <b><%= r.getAcType() %></b>
    </div>
    
    <div class="price-night">
        LKR <%= String.format("%.2f", r.getPricePerNight()) %> 
        <small style="font-weight:400; font-size:0.75rem;">/ NIGHT</small>
    </div>
</div>

                <div class="card-actions">
    <a href="room?action=edit&id=<%= r.getRoomId() %>" class="action-btn edit-btn"><i class="fa fa-edit"></i></a>
    <button onclick="openCalendar('<%= r.getRoomId() %>', '<%= r.getRoomNumber() %>')" class="action-btn" style="background: var(--sand); color: var(--maroon);">
        <i class="fa fa-calendar-alt"></i>
    </button>
    <button onclick="deleteRoom('<%= r.getRoomId() %>')" class="action-btn delete-btn"><i class="fa-regular fa-trash-can"></i></button>
</div>
            </div>
            <% } } else { %>
                <div style="grid-column: 1/-1; text-align: center; padding: 50px; background: var(--parchment); border-radius: 18px; border: 1px solid var(--sand);">
                    <i class="fa fa-search fa-3x" style="color:var(--sand); margin-bottom: 15px;"></i>
                    <p style="color: var(--rose);">No rooms found in the vault.</p>
                </div>
            <% } %>
        </div>
        
        <div id="noMatchMessage" style="display:none; grid-column: 1/-1; text-align: center; padding: 60px; background: var(--parchment); border-radius: 18px; border: 2px dashed var(--sand);">
    <i class="fa fa-filter-circle-xmark fa-4x" style="color:var(--sand); margin-bottom: 20px; opacity: 0.6;"></i>
    <h3 style="color: var(--maroon); font-family: 'Playfair Display'; font-size: 1.5rem;">No Rooms Match These Filters</h3>
    <p style="color: var(--rose); margin-top: 10px;">Try adjusting your criteria or reset the filters to see all inventory.</p>
    <button class="btn btn-outline" style="margin-top: 20px;" onclick="resetFilters()">View All Rooms</button>
</div>
    </div>

    <div id="roomModal" class="modal" style="display: <%= openEditModal %>;">
        <div class="modal-content">
            <span class="close-modal" onclick="closeRoomModal()">&times;</span>
            <h2 style="font-family: 'Playfair Display'; margin-bottom: 25px; color: var(--maroon);"><%= (editRoom != null ? "Update Room" : "Add New Room") %></h2>
            
            <form action="room" method="post" enctype="multipart/form-data">
                <input type="hidden" name="roomId" value="<%= editRoom != null ? editRoom.getRoomId() : "" %>">
                <input type="hidden" name="existingImagePath" value="<%= editRoom != null ? editRoom.getImagePath() : "" %>">

                <div class="field">
                    <label>Room Number</label>
                    <input type="text" name="roomNumber" placeholder="e.g. 101" required value="<%= editRoom != null ? editRoom.getRoomNumber() : "" %>">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="field">
                        <label>Room Type</label>
                        <select name="roomTypeId" required>
                            <option value="">Select Type</option>
                            <% if(types != null) { for(RoomType t : types) { %>
                                <option value="<%= t.getTypeId() %>" <%= (editRoom != null && editRoom.getTypeId() == t.getTypeId() ? "selected" : "") %>>
                                    <%= t.getTypeName() %>
                                </option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="field">
                        <label>AC Type</label>
                        <select name="acType" required>
                            <option value="AC" <%= (editRoom != null && "AC".equals(editRoom.getAcType()) ? "selected" : "") %>>AC</option>
                            <option value="Non-AC" <%= (editRoom != null && "Non-AC".equals(editRoom.getAcType()) ? "selected" : "") %>>Non-AC</option>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="field">
                        <label>Price (LKR)</label>
                        <input type="number" step="0.01" name="price" placeholder="0.00" required value="<%= editRoom != null ? editRoom.getPricePerNight() : "" %>">
                    </div>
                    <div class="field">
                        <label>Status</label>
                        <select name="status" required>
                            <option value="Available" <%= (editRoom != null && "Available".equals(editRoom.getStatus()) ? "selected" : "") %>>Available</option>
                            <option value="Unavailable" <%= (editRoom != null && "Unavailable".equals(editRoom.getStatus()) ? "selected" : "") %>>Unavailable</option>
                        </select>
                    </div>
                </div>

                <div class="field">
                    <label>Room Image</label>
                    <input type="file" name="image" accept="image/*" style="background:transparent; border:none; padding-left:0;">
                </div>

                <div style="display: flex; gap: 10px; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary" style="flex: 2;">Save Room</button>
                    <button type="button" class="btn btn-outline" style="flex: 1;" onclick="closeRoomModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <div id="typeModal" class="modal">
        <div class="modal-content" style="width: 650px;">
            <span class="close-modal" onclick="closeTypeModal()">&times;</span>
            <h2 style="font-family: 'Playfair Display'; margin-bottom: 25px; color: var(--maroon);">Room Types</h2>
            
            <div style="background: rgba(199, 183, 163, 0.2); padding: 25px; border-radius: 12px; margin-bottom: 25px; border: 1px solid var(--sand);">
                <div style="display: flex; gap: 10px; align-items: flex-end;">
                    <input type="hidden" id="ajax_type_id">
                    <div class="field" style="flex:2; margin:0;">
                        <label>Type Name</label>
                        <input type="text" id="ajax_type_name" placeholder="e.g., King Suite">
                    </div>
                    <div class="field" style="flex:1; margin:0;">
                        <label>Capacity</label>
                        <input type="number" id="ajax_type_cap" placeholder="0">
                    </div>
                    <button class="btn btn-primary" onclick="saveTypeAjax()">Save</button>
                </div>
            </div>

            <div id="type_list_div" style="max-height: 300px; overflow-y: auto; border-radius: 8px;">
                </div>
        </div>
    </div>

     <div id="calendarModal" class="modal">
    <div class="modal-content" style="width: 500px;">
        <span class="close-modal" onclick="closeCalendarModal()">&times;</span>
        <h2 id="calendarTitle" style="font-family: 'Playfair Display'; margin-bottom: 20px; color: var(--maroon);">Room Availability</h2>
        
        <div id="calendarContainer" style="background: white; border-radius: 12px; padding: 15px; border: 1px solid var(--sand);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <button class="btn-outline" onclick="changeMonth(-1)" style="padding: 5px 10px; border-radius: 5px;"><i class="fa fa-chevron-left"></i></button>
                <h3 id="currentMonthYear" style="font-size: 1rem; color: var(--rose);"></h3>
                <button class="btn-outline" onclick="changeMonth(1)" style="padding: 5px 10px; border-radius: 5px;"><i class="fa fa-chevron-right"></i></button>
            </div>
            
            <div id="calendarGrid" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; text-align: center;">
                <div style="font-weight: bold; font-size: 0.7rem; color: var(--sand);">SUN</div>
                <div style="font-weight: bold; font-size: 0.7rem; color: var(--sand);">MON</div>
                <div style="font-weight: bold; font-size: 0.7rem; color: var(--sand);">TUE</div>
                <div style="font-weight: bold; font-size: 0.7rem; color: var(--sand);">WED</div>
                <div style="font-weight: bold; font-size: 0.7rem; color: var(--sand);">THU</div>
                <div style="font-weight: bold; font-size: 0.7rem; color: var(--sand);">FRI</div>
                <div style="font-weight: bold; font-size: 0.7rem; color: var(--sand);">SAT</div>
                </div>
        </div>
        
        <div style="margin-top: 20px; display: flex; gap: 15px; font-size: 0.8rem;">
            <div style="display: flex; align-items: center; gap: 5px;">
                <div style="width: 15px; height: 15px; background: #8E354A; border-radius: 3px;"></div>
                <span>Booked</span>
            </div>
            <div style="display: flex; align-items: center; gap: 5px;">
                <div style="width: 15px; height: 15px; background: #eee; border-radius: 3px;"></div>
                <span>Available</span>
            </div>
        </div>
    </div>
</div>
    <div id="toast" class="toast"></div>

    <script>
        // --- Modal Logic ---
        function openRoomModal() { document.getElementById('roomModal').style.display = 'flex'; }
        function closeRoomModal() { 
            document.getElementById('roomModal').style.display = 'none';
            if(window.location.search.includes('action=edit')) window.location.href = 'room';
        }

        function openTypeModal() {
            document.getElementById('typeModal').style.display = 'flex';
            loadTypesAjax();
        }
        function closeTypeModal() { document.getElementById('typeModal').style.display = 'none'; }

        // --- AJAX Room Types ---
        async function loadTypesAjax() {
            const res = await fetch('roomType?action=list');
            const data = await res.json();
            let html = `<table style="width:100%; border-collapse:collapse;">
                <thead><tr style="text-align:left;">
                    <th style="padding:12px; border-bottom:2px solid var(--sand); color:var(--maroon); font-size:0.8rem;">ID</th>
                    <th style="padding:12px; border-bottom:2px solid var(--sand); color:var(--maroon); font-size:0.8rem;">TYPE</th>
                    <th style="padding:12px; border-bottom:2px solid var(--sand); color:var(--maroon); font-size:0.8rem;">CAP.</th>
                    <th style="padding:12px; border-bottom:2px solid var(--sand); text-align:right;"></th>
                </tr></thead><tbody>`;
            data.forEach(t => {
                html += `<tr style="border-bottom:1px solid rgba(199,183,163,0.3);">
                    <td style="padding:12px; font-size:0.85rem;">#\${t.typeId}</td>
                    <td style="padding:12px; font-weight:600; font-size:0.85rem;">\${t.typeName}</td>
                    <td style="padding:12px; font-size:0.85rem;">\${t.capacity}</td>
                    <td style="padding:12px; text-align:right;">
                        <button onclick="editTypeRow(\${t.typeId}, '\${t.typeName}', \${t.capacity})" style="background:none; border:none; cursor:pointer; color:var(--maroon); margin-right:10px;"><i class="fa fa-edit"></i></button>
                        <button onclick="deleteTypeAjax(\${t.typeId})" style="background:none; border:none; cursor:pointer; color:#8E354A;"><i class="fa fa-trash"></i></button>
                    </td>
                </tr>`;
            });
            html += "</tbody></table>";
            document.getElementById('type_list_div').innerHTML = html;
        }

        async function saveTypeAjax() {
            const id = document.getElementById('ajax_type_id').value;
            const name = document.getElementById('ajax_type_name').value;
            const cap = document.getElementById('ajax_type_cap').value;
            
            await fetch('roomType', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `id=\${id}&typeName=\${encodeURIComponent(name)}&capacity=\${cap}`
            });
            showToast("Record Updated Successfully", "success");
            document.getElementById('ajax_type_id').value = "";
            document.getElementById('ajax_type_name').value = "";
            document.getElementById('ajax_type_cap').value = "";
            loadTypesAjax();
        }

        function editTypeRow(id, name, cap) {
            document.getElementById('ajax_type_id').value = id;
            document.getElementById('ajax_type_name').value = name;
            document.getElementById('ajax_type_cap').value = cap;
        }

        async function deleteTypeAjax(id) {
            if(confirm("Deleting this type may affect rooms. Proceed?")) {
                await fetch('roomType?action=delete&id=' + id);
                showToast("Type Removed", "success");
                loadTypesAjax();
            }
        }

        // --- Utility ---
        function deleteRoom(id) {
            if(confirm("Are you sure you want to permanently delete this room?")) {
                window.location.href = "room?action=delete&id=" + id;
            }
        }

        function showToast(msg, type) {
            const t = document.getElementById('toast');
            t.innerText = msg;
            t.className = "toast show " + (type === 'success' ? 'success' : 'error');
            setTimeout(() => { t.classList.remove('show'); }, 3000);
        }

        <% String tMsg = (String)session.getAttribute("toastMessage"); 
           String tType = (String)session.getAttribute("toastType");
           if(tMsg != null) { %>
            window.onload = () => showToast("<%= tMsg %>", "<%= tType %>");
        <% session.removeAttribute("toastMessage"); session.removeAttribute("toastType"); } %>
            
            let currentRoomId = null;
let currentViewDate = new Date();
let bookedDates = [];

async function openCalendar(roomId, roomNum) {
    currentRoomId = roomId;
    document.getElementById('calendarTitle').innerText = "Room " + roomNum + " Availability";
    document.getElementById('calendarModal').style.display = 'flex';
    
    try {
        const res = await fetch("/Ocean_View_Resort/api/rooms/" + roomId);
        const ranges = await res.json();
        
        bookedDates = [];
        ranges.forEach(r => {
            // Convert "YYYY-MM-DD" strings to Date objects
            let start = new Date(r.start + "T00:00:00");
            let end = new Date(r.end + "T00:00:00");
            
            let current = new Date(start);
            while (current <= end) {
                // Format back to YYYY-MM-DD manually
                let y = current.getFullYear();
                let m = String(current.getMonth() + 1).padStart(2, '0');
                let d = String(current.getDate()).padStart(2, '0');
                bookedDates.push(y + "-" + m + "-" + d);
                
                current.setDate(current.getDate() + 1);
            }
        });
        
        renderCalendar();
    } catch (error) {
        console.error("Calendar fetch error:", error);
    }
}

function closeCalendarModal() {
    document.getElementById('calendarModal').style.display = 'none';
}

function changeMonth(dir) {
    currentViewDate.setMonth(currentViewDate.getMonth() + dir);
    renderCalendar();
}

function renderCalendar() {
    const month = currentViewDate.getMonth();
    const year = currentViewDate.getFullYear();
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    
    document.getElementById('currentMonthYear').innerText = 
        new Intl.DateTimeFormat('en-US', { month: 'long', year: 'numeric' }).format(currentViewDate);
    
    const grid = document.getElementById('calendarGrid');
    const headers = grid.querySelectorAll('div:nth-child(-n+7)');
    grid.innerHTML = "";
    headers.forEach(h => grid.appendChild(h));

    for (let i = 0; i < firstDay; i++) {
        grid.innerHTML += '<div></div>';
    }

    for (let day = 1; day <= daysInMonth; day++) {
        // Construct YYYY-MM-DD string
        const monthStr = String(currentViewDate.getMonth() + 1).padStart(2, '0');
        const dayStr = String(day).padStart(2, '0');
        const yearStr = currentViewDate.getFullYear();
        
        const dateStr = yearStr + "-" + monthStr + "-" + dayStr;
        
        // Match against our array
        const isBooked = bookedDates.includes(dateStr);
        
        const style = isBooked 
            ? "background: #8E354A; color: white; border-radius: 5px; font-weight: bold;" 
            : "background: #f9f9f9; color: #333;";
        
        grid.innerHTML += '<div style="padding: 10px 0; font-size: 0.8rem; cursor: default; ' + style + '">' + day + '</div>';
    }
}
function filterRooms() {
    const selectedType = document.getElementById('filterRoomType').value;
    const selectedAc = document.getElementById('filterAcType').value;
    const cards = document.querySelectorAll('.room-card');
    const noMatchMessage = document.getElementById('noMatchMessage');
    
    let visibleCount = 0;

    cards.forEach(card => {
        const roomType = card.getAttribute('data-type');
        const acType = card.getAttribute('data-ac');

        const typeMatch = (selectedType === 'all' || roomType === selectedType);
        const acMatch = (selectedAc === 'all' || acType === selectedAc);

        if (typeMatch && acMatch) {
            card.style.display = 'flex';
            visibleCount++;
        } else {
            card.style.display = 'none';
        }
    });

    // Show or hide the "No Match" message based on the count
    if (visibleCount === 0) {
        noMatchMessage.style.display = 'block';
    } else {
        noMatchMessage.style.display = 'none';
    }
}

// Ensure reset also hides the message
function resetFilters() {
    document.getElementById('filterRoomType').value = 'all';
    document.getElementById('filterAcType').value = 'all';
    filterRooms();
}
function resetFilters() {
    document.getElementById('filterRoomType').value = 'all';
    document.getElementById('filterAcType').value = 'all';
    filterRooms();
}
// Function to update the text next to the slider as you move it
function updatePriceLabel(val) {
    document.getElementById('priceValue').innerText = "LKR " + parseInt(val).toLocaleString();
}

function filterRooms() {
    const selectedType = document.getElementById('filterRoomType').value;
    const selectedAc = document.getElementById('filterAcType').value;
    const maxPrice = parseFloat(document.getElementById('priceRange').value);
    
    const cards = document.querySelectorAll('.room-card');
    const noMatchMessage = document.getElementById('noMatchMessage');
    
    let visibleCount = 0;

    cards.forEach(card => {
        const roomType = card.getAttribute('data-type');
        const acType = card.getAttribute('data-ac');
        const roomPrice = parseFloat(card.getAttribute('data-price'));

        // Logic: All 3 conditions must be true
        const typeMatch = (selectedType === 'all' || roomType === selectedType);
        const acMatch = (selectedAc === 'all' || acType === selectedAc);
        const priceMatch = (roomPrice <= maxPrice);

        if (typeMatch && acMatch && priceMatch) {
            card.style.display = 'flex';
            visibleCount++;
        } else {
            card.style.display = 'none';
        }
    });

    // Handle Empty State
    noMatchMessage.style.display = (visibleCount === 0) ? 'block' : 'none';
}

function resetFilters() {
    document.getElementById('filterRoomType').value = 'all';
    document.getElementById('filterAcType').value = 'all';
    
    const priceSlider = document.getElementById('priceRange');
    priceSlider.value = 100000;
    updatePriceLabel(100000);
    
    filterRooms();
}
    </script>

</body>
</html>