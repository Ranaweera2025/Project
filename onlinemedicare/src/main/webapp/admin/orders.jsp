<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Order" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Map<String, Map<Product, Integer>> orderProducts =
        (Map<String, Map<Product, Integer>>) request.getAttribute("orderProducts");
    Map<String, User> orderUsers = (Map<String, User>) request.getAttribute("orderUsers");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Order Management</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .my-gradiant {
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
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
        .status-badge {
            @apply px-3 py-1 rounded-full text-sm font-medium
        }
        .admin-sidebar {
            @apply w-64 bg-gray-800 text-white fixed h-full left-0 top-0 overflow-y-auto transition-all duration-300 ease-in-out
        }
        .admin-content {
            @apply ml-64 p-8 transition-all duration-300 ease-in-out
        }
        .admin-sidebar-link {
            @apply flex items-center px-6 py-3 text-gray-300 hover:bg-gray-700 hover:text-white transition duration-200
        }
        .admin-sidebar-link.active {
            @apply bg-gray-700 text-white
        }
    </style>
</head>
<body class="bg-gray-100">
    <!-- Admin Sidebar -->
    <div class="admin-sidebar">
        <div class="p-6 border-b border-gray-700">
            <h1 class="text-xl font-bold">MediCare Admin</h1>
            <p class="text-sm text-gray-400">Order Management</p>
        </div>

        <nav class="mt-6">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-sidebar-link">
                <i class="fas fa-tachometer-alt w-6"></i>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-sidebar-link">
                <i class="fas fa-box w-6"></i>
                <span>Products</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-sidebar-link active">
                <i class="fas fa-shopping-cart w-6"></i>
                <span>Orders</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="admin-sidebar-link">
                <i class="fas fa-users w-6"></i>
                <span>Users</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/prescriptions" class="admin-sidebar-link">
                <i class="fas fa-prescription w-6"></i>
                <span>Prescriptions</span>
            </a>
            <div class="border-t border-gray-700 my-4"></div>
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-sidebar-link">
                <i class="fas fa-home w-6"></i>
                <span>Back to Site</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="admin-sidebar-link text-red-400 hover:text-red-300">
                <i class="fas fa-sign-out-alt w-6"></i>
                <span>Logout</span>
            </a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="admin-content">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Order Management</h1>
            <div class="flex space-x-4">
                <div class="relative">
                    <input type="text" placeholder="Search orders..." class="pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                </div>
                <select class="border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-green-500">
                    <option value="">All Statuses</option>
                    <option value="PENDING">Pending</option>
                    <option value="PROCESSING">Processing</option>
                    <option value="SHIPPED">Shipped</option>
                    <option value="DELIVERED">Delivered</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>
            </div>
        </div>

        <c:if test="${param.updated == 'true'}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-check-circle mr-2"></i> Order status has been updated successfully.
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-exclamation-circle mr-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'updateFailed'}">Failed to update order status.</c:when>
                    <c:when test="${param.error == 'invalidInput'}">Invalid input parameters.</c:when>
                    <c:otherwise>An error occurred.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 text-gray-600 text-sm">
                        <tr>
                            <th class="py-3 px-4 text-left">Order ID</th>
                            <th class="py-3 px-4 text-left">Customer</th>
                            <th class="py-3 px-4 text-left">Date</th>
                            <th class="py-3 px-4 text-left">Items</th>
                            <th class="py-3 px-4 text-right">Total</th>
                            <th class="py-3 px-4 text-center">Status</th>
                            <th class="py-3 px-4 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                        <c:forEach var="order" items="${orders}">
                            <c:set var="user" value="${orderUsers[order.orderId]}" />
                            <c:set var="items" value="${orderProducts[order.orderId]}" />
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">${order.orderId}</td>
                                <td class="py-3 px-4">
                                    <c:if test="${not empty user}">
                                        <div>
                                            <span class="font-medium">${user.username}</span>
                                            <div class="text-xs text-gray-500">${user.email}</div>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty user}">
                                        <span class="text-gray-500">User not found</span>
                                    </c:if>
                                </td>
                                <td class="py-3 px-4">${order.orderDate}</td>
                                <td class="py-3 px-4">
                                    <c:if test="${not empty items}">
                                        ${items.size()} item(s)
                                    </c:if>
                                    <c:if test="${empty items}">
                                        0 items
                                    </c:if>
                                </td>
                                <td class="py-3 px-4 text-right">$${String.format("%.2f", order.totalAmount)}</td>
                                <td class="py-3 px-4 text-center">
                                                                        <span class="status-badge
                                        ${order.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' :
                                          order.status == 'PROCESSING' ? 'bg-blue-100 text-blue-800' :
                                          order.status == 'SHIPPED' ? 'bg-purple-100 text-purple-800' :
                                          order.status == 'DELIVERED' ? 'bg-green-100 text-green-800' :
                                          'bg-red-100 text-red-800'}">
                                                                                ${order.status}
                                                                        </span>
                                </td>
                                <td class="py-3 px-4 text-center">
                                    <div class="flex justify-center space-x-2">
                                        <button onclick="showOrderDetails('${order.orderId}')" class="text-blue-600 hover:text-blue-800">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button onclick="showUpdateStatus('${order.orderId}', '${order.status}')" class="text-green-600 hover:text-green-800">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="7" class="py-6 text-center text-gray-500">No orders found</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Order Details Modal -->
    <div id="orderDetailsModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
        <div class="bg-white rounded-lg shadow-xl p-6 w-11/12 max-w-4xl max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold" id="orderDetailsTitle">Order Details</h3>
                <button onclick="closeOrderDetails()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div id="orderDetailsContent" class="mt-4">
                <!-- Content will be loaded dynamically -->
                <div class="animate-pulse">
                    <div class="h-6 bg-gray-200 rounded w-1/4 mb-4"></div>
                    <div class="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
                    <div class="h-4 bg-gray-200 rounded w-3/4 mb-6"></div>

                    <div class="h-64 bg-gray-200 rounded mb-6"></div>

                    <div class="h-10 bg-gray-200 rounded w-full mb-4"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Update Status Modal -->
    <div id="updateStatusModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
        <div class="bg-white rounded-lg shadow-xl p-6 w-11/12 max-w-md">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold">Update Order Status</h3>
                <button onclick="closeUpdateStatus()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/updateOrderStatus" method="post">
                <input type="hidden" id="updateOrderId" name="orderId" value="">

                <div class="mb-4">
                    <label for="status" class="block text-gray-700 mb-2">New Status</label>
                    <select id="status" name="status" class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                        <option value="PENDING">Pending</option>
                        <option value="PROCESSING">Processing</option>
                        <option value="SHIPPED">Shipped</option>
                        <option value="DELIVERED">Delivered</option>
                        <option value="CANCELLED">Cancelled</option>
                    </select>
                </div>

                <div class="flex justify-end space-x-3 mt-6">
                    <button type="button" onclick="closeUpdateStatus()" class="btn-secondary">Cancel</button>
                    <button type="submit" class="btn-primary">Update Status</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Show order details modal
        function showOrderDetails(orderId) {
            // In a real application, you would fetch order details via AJAX
            // For this example, we'll simulate loading the data
            document.getElementById('orderDetailsTitle').textContent = 'Order #' + orderId;
            document.getElementById('orderDetailsModal').classList.remove('hidden');

            // Simulate loading data
            setTimeout(() => {
                const orderDetails = getOrderDetailsById(orderId);
                document.getElementById('orderDetailsContent').innerHTML = orderDetails;
            }, 500);
        }

        // Close order details modal
        function closeOrderDetails() {
            document.getElementById('orderDetailsModal').classList.add('hidden');
        }

        // Show update status modal
        function showUpdateStatus(orderId, currentStatus) {
            document.getElementById('updateOrderId').value = orderId;
            document.getElementById('status').value = currentStatus;
            document.getElementById('updateStatusModal').classList.remove('hidden');
        }

        // Close update status modal
        function closeUpdateStatus() {
            document.getElementById('updateStatusModal').classList.add('hidden');
        }

        // Get order details by ID (simulated)
        function getOrderDetailsById(orderId) {
            // In a real application, this would be fetched from the server
            // For this example, we'll return a static HTML template

            // Find the order in our existing data
            const orders = ${orders != null ? orders.size() : 0};

            if (orders === 0) {
                return '<p class="text-gray-500">Order details not available</p>';
            }

            // This is a simplified example - in a real app, you would use AJAX to fetch the details
            return `
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <h4 class="font-semibold text-gray-700 mb-2">Order Information</h4>
                        <p><span class="text-gray-600">Order ID:</span> ${orderId}</p>
                        <p><span class="text-gray-600">Date:</span> ${new_Date().toLocaleDateString()}</p>
                        <p><span class="text-gray-600">Status:</span> <span class="status-badge bg-blue-100 text-blue-800">Processing</span></p>
                    </div>
                    <div>
                        <h4 class="font-semibold text-gray-700 mb-2">Customer Information</h4>
                        <p><span class="text-gray-600">Name:</span> John Doe</p>
                        <p><span class="text-gray-600">Email:</span> john.doe@example.com</p>
                        <p><span class="text-gray-600">Phone:</span> (555) 123-4567</p>
                    </div>
                </div>

                <h4 class="font-semibold text-gray-700 mb-2">Order Items</h4>
                <div class="overflow-x-auto mb-6">
                    <table class="w-full">
                        <thead class="bg-gray-50 text-gray-600 text-sm">
                            <tr>
                                <th class="py-2 px-4 text-left">Product</th>
                                <th class="py-2 px-4 text-center">Quantity</th>
                                <th class="py-2 px-4 text-right">Price</th>
                                <th class="py-2 px-4 text-right">Total</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <tr>
                                <td class="py-2 px-4">
                                    <div class="flex items-center">
                                        <div class="w-10 h-10 bg-gray-100 rounded overflow-hidden flex-shrink-0">
                                            <img src="${pageContext.request.contextPath}/resources/images/CProduct1.jpg"
                                                 alt="Product"
                                                 class="w-full h-full object-contain p-1">
                                        </div>
                                        <div class="ml-3">
                                            <h4 class="font-medium">Sample Product</h4>
                                        </div>
                                    </div>
                                </td>
                                <td class="py-2 px-4 text-center">2</td>
                                <td class="py-2 px-4 text-right">$24.99</td>
                                <td class="py-2 px-4 text-right">$49.98</td>
                            </tr>
                        </tbody>
                        <tfoot class="bg-gray-50">
                            <tr>
                                <td colspan="3" class="py-2 px-4 text-right font-semibold">Total</td>
                                <td class="py-2 px-4 text-right font-bold">$49.98</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="flex justify-end space-x-3">
                    <button onclick="showUpdateStatus('${orderId}', 'PROCESSING')" class="btn-primary">
                        <i class="fas fa-edit mr-2"></i> Update Status
                    </button>
                </div>
            `;
        }
    </script>
</body>
</html>
