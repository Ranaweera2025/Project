<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Order" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>
<%@ page import="java.util.Map" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Order order = (Order) request.getAttribute("order");
    Map<Product, Integer> orderItems = (Map<Product, Integer>) request.getAttribute("orderItems");
    User orderUser = (User) request.getAttribute("orderUser");

    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Order Detail</title>
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
    <div class="flex items-center mb-6">
        <a href="${pageContext.request.contextPath}/admin/orders" class="text-green-600 hover:text-green-800">
            <i class="fas fa-arrow-left mr-2"></i> Back to Orders
        </a>
    </div>

    <div class="bg-white rounded-lg shadow-md overflow-hidden">
        <div class="p-6 border-b">
            <div class="flex flex-col md:flex-row justify-between items-start">
                <div>
                    <h1 class="text-2xl font-bold">Order #${order.orderId}</h1>
                    <p class="text-gray-600">Placed on ${order.orderDate}</p>
                </div>
                <div class="mt-4 md:mt-0 flex items-center">
                        <span class="status-badge mr-4
                            ${order.status == 'PENDING' ? 'bg-yellow-100 text-yellow-800' :
                              order.status == 'PROCESSING' ? 'bg-blue-100 text-blue-800' :
                              order.status == 'SHIPPED' ? 'bg-purple-100 text-purple-800' :
                              order.status == 'DELIVERED' ? 'bg-green-100 text-green-800' :
                              'bg-red-100 text-red-800'}">
                            ${order.status}
                        </span>
                    <button onclick="showUpdateStatus('${order.orderId}', '${order.status}')" class="btn-primary text-sm">
                        <i class="fas fa-edit mr-1"></i> Update Status
                    </button>
                </div>
            </div>
        </div>

        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div>
                    <h2 class="text-lg font-semibold mb-3">Customer Information</h2>
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <c:if test="${not empty orderUser}">
                            <p><span class="font-medium">Name:</span> ${orderUser.username}</p>
                            <p><span class="font-medium">Email:</span> ${orderUser.email}</p>
                            <p><span class="font-medium">Phone:</span> ${orderUser.phone}</p>
                            <p><span class="font-medium">Address:</span> ${orderUser.address}</p>
                        </c:if>
                        <c:if test="${empty orderUser}">
                            <p class="text-gray-500">Customer information not available</p>
                        </c:if>
                    </div>
                </div>

                <div>
                    <h2 class="text-lg font-semibold mb-3">Order Summary</h2>
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <p><span class="font-medium">Order ID:</span> ${order.orderId}</p>
                        <p><span class="font-medium">Date:</span> ${order.orderDate}</p>
                        <p><span class="font-medium">Status:</span> ${order.status}</p>
                        <p><span class="font-medium">Total Amount:</span> $${String.format("%.2f", order.totalAmount)}</p>
                    </div>
                </div>
            </div>

            <h2 class="text-lg font-semibold mb-3">Order Items</h2>
            <div class="overflow-x-auto mb-6">
                <table class="w-full">
                    <thead class="bg-gray-50 text-gray-600 text-sm">
                    <tr>
                        <th class="py-3 px-4 text-left">Product</th>
                        <th class="py-3 px-4 text-center">Quantity</th>
                        <th class="py-3 px-4 text-right">Price</th>
                        <th class="py-3 px-4 text-right">Total</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <c:forEach var="entry" items="${orderItems}">
                        <c:set var="product" value="${entry.key}" />
                        <c:set var="quantity" value="${entry.value}" />
                        <tr>
                            <td class="py-3 px-4">
                                <div class="flex items-center">
                                    <div class="w-12 h-12 bg-gray-100 rounded overflow-hidden flex-shrink-0">
                                        <img src="${pageContext.request.contextPath}/${product.imagePath}"
                                             alt="${product.name}"
                                             class="w-full h-full object-contain p-1">
                                    </div>
                                    <div class="ml-3">
                                        <h4 class="font-medium">${product.name}</h4>
                                        <p class="text-sm text-gray-600">${product.description}</p>
                                    </div>
                                </div>
                            </td>
                            <td class="py-3 px-4 text-center">${quantity}</td>
                            <td class="py-3 px-4 text-right">$${String.format("%.2f", product.price)}</td>
                            <td class="py-3 px-4 text-right">$${String.format("%.2f", product.price * quantity)}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty orderItems}">
                        <tr>
                            <td colspan="4" class="py-4 text-center text-gray-500">No items found</td>
                        </tr>
                    </c:if>
                    </tbody>
                    <tfoot class="bg-gray-50">
                    <tr>
                        <td colspan="3" class="py-3 px-4 text-right font-semibold">Subtotal</td>
                        <td class="py-3 px-4 text-right">$${String.format("%.2f", order.totalAmount - (order.totalAmount > 50 ? 0.00 : 5.99))}</td>
                    </tr>
                    <tr>
                        <td colspan="3" class="py-3 px-4 text-right font-semibold">Shipping</td>
                        <td class="py-3 px-4 text-right">$${String.format("%.2f", order.totalAmount > 50 ? 0.00 : 5.99)}</td>
                    </tr>
                    <tr>
                        <td colspan="3" class="py-3 px-4 text-right font-semibold">Total</td>
                        <td class="py-3 px-4 text-right font-bold">$${String.format("%.2f", order.totalAmount)}</td>
                    </tr>
                    </tfoot>
                </table>
            </div>

            <div class="flex justify-between items-center mt-6">
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn-secondary">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Orders
                </a>

                <div class="flex space-x-3">
                    <button onclick="showUpdateStatus('${order.orderId}', '${order.status}')" class="btn-primary">
                        <i class="fas fa-edit mr-2"></i> Update Status
                    </button>

                    <c:if test="${order.status != 'CANCELLED' && order.status != 'DELIVERED'}">
                        <form action="${pageContext.request.contextPath}/admin/cancelOrder" method="post" class="inline">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <button type="submit" class="btn-danger" onclick="return confirm('Are you sure you want to cancel this order?')">
                                <i class="fas fa-times-circle mr-2"></i> Cancel Order
                            </button>
                        </form>
                    </c:if>
                </div>
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
</script>
</body>
</html>een-600 hover:bg-green-700 text-white py-2 px-4 rounded-lg font-semibol