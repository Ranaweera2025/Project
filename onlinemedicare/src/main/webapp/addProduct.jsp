<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Add Product - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .menu-items{
            @apply rounded py-[5px] px-[5px] my-[8px] hover:bg-gray-100 transition delay-10 duration-600 ease-in-out cursor-pointer
        }
        .my-gradiant{
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
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
    </style>
</head>
<body class="bg-gray-50">
<!-- Include header -->
<%@ include file="header.jsp" %>

<div class="container mx-auto px-4 py-8 mt-16">
    <div class="max-w-2xl mx-auto bg-white p-6 rounded-lg shadow-md">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-green-600">Add  Product</h1>
            <a href="manageProducts" class="btn-secondary">
                <i class="fas fa-arrow-left mr-2"></i> Back to Products
            </a>
        </div>

        <%-- Success/Error Messages --%>
        <c:if test="${param.success != null}">
            <div class="bg-green-100 text-green-800 p-3 rounded mb-4">
                Product added successfully!
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="bg-red-100 text-red-800 p-3 rounded mb-4">
                Error: ${param.error}
            </div>
        </c:if>

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

            <div class="mb-4">
                <label for="description" class="block text-gray-700 mb-2">Description*</label>
                <textarea id="description" name="description" rows="4" required
                          class="input-field" placeholder="Enter product description"></textarea>
            </div>

            <div class="flex justify-end space-x-4">
                <a href="manageProducts" class="btn-secondary">
                    Cancel
                </a>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save mr-2"></i> Add Product
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Include footer -->
<%@ include file="footer.jsp" %>

<!-- Add this script at the end of the file, before the closing body tag -->
<script>
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

    // Initialize the form
    document.addEventListener('DOMContentLoaded', function() {
        toggleProductTypeFields();
    });
</script>
</body>
</html>
