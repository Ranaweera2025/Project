<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Dashboard - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .menu-items {
            @apply rounded py-[5px] px-[5px] my-[8px] hover:bg-gray-100 transition delay-10 duration-600 ease-in-out cursor-pointer
        }
        .my-gradiant {
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
        .dashboard-card {
            @apply bg-white rounded-lg shadow-md p-6 transition-all duration-300 hover:shadow-lg
        }
        .dashboard-stat {
            @apply text-2xl font-bold
        }
        .input-field {
            @apply w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 transition duration-300 ease-in-out
        }
        .btn-primary {
            @apply bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-lg font-semibold transition duration-300 ease-in-out
        }
        .btn-secondary {
            @apply bg-gray-200 hover:bg-gray-300 text-gray-800 py-2 px-4 rounded-lg font-semibold transition duration-300 ease-in-out
        }
        .btn-danger {
            @apply bg-red-500 hover:bg-red-600 text-white py-2 px-4 rounded-lg font-semibold transition duration-300 ease-in-out
        }
        .tab-active {
            @apply border-b-2 border-green-500 text-green-600 font-medium
        }
        .tab-inactive {
            @apply text-gray-500 hover:text-gray-700 cursor-pointer
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Include header -->
<%@ include file="header.jsp" %>
<c:if test="${not empty error}">
    <div class="fixed top-4 right-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded z-50" id="error-message">
            ${error}
        <button onclick="document.getElementById('error-message').remove()" class="ml-2 text-red-800 font-bold">&times;</button>
    </div>
    <script>
        setTimeout(() => {
            document.getElementById('error-message').remove();
        }, 5000);
    </script>
</c:if>

<div class="container mx-auto px-4 py-8">
    <!-- Welcome, Banner -->
    <div class="bg-gradient-to-r from-green-600 to-green-400 text-white rounded-lg shadow-md p-6 mb-8">
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold mb-2">Welcome, <%= user.getUsername() %>!</h1>
                <p class="text-green-100">
                    <i class="fas fa-user-tag mr-2"></i>Account Type: <span class="font-semibold"><%= user.getRole() %></span>
                </p>
            </div>
            <div class="hidden md:block">
                <img src="${pageContext.request.contextPath}/resources/images/dashboard-welcome.jpg" alt="Welcome" class="h-24">
            </div>
        </div>
    </div>

    <!-- Dashboard Content -->
    <div class="flex flex-col md:flex-row gap-8">
        <!-- Sidebar -->
        <div class="w-full md:w-1/4">
            <div class="dashboard-card mb-6">
                <div class="flex items-center space-x-4 mb-6">
                    <div class="bg-green-100 p-3 rounded-full">
                        <i class="fas fa-user text-green-600 text-xl"></i>
                    </div>
                    <div>
                        <h2 class="text-lg font-semibold"><%= user.getUsername() %></h2>
                        <p class="text-sm text-gray-500"><%= user.getEmail() %></p>
                    </div>
                </div>

                <ul class="space-y-2">
                    <li>
                        <a href="#profile" onclick="showTab('profile')" class="flex items-center p-2 rounded-md hover:bg-gray-100">
                            <i class="fas fa-id-card w-6 text-green-600"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="#appointments" onclick="showTab('appointments')" class="flex items-center p-2 rounded-md hover:bg-gray-100">
                            <i class="fas fa-calendar-check w-6 text-green-600"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="#prescriptions" onclick="showTab('prescriptions')" class="flex items-center p-2 rounded-md hover:bg-gray-100">
                            <i class="fas fa-prescription w-6 text-green-600"></i>
                            <span>Prescriptions</span>
                        </a>
                    </li>
                    <li>
                        <a href="#orders" onclick="showTab('orders')" class="flex items-center p-2 rounded-md hover:bg-gray-100">
                            <i class="fas fa-shopping-bag w-6 text-green-600"></i>
                            <span>My Orders</span>
                        </a>
                    </li>
                    <% if ("admin".equals(user.getRole())) { %>
                    <li>
                        <a href="#admin" onclick="showTab('admin')" class="flex items-center p-2 rounded-md hover:bg-gray-100">
                            <i class="fas fa-shield-alt w-6 text-green-600"></i>
                            <span>Admin Panel</span>
                        </a>
                    </li>
                    <% } %>
                </ul>

                <div class="mt-6 pt-6 border-t border-gray-200">
                    <a href="logout.jsp" class="flex items-center p-2 text-red-500 rounded-md hover:bg-red-50">
                        <i class="fas fa-sign-out-alt w-6"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>

            <div class="dashboard-card">
                <h3 class="font-semibold mb-4">Need Help?</h3>
                <p class="text-sm text-gray-600 mb-4">Contact our support team for assistance with your account or services.</p>
                <a href="#" class="text-green-600 text-sm flex items-center hover:underline">
                    <i class="fas fa-headset mr-2"></i> Contact Support
                </a>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="w-full md:w-3/4">
            <!-- Profile Tab -->
            <div id="profile-tab" class="tab-content">
                <div class="dashboard-card mb-6">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-xl font-bold">My Profile</h2>
                        <button id="edit-profile-btn" onclick="toggleEditMode()" class="btn-secondary">
                            <i class="fas fa-edit mr-2"></i> Edit Profile
                        </button>
                    </div>

                    <!-- Success message -->
                    <div id="update-success" class="hidden bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                        <i class="fas fa-check-circle mr-2"></i> Your profile has been updated successfully!
                    </div>

                    <!-- Profile View Mode -->
                    <div id="profile-view" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <p class="text-gray-500 text-sm mb-1">Username</p>
                            <p class="font-medium"><%= user.getUsername() %></p>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm mb-1">Email Address</p>
                            <p class="font-medium"><%= user.getEmail() %></p>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm mb-1">Phone Number</p>
                            <p class="font-medium"><%= user.getPhone() != null ? user.getPhone() : "Not provided" %></p>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm mb-1">Address</p>
                            <p class="font-medium"><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></p>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm mb-1">Account Type</p>
                            <p class="font-medium"><%= user.getRole() %></p>
                        </div>
                    </div>

                    <!-- Profile Edit Mode -->
                    <form id="profile-edit" action="updateProfile" method="post" class="hidden">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="username" class="block text-gray-500 text-sm mb-1">Username</label>
                                <input type="text" id="username" name="username" value="<%= user.getUsername() %>" class="input-field" readonly>
                            </div>
                            <div>
                                <label for="email" class="block text-gray-500 text-sm mb-1">Email Address</label>
                                <input type="email" id="email" name="email" value="<%= user.getEmail() %>" class="input-field" required>
                            </div>
                            <div>
                                <label for="phone" class="block text-gray-500 text-sm mb-1">Phone Number</label>
                                <input type="tel" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" class="input-field">
                            </div>
                            <div>
                                <label for="address" class="block text-gray-500 text-sm mb-1">Address</label>
                                <input type="text" id="address" name="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" class="input-field">
                            </div>
                            <div>
                                <label for="password" class="block text-gray-500 text-sm mb-1">New Password (leave blank to keep current)</label>
                                <input type="password" id="password" name="password" class="input-field">
                            </div>
                            <div>
                                <label for="confirmPassword" class="block text-gray-500 text-sm mb-1">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="input-field">
                            </div>
                        </div>

                        <div class="mt-6 flex justify-end space-x-4">
                            <button type="button" onclick="toggleEditMode()" class="btn-secondary">Cancel</button>
                            <button type="submit" class="btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>

                <div class="dashboard-card">
                    <h2 class="text-xl font-bold mb-6 text-red-600">Danger Zone</h2>
                    <p class="text-gray-600 mb-4">Permanently delete your account and all associated data.</p>
                    <button onclick="confirmDeleteAccount()" class="btn-danger">
                        <i class="fas fa-trash-alt mr-2"></i> Delete Account
                    </button>
                </div>
            </div>

            <!-- Appointments Tab -->
            <div id="appointments-tab" class="tab-content hidden">
                <div class="dashboard-card">
                    <h2 class="text-xl font-bold mb-6">My Appointments</h2>
                    <div class="flex justify-between items-center mb-6">
                        <div class="relative">
                            <input type="text" placeholder="Search appointments..." class="pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                        <button class="btn-primary">
                            <i class="fas fa-plus mr-2"></i> New Appointment
                        </button>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="min-w-full bg-white">
                            <thead class="bg-gray-50 text-gray-600 text-sm">
                            <tr>
                                <th class="py-3 px-4 text-left">Doctor</th>
                                <th class="py-3 px-4 text-left">Date & Time</th>
                                <th class="py-3 px-4 text-left">Status</th>
                                <th class="py-3 px-4 text-left">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="text-gray-700 divide-y divide-gray-200">
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">Dr. Sarah Johnson</td>
                                <td class="py-3 px-4">Oct 15, 2023 - 10:30 AM</td>
                                <td class="py-3 px-4"><span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">Confirmed</span></td>
                                <td class="py-3 px-4">
                                    <button class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                                    <button class="text-red-500 hover:text-red-700"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">Dr. Sarah Johnson</td>
                                <td class="py-3 px-4">Oct 15, 2023 - 10:30 AM</td>
                                <td class="py-3 px-4"><span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">Confirmed</span></td>
                                <td class="py-3 px-4">
                                    <button class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                                    <button class="text-red-500 hover:text-red-700"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">Dr. Michael Chen</td>
                                <td class="py-3 px-4">Oct 22, 2023 - 2:00 PM</td>
                                <td class="py-3 px-4"><span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">Pending</span></td>
                                <td class="py-3 px-4">
                                    <button class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                                    <button class="text-red-500 hover:text-red-700"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">Dr. Emily Rodriguez</td>
                                <td class="py-3 px-4">Nov 5, 2023 - 9:15 AM</td>
                                <td class="py-3 px-4"><span class="px-2 py-1 bg-blue-100 text-blue-800 rounded-full text-xs">Upcoming</span></td>
                                <td class="py-3 px-4">
                                    <button class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                                    <button class="text-red-500 hover:text-red-700"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-6 flex justify-between items-center">
                        <p class="text-sm text-gray-500">Showing 3 of 3 appointments</p>
                        <div class="flex space-x-2">
                            <button class="px-3 py-1 border rounded bg-gray-100 text-gray-600 hover:bg-gray-200">Previous</button>
                            <button class="px-3 py-1 border rounded bg-gray-100 text-gray-600 hover:bg-gray-200">Next</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Prescriptions Tab -->
            <div id="prescriptions-tab" class="tab-content hidden">
                <div class="dashboard-card">
                    <h2 class="text-xl font-bold mb-6">My Prescriptions</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="border rounded-lg p-4 hover:shadow-md transition-shadow">
                            <div class="flex justify-between items-start mb-3">
                                <div>
                                    <h3 class="font-semibold">Prescription #12345</h3>
                                    <p class="text-sm text-gray-500">Dr. Sarah Johnson</p>
                                </div>
                                <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">Active</span>
                            </div>
                            <p class="text-sm text-gray-600 mb-3">Issued: Oct 10, 2023</p>
                            <div class="space-y-2">
                                <div class="flex justify-between text-sm">
                                    <span>Amoxicillin 500mg</span>
                                    <span>3x daily for 7 days</span>
                                </div>
                                <div class="flex justify-between text-sm">
                                    <span>Ibuprofen 200mg</span>
                                    <span>As needed for pain</span>
                                </div>
                            </div>
                            <div class="mt-4 flex justify-end">
                                <button class="text-green-600 hover:text-green-800 text-sm font-medium">
                                    <i class="fas fa-file-download mr-1"></i> Download PDF
                                </button>
                            </div>
                        </div>

                        <div class="border rounded-lg p-4 hover:shadow-md transition-shadow">
                            <div class="flex justify-between items-start mb-3">
                                <div>
                                    <h3 class="font-semibold">Prescription #12289</h3>
                                    <p class="text-sm text-gray-500">Dr. Michael Chen</p>
                                </div>
                                <span class="px-2 py-1 bg-gray-100 text-gray-800 rounded-full text-xs">Expired</span>
                            </div>
                            <p class="text-sm text-gray-600 mb-3">Issued: Sep 15, 2023</p>
                            <div class="space-y-2">
                                <div class="flex justify-between text-sm">
                                    <span>Lisinopril 10mg</span>
                                    <span>1x daily</span>
                                </div>
                                <div class="flex justify-between text-sm">
                                    <span>Atorvastatin 20mg</span>
                                    <span>1x daily at bedtime</span>
                                </div>
                            </div>
                            <div class="mt-4 flex justify-end">
                                <button class="text-green-600 hover:text-green-800 text-sm font-medium">
                                    <i class="fas fa-file-download mr-1"></i> Download PDF
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="mt-6">
                        <button class="btn-primary">
                            <i class="fas fa-sync-alt mr-2"></i> Request Refill
                        </button>
                    </div>
                </div>
            </div>

            <!-- Orders Tab -->
            <div id="orders-tab" class="tab-content hidden">
                <div class="dashboard-card">
                    <h2 class="text-xl font-bold mb-6">My Orders</h2>

                    <div class="overflow-x-auto">
                        <table class="min-w-full bg-white">
                            <thead class="bg-gray-50 text-gray-600 text-sm">
                            <tr>
                                <th class="py-3 px-4 text-left">Order ID</th>
                                <th class="py-3 px-4 text-left">Date</th>
                                <th class="py-3 px-4 text-left">Items</th>
                                <th class="py-3 px-4 text-left">Total</th>
                                <th class="py-3 px-4 text-left">Status</th>
                                <th class="py-3 px-4 text-left">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="text-gray-700 divide-y divide-gray-200">
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">#ORD-2023-001</td>
                                <td class="py-3 px-4">Oct 12, 2023</td>
                                <td class="py-3 px-4">3 items</td>
                                <td class="py-3 px-4">$45.99</td>
                                <td class="py-3 px-4"><span class="px-2 py-1 bg-blue-100 text-blue-800 rounded-full text-xs">Shipped</span></td>
                                <td class="py-3 px-4">
                                    <button class="text-blue-500 hover:text-blue-700">View Details</button>
                                </td>
                            </tr>
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">#ORD-2023-002</td>
                                <td class="py-3 px-4">Sep 28, 2023</td>
                                <td class="py-3 px-4">1 item</td>
                                <td class="py-3 px-4">$12.50</td>
                                <td class="py-3 px-4"><span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">Delivered</span></td>
                                <td class="py-3 px-4">
                                    <button class="text-blue-500 hover:text-blue-700">View Details</button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Admin Panel Tab (only for admin users) -->
            <% if ("admin".equals(user.getRole())) { %>
            <div id="admin-tab" class="tab-content hidden">
                <div class="dashboard-card">
                    <h2 class="text-xl font-bold mb-6">Admin Panel</h2>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="bg-blue-50 p-4 rounded-lg border border-blue-100">
                            <h3 class="text-lg font-semibold text-blue-700 mb-2">Total Users</h3>
                            <p class="dashboard-stat text-blue-700">245</p>
                            <p class="text-sm text-blue-600 mt-2">+12% from last month</p>
                        </div>

                        <div class="bg-green-50 p-4 rounded-lg border border-green-100">
                            <h3 class="text-lg font-semibold text-green-700 mb-2">Appointments</h3>
                            <p class="dashboard-stat text-green-700">128</p>
                            <p class="text-sm text-green-600 mt-2">+5% from last month</p>
                        </div>

                        <div class="bg-purple-50 p-4 rounded-lg border border-purple-100">
                            <h3 class="text-lg font-semibold text-purple-700 mb-2">Total Orders</h3>
                            <p class="dashboard-stat text-purple-700">89</p>
                            <p class="text-sm text-purple-600 mt-2">+18% from last month</p>
                        </div>
                    </div>

                    <div class="mb-6">
                        <h3 class="text-lg font-semibold mb-4">Recent Users</h3>
                        <div class="overflow-x-auto">
                            <table class="min-w-full bg-white">
                                <thead class="bg-gray-50 text-gray-600 text-sm">
                                <tr>
                                    <th class="py-3 px-4 text-left">Username</th>
                                    <th class="py-3 px-4 text-left">Email</th>
                                    <th class="py-3 px-4 text-left">Role</th>
                                    <th class="py-3 px-4 text-left">Joined Date</th>
                                    <th class="py-3 px-4 text-left">Actions</th>
                                </tr>
                                </thead>
                                <tbody class="text-gray-700 divide-y divide-gray-200">
                                <tr class="hover:bg-gray-50">
                                    <td class="py-3 px-4">johndoe</td>
                                    <td class="py-3 px-4">john.doe@example.com</td>
                                    <td class="py-3 px-4">Patient</td>
                                    <td class="py-3 px-4">Oct 10, 2023</td>
                                    <td class="py-3 px-4">
                                        <button class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                                        <button class="text-red-500 hover:text-red-700"><i class="fas fa-trash-alt"></i></button>
                                    </td>
                                </tr>
                                <tr class="hover:bg-gray-50">
                                    <td class="py-3 px-4">sarahjohnson</td>
                                    <td class="py-3 px-4">sarah.j@example.com</td>
                                    <td class="py-3 px-4">Doctor</td>
                                    <td class="py-3 px-4">Oct 8, 2023</td>
                                    <td class="py-3 px-4">
                                        <button class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                                        <button class="text-red-500 hover:text-red-700"><i class="fas fa-trash-alt"></i></button>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="mt-6">
                        <a href="adminProductManagement.jsp" class="btn-primary">
                            <i class="fas fa-box-open mr-2"></i> Manage Products
                        </a>
                    </div>

                    <div class="mt-6">
                        <a href="admin/dashboard" class="btn-primary">
                            <i class="fas fa-cog mr-2"></i> Full Admin Dashboard
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Include footer -->
<%@ include file="footer.jsp" %>

<!-- Delete Account Confirmation Modal -->
<div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
    <div class="bg-white rounded-lg p-8 max-w-md w-full">
        <h3 class="text-xl font-bold text-red-600 mb-4">Delete Account</h3>
        <p class="text-gray-700 mb-6">Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.</p>
        <div class="flex justify-end space-x-4">
            <button onclick="closeDeleteModal()" class="btn-secondary">Cancel</button>
            <form action="deleteAccount" method="post">
                <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                <button type="submit" class="btn-danger">Delete Permanently</button>
            </form>
        </div>
    </div>
</div>

<script>
    // Tab switching functionality
    function showTab(tabName) {
        // Hide all tab contents
        const tabContents = document.querySelectorAll('.tab-content');
        tabContents.forEach(tab => tab.classList.add('hidden'));

        // Show the selected tab
        document.getElementById(tabName + '-tab').classList.remove('hidden');

        // Update URL hash
        window.location.hash = tabName;
    }

    // Toggle profile edit mode
    function toggleEditMode() {
        const viewMode = document.getElementById('profile-view');
        const editMode = document.getElementById('profile-edit');
        const editBtn = document.getElementById('edit-profile-btn');

        if (viewMode.classList.contains('hidden')) {
            // Switch to view mode
            viewMode.classList.remove('hidden');
            editMode.classList.add('hidden');
            editBtn.innerHTML = '<i class="fas fa-edit mr-2"></i> Edit Profile';
        } else {
            // Switch to edit mode
            viewMode.classList.add('hidden');
            editMode.classList.remove('hidden');
            editBtn.innerHTML = '<i class="fas fa-times mr-2"></i> Cancel';
        }
    }

    // Delete account modal
    function confirmDeleteAccount() {
        document.getElementById('deleteModal').classList.remove('hidden');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.add('hidden');
    }

    // Check for URL hash on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Show success message if present in URL params
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('updated') === 'true') {
            document.getElementById('update-success').classList.remove('hidden');
            setTimeout(() => {
                document.getElementById('update-success').classList.add('hidden');
            }, 5000);
        }

        // Check for hash in URL
        const hash = window.location.hash.substring(1);
        if (hash && ['profile', 'appointments', 'prescriptions', 'orders', 'admin'].includes(hash)) {
            showTab(hash);
        } else {
            showTab('profile'); // Default tab
        }

        // Password validation
        const passwordForm = document.getElementById('profile-edit');
        if (passwordForm) {
            passwordForm.addEventListener('submit', function(event) {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                if (password && password !== confirmPassword) {
                    event.preventDefault();
                    alert('Passwords do not match!');
                }
            });
        }
    });
</script>
</body>
</html>

