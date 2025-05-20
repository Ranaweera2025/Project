<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="model.Product" %>
<%@ page import="model.Medicine" %>
<%@ page import="model.Equipment" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("manageProducts");
        return;
    }

    boolean isMedicine = product instanceof Medicine;
    boolean isEquipment = product instanceof Equipment;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .my-gradiant {
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
        .dashboard-card {
            @apply bg-white rounded-lg shadow-md p-6 transition-all duration-300 hover:shadow-lg
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
        .input-field {
            @apply w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 transition duration-300 ease-in-out
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Include header -->
<%@ include file="header.jsp" %>

<div class="container mx-auto px-4 py-8 mt-16">
    <!-- Page Header -->
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">Edit Product</h1>
        <a href="manageProducts" class="btn-secondary">
            <i class="fas fa-arrow-left mr-2"></i> Back to Products
        </a>
    </div>

    <div class="dashboard-card">
        <h2 class="text-xl font-bold mb-6">Edit Product Details</h2>

        <form action="manageProducts" method="post" class="space-y-6">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="productId" value="${product.productId}">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label for="productId" class="block text-gray-700 mb-2">Product ID</label>
                    <input type="text" id="productId" value="${product.productId}" disabled
                           class="input-field bg-gray-100">
                </div>

                <div>
                    <label for="name" class="block text-gray-700 mb-2">Product Name</label>
                    <input type="text" id="name" name="name" value="${product.name}" required
                           class="input-field">
                </div>

                <div>
                    <label for="category" class="block text-gray-700 mb-2">Category</label>
                    <select id="category" name="category" required class="input-field">
                        <option value="Medicine" ${product.category == 'Medicine' ? 'selected' : ''}>Medicine</option>
                        <option value="Equipment" ${product.category == 'Equipment' ? 'selected' : ''}>Equipment</option>
                        <option value="Supplies" ${product.category == 'Supplies' ? 'selected' : ''}>Supplies</option>
                        <option value="Wellness" ${product.category == 'Wellness' ? 'selected' : ''}>Wellness</option>
                    </select>
                </div>

                    <label for="price" class="block text-gray-700 mb-2">Price ($)</label>
                    <input type="number" id="price" name="price" value="${product.price}" required min="0" step="0.01"
                           class="input-field">
                </div>

                <div>
                    <label for="stock" class="block text-gray-700 mb-2">Stock Quantity</label>
                    <input type="number" id="stock" name="stock" value="${product.stock}" required min="0"
                           class="input-field">
                </div>

                <% if (isMedicine) {
                    Medicine medicine = (Medicine) product;
                %>
                <div>
                    <label for="dosage" class="block text-gray-700 mb-2">Dosage</label>
                    <input type="text" id="dosage" name="dosage" value="<%= medicine.getDosage() %>"
                           class="input-field">
                </div>

                <div>
                    <label for="expirationDate" class="block text-gray-700 mb-2">Expiration Date</label>
                    <input type="text" id="expirationDate" name="expirationDate" value="<%= medicine.getExpirationDate() %>"
                           class="input-field">
                </div>
                <% } %>

                <% if (isEquipment) {
                    Equipment equipment = (Equipment) product;
                %>
                <div>
                    <label for="warrantyPeriod" class="block text-gray-700 mb-2">Warranty Period</label>
                    <input type="text" id="warrantyPeriod" name="warrantyPeriod" value="<%= equipment.getWarrantyPeriod() %>"
                           class="input-field">
                </div>

                <div>
                    <label for="manufacturer" class="block text-gray-700 mb-2">Manufacturer</label>
                    <input type="text" id="manufacturer" name="manufacturer" value="<%= equipment.getManufacturer() %>"
                           class="input-field">
                </div>
                <% } %>
            </div>

            <div>
                <label for="description" class="block text-gray-700 mb-2">Description</label>
                <textarea id="description" name="description" rows="4" required
                          class="input-field">${product.description}</textarea>
            </div>

            <div class="flex justify-between">
                <button type="button" onclick="confirmDelete('${product.productId}', '${product.name}')" class="btn-danger">
                    <i class="fas fa-trash-alt mr-2"></i> Delete Product
                </button>

                <div class="flex space-x-4">
                    <a href="manageProducts" class="btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save mr-2"></i> Save Changes
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
    <div class="bg-white rounded-lg p-8 max-w-md w-full">
        <h3 class="text-xl font-bold text-red-600 mb-4">Delete Product</h3>
        <p class="text-gray-700 mb-6">Are you sure you want to delete <span id="deleteProductName" class="font-semibold"></span>? This action cannot be undone.</p>
        <div class="flex justify-end space-x-4">
            <button onclick="closeDeleteModal()" class="btn-secondary">Cancel</button>
            <form action="manageProducts" method="post" id="deleteForm">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="productId" id="deleteProductId">
                <button type="submit" class="btn-danger">Delete Permanently</button>
            </form>
        </div>
    </div>
</div>

<!-- Include footer -->
<%@ include file="footer.jsp" %>

<script>
    // Delete confirmation modal
    function confirmDelete(productId, productName) {
        document.getElementById('deleteProductId').value = productId;
        document.getElementById('deleteProductName').textContent = productName;
        document.getElementById('deleteModal').classList.remove('hidden');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.add('hidden');
    }
</script>
</body>
</html>