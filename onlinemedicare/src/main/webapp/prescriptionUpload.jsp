<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Uplord your Prescription </title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .menu-items{
            @apply rounded py-[5px] px-[5px] my-[8px] hover:bg-gray-100 transition delay-10 duration-600 ease-in-out cursor-pointer
        }
        .my-gradiant{
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
    </style>
</head>
<body class="bg-gray-100">
<!-- Second header bar -->
<%@ include file="header.jsp" %>

<div class="min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md bg-white rounded-lg shadow-md p-6">
        <div class="text-center mb-6">
            <i class="fas fa-file-prescription text-4xl text-green-500 mb-3"></i>
            <h1 class="text-2xl font-bold text-gray-800">Upload Prescription</h1>
            <p class="text-gray-600 mt-2">Upload your doctor's prescription to order medicines</p>
        </div>

        <form class="space-y-4">
            <!-- Patient Info -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Your Name</label>
                <input type="text" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500" required>
            </div>

            <!-- File Upload -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Prescription File</label>
                <div class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center cursor-pointer hover:bg-gray-50 transition">
                    <input type="file" id="prescription" class="hidden" accept="image/*,.pdf">
                    <i class="fas fa-cloud-upload-alt text-3xl text-gray-400 mb-2"></i>
                    <p class="text-sm text-gray-600">Click to upload or drag and drop</p>
                    <p class="text-xs text-gray-500 mt-1">JPG, PNG or PDF (Max 5MB)</p>
                </div>
            </div>

            <!-- Doctor Info -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Doctor's Name</label>
                <input type="text" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500" required>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full bg-green-500 hover:bg-green-600 text-white font-medium py-2 rounded-lg transition mt-4">
                Upload Prescription
            </button>
        </form>

        <div class="mt-6 text-center text-sm text-gray-500">
            <p>Need help? Call us at <span class="text-green-500">123-456-7890</span></p>
        </div>
    </div>
</div>

<!-- footer section-->
<%@ include file="footer.jsp" %>

</body>
</html>