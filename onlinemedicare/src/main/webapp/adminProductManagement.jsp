<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="service.ProductService" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get products if not already set in request
    if (request.getAttribute("products") == null) {
        ProductService productService = new ProductService();
        List<Product> products = productService.getAllProducts();
        request.setAttribute("products", products);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management - OnlineMediCare</title>
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
        .tab-active {
            @apply border-b-2 border-green-500 text-green-600 font-medium
        }
        .tab-inactive {
            @apply text-gray-500 hover:text-gray-700 cursor-pointer
        }
        .badge {
            @apply px-2 py-1 rounded-full text-xs font-semibold
        }
        .badge-success {
            @apply bg-green-100 text-green-800
        }
        .badge-warning {
            @apply bg-yellow-100 text-yellow-800
        }
        .badge-danger {
            @apply bg-red-100 text-red-800
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Include header -->
<%@ include file="header.jsp" %>

<div class="container mx-auto px-4 py-8 mt-16">
    <!-- Page Header -->
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">Product Management</h1>
        <a href="dashboard.jsp" class="btn-secondary">
            <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
        </a>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty message}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4" id="success-message">
        <i class="fas fa-check-circle mr-2"></i> ${message}
        <button onclick="this.parentElement.remove()" class="float-right">&times;</button>
    </div>
    </c:if>
    <c:if test="${not empty error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" id="error-message">
        <i class="fas fa-exclamation-circle mr-2"></i> ${error}
        <button onclick="this.parentElement.remove()" class="float-right">&times;</button>
    </div>
    </c:if>

    <!-- Success/Error Messages from query parameters -->
    <c:if test="${param.success != null}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4" id="param-success-message">
        <i class="fas fa-check-circle mr-2"></i> Product added successfully!
        <button onclick="this.parentElement.remove()" class="float-right">&times;</button>
    </div>
    </c:if>
    <c:if test="${param.error != null}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" id="param-error-message">
        <i class="fas fa-exclamation-circle mr-2"></i> Error: ${param.error}
        <button onclick="this.parentElement.remove()" class="float-right">&times;</button>
    </div>
    </c:if>

    <!-- Tabs -->
    <div class="border-b border-gray-200 mb-6">
        <ul class="flex flex-wrap -mb-px">
            <li class="mr-2">
                <a href="#" id="catalog-tab-btn" onclick="showTab('catalog')" class="inline-block p-4 tab-active">
                    <i class="fas fa-list mr-2"></i> Product Catalog
                </a>
            </li>
            <li class="mr-2">
                <a href="#" id="add-tab-btn" onclick="showTab('add')" class="inline-block p-4 tab-inactive">
                    <i class="fas fa-plus-circle mr-2"></i> Add Product
                </a>
            </li>
            <li class="mr-2">
                <a href="#" id="categories-tab-btn" onclick="showTab('categories')" class="inline-block p-4 tab-inactive">
                    <i class="fas fa-tags mr-2"></i> Categories
                </a>
            </li>
        </ul>
    </div>

    <!-- Tab Contents -->
    <div>
        <!-- Product Catalog Tab -->
        <div id="catalog-tab" class="tab-content">
            <div class="dashboard-card">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-xl font-bold">Product Catalog</h2>
                    <div class="flex space-x-2">
                        <div class="relative">
                            <input type="text" placeholder="Search products..." class="pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                        <a href="manageProducts" class="btn-primary">
                            <i class="fas fa-box-open mr-2"></i> Manage Products
                        </a>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-50 text-gray-600 text-sm">
                        <tr>
                            <th class="py-3 px-4 text-left">ID</th>
                            <th class="py-3 px-4 text-left">Name</th>
                            <th class="py-3 px-4 text-left">Category</th>
                            <th class="py-3 px-4 text-left">Price</th>
                            <th class="py-3 px-4 text-left">Stock</th>
                            <th class="py-3 px-4 text-left">Status</th>
                            <th class="py-3 px-4 text-left">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="text-gray-700 divide-y divide-gray-200">
                        <c:forEach var="product" items="${products}">
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4">${product.productId}</td>
                                <td class="py-3 px-4">${product.name}</td>
                                <td class="py-3 px-4">${product.category}</td>
                                <td class="py-3 px-4">${product.price}</td>
                                <td class="py-3 px-4">${product.stock}</td>
                                <td class="py-3 px-4">
                                    <c:choose>
                                        <c:when test="${product.stock > 10}">
                                            <span class="badge badge-success">In Stock</span>
                                        </c:when>
                                        <c:when test="${product.stock > 0}">
                                            <span class="badge badge-warning">Low Stock</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">Out of Stock</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="py-3 px-4">
                                    <a href="manageProducts?action=edit&productId=${product.productId}" class="text-blue-500 hover:text-blue-700 mr-2">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="confirmDelete('${product.productId}', '${product.name}')" class="text-red-500 hover:text-red-700">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>

                        <!-- If no products are available -->
                        <c:if test="${empty products}">
                            <tr>
                                <td colspan="7" class="py-8 text-center text-gray-500">
                                    <i class="fas fa-box-open text-4xl mb-3"></i>
                                    <p>No products available</p>
                                    <button onclick="showTab('add')" class="mt-3 btn-primary">
                                        <i class="fas fa-plus mr-2"></i> Add Your First Product
                                    </button>
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Add Product Tab -->
        <div id="add-tab" class="tab-content hidden">
            <div class="dashboard-card">
                <h2 class="text-xl font-bold mb-6">Add New Product</h2>

                <form action="AddProductServlet" method="post" enctype="multipart/form-data" class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Column 1 -->
                        <div>
                            <div class="mb-4">
                                <label for="productId" class="block text-gray-700 mb-2">Product ID*</label>
                                <input type="text" id="productId" name="productId" required
                                       class="input-field" placeholder="Enter product ID (e.g., PROD-12345)">
                            </div>

                            <div class="mb-4">
                                <label for="name" class="block text-gray-700 mb-2">Product Name*</label>
                                <input type="text" id="name" name="name" required
                                       class="input-field" placeholder="Enter product name">
                            </div>

                            <div class="mb-4">
                                <label for="category" class="block text-gray-700 mb-2">Category*</label>
                                <select id="category" name="category" required class="input-field" onchange="toggleProductTypeFields()">
                                    <option value="">Select Category</option>
                                    <option value="Medicine">Medicine</option>
                                    <option value="Equipment">Medical Equipment</option>
                                    <option value="Wellness">Wellness Product</option>
                                    <option value="Personal Care">Personal Care</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label for="price" class="block text-gray-700 mb-2">Price ($)*</label>
                                <input type="number" id="price" step="0.01" name="price" min="0" required
                                       class="input-field" placeholder="Enter product price">
                            </div>
                        </div>

                        <!-- Column 2 -->
                        <div>
                            <div class="mb-4">
                                <label for="stock" class="block text-gray-700 mb-2">Stock Quantity*</label>
                                <input type="number" id="stock" name="stock" min="0" required
                                       class="input-field" placeholder="Enter stock quantity">
                            </div>

                            <div class="mb-4">
                                <label for="manufacturer" class="block text-gray-700 mb-2">Manufacturer</label>
                                <input type="text" id="manufacturer" name="manufacturer"
                                       class="input-field" placeholder="Enter manufacturer name">
                            </div>

                            <div class="mb-4">
                                <label class="flex items-center">
                                    <input type="checkbox" id="prescriptionRequired" name="prescriptionRequired"
                                           class="rounded text-green-600 mr-2">
                                    <span class="text-gray-700">Requires Prescription</span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Medicine-specific fields -->
                    <div id="medicine-fields" class="hidden grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="dosage" class="block text-gray-700 mb-2">Dosage</label>
                            <input type="text" id="dosage" name="dosage"
                                   class="input-field" placeholder="e.g., 500mg">
                        </div>

                        <div>
                            <label for="expirationDate" class="block text-gray-700 mb-2">Expiration Date</label>
                            <input type="text" id="expirationDate" name="expirationDate"
                                   class="input-field" placeholder="e.g., Dec 2023">
                        </div>
                    </div>

                    <!-- Equipment-specific fields -->
                    <div id="equipment-fields" class="hidden grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="warrantyPeriod" class="block text-gray-700 mb-2">Warranty Period</label>
                            <input type="text" id="warrantyPeriod" name="warrantyPeriod"
                                   class="input-field" placeholder="e.g., 1 year">
                        </div>

                        <div>
                            <label for="manufacturer2" class="block text-gray-700 mb-2">Manufacturer</label>
                            <input type="text" id="manufacturer2" name="manufacturer2"
                                   class="input-field" placeholder="Enter manufacturer name">
                        </div>
                    </div>

                    <!-- Product Image Upload -->
                    <div class="mb-4">
                        <label for="productImage" class="block text-gray-700 mb-2">Product Image*</label>
                        <input type="file" id="productImage" name="productImage" accept="image/*" required
                               class="block w-full text-sm text-gray-500
                                      file:mr-4 file:py-2 file:px-4
                                      file:rounded-full file:border-0
                                      file:text-sm file:font-semibold
                                      file:bg-green-50 file:text-green-700
                                      hover:file:bg-green-100">
                        <div id="image-preview" class="mt-4 hidden">
                            <p class="text-sm text-gray-500 mb-2">Image Preview:</p>
                            <img id="preview-image" src="#" alt="Preview" class="h-40 object-contain border rounded">
                        </div>
                    </div>

                    <div>
                        <label for="description" class="block text-gray-700 mb-2">Description*</label>
                        <textarea id="description" name="description" rows="4" required
                                  class="input-field" placeholder="Enter product description"></textarea>
                    </div>

                    <div class="flex justify-end space-x-4">
                        <button type="button" onclick="showTab('catalog')" class="btn-secondary">
                            Cancel
                        </button>
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save mr-2"></i> Add Product
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Categories Tab -->
        <div id="categories-tab" class="tab-content hidden">
            <div class="dashboard-card">
                <h2 class="text-xl font-bold mb-6">Product Categories</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <div class="border rounded-lg p-4 hover:shadow-md transition-shadow">
                        <div class="flex justify-between items-center mb-3">
                            <h3 class="font-semibold text-lg">Medicine</h3>
                            <span class="badge badge-success">Active</span>
                        </div>
                        <p class="text-sm text-gray-600 mb-3">Pharmaceutical products including prescription and over-the-counter medications.</p>
                        <div class="flex justify-end">
                            <button class="text-blue-500 hover:text-blue-700 text-sm font-medium">
                                <i class="fas fa-edit mr-1"></i> Edit
                            </button>
                        </div>
                    </div>

                    <div class="border rounded-lg p-4 hover:shadow-md transition-shadow">
                        <div class="flex justify-between items-center mb-3">
                            <h3 class="font-semibold text-lg">Equipment</h3>
                            <span class="badge badge-success">Active</span>
                        </div>
                        <p class="text-sm text-gray-600 mb-3">Medical devices and equipment for home and professional use.</p>
                        <div class="flex justify-end">
                            <button class="text-blue-500 hover:text-blue-700 text-sm font-medium">
                                <i class="fas fa-edit mr-1"></i> Edit
                            </button>
                        </div>
                    </div>

                    <div class="border rounded-lg p-4 hover:shadow-md transition-shadow">
                        <div class="flex justify-between items-center mb-3">
                            <h3 class="font-semibold text-lg">Supplies</h3>
                            <span class="badge badge-success">Active</span>
                        </div>
                        <p class="text-sm text-gray-600 mb-3">Medical supplies including bandages, syringes, and other consumables.</p>
                        <div class="flex justify-end">
                            <button class="text-blue-500 hover:text-blue-700 text-sm font-medium">
                                <i class="fas fa-edit mr-1"></i> Edit
                            </button>
                        </div>
                    </div>

                    <div class="border rounded-lg p-4 hover:shadow-md transition-shadow">
                        <div class="flex justify-between items-center mb-3">
                            <h3 class="font-semibold text-lg">Wellness</h3>
                            <span class="badge badge-success">Active</span>
                        </div>
                        <p class="text-sm text-gray-600 mb-3">Health and wellness products including vitamins, supplements, and personal care items.</p>
                        <div class="flex justify-end">
                            <button class="text-blue-500 hover:text-blue-700 text-sm font-medium">
                                <i class="fas fa-edit mr-1"></i> Edit
                            </button>
                        </div>
                    </div>
                </div>

                <div class="border-t pt-6">
                    <button class="btn-primary">
                        <i class="fas fa-plus mr-2"></i> Add New Category
                    </button>
                </div>
            </div>
        </div>
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
    // Tab switching functionality
    function showTab(tabName) {
        // Hide all tab contents
        const tabContents = document.querySelectorAll('.tab-content');
        tabContents.forEach(tab => tab.classList.add('hidden'));

        // Show the selected tab
        document.getElementById(tabName + '-tab').classList.remove('hidden');

        // Update tab button styles
        document.querySelectorAll('[id$="-tab-btn"]').forEach(btn => {
            btn.classList.remove('tab-active');
            btn.classList.add('tab-inactive');
        });

        document.getElementById(tabName + '-tab-btn').classList.remove('tab-inactive');
        document.getElementById(tabName + '-tab-btn').classList.add('tab-active');
    }

    // Image preview functionality
    document.getElementById('productImage').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(event) {
                const previewImage = document.getElementById('preview-image');
                previewImage.src = event.target.result;
                document.getElementById('image-preview').classList.remove('hidden');
            }
            reader.readAsDataURL(file);
        }
    });

    // Toggle product type specific fields based on category selection
    function toggleProductTypeFields() {
        const category = document.getElementById('category').value;
        const medicineFields = document.getElementById('medicine-fields');
        const equipmentFields = document.getElementById('equipment-fields');

        // Hide all specific fields first
        medicineFields.classList.add('hidden');
        equipmentFields.classList.add('hidden');

        // Show relevant fields based on category
        if (category === 'Medicine') {
            medicineFields.classList.remove('hidden');
            // Make medicine fields required
            document.getElementById('dosage').required = true;
            document.getElementById('expirationDate').required = true;
            // Make equipment fields not required
            document.getElementById('warrantyPeriod').required = false;
            document.getElementById('manufacturer2').required = false;
        } else if (category === 'Equipment' || category === 'Medical Equipment') {
            equipmentFields.classList.remove('hidden');
            // Make equipment fields required
            document.getElementById('warrantyPeriod').required = true;
            document.getElementById('manufacturer2').required = true;
            // Make medicine fields not required
            document.getElementById('dosage').required = false;
            document.getElementById('expirationDate').required = false;
        } else {
            // Make all specialized fields not required
            document.getElementById('dosage').required = false;
            document.getElementById('expirationDate').required = false;
            document.getElementById('warrantyPeriod').required = false;
            document.getElementById('manufacturer2').required = false;
        }
    }

    // Delete confirmation modal
    function confirmDelete(productId, productName) {
        document.getElementById('deleteProductId').value = productId;
        document.getElementById('deleteProductName').textContent = productName;
        document.getElementById('deleteModal').classList.remove('hidden');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.add('hidden');
    }

    // Auto-hide success/error messages after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(() => {
            const successMessage = document.getElementById('success-message');
            const errorMessage = document.getElementById('error-message');
            const paramSuccessMessage = document.getElementById('param-success-message');
            const paramErrorMessage = document.getElementById('param-error-message');

            if (successMessage) successMessage.remove();
            if (errorMessage) errorMessage.remove();
            if (paramSuccessMessage) paramSuccessMessage.remove();
            if (paramErrorMessage) paramErrorMessage.remove();
        }, 5000);

        // Initialize the product type fields
        toggleProductTypeFields();

        // Check if we should show a specific tab based on URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('tab') === 'add') {
            showTab('add');
        }
    });

    // Close modal when clicking outside
    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeDeleteModal();
        }

    });
</script>
</body>
</html>