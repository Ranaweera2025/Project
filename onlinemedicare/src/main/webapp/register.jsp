<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .menu-items {
            @apply rounded py-[5px] px-[5px] my-[8px] hover:bg-gray-100 transition delay-10 duration-600 ease-in-out cursor-pointer;
        }
        .medical-input:focus {
            @apply ring-2 ring-green-500 border-green-300;
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Header -->
<%@ include file="header.jsp" %>

<div class="min-h-screen py-12">
    <div class="container mx-auto px-4">
        <div class="max-w-2xl mx-auto bg-white rounded-xl shadow-md overflow-hidden">
            <div class="p-8">
                <div class="flex items-center mb-6">
                    <i class="fas fa-user-plus text-green-500 text-2xl mr-3"></i>
                    <h2 class="text-2xl font-bold text-gray-800">Medical Account Registration</h2>
                </div>

                <!-- Messages -->
                <c:if test="${not empty error}">
                    <div class="mb-4 p-3 bg-red-100 text-red-700 rounded-lg">${error}</div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="mb-4 p-3 bg-green-100 text-green-700 rounded-lg">${message}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" class="space-y-4">
                    <!-- Personal Information -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-gray-700 mb-1">Full Name*</label>
                            <input type="text" name="fullName" required
                                   class="w-full px-4 py-2 border rounded-lg medical-input">
                        </div>
                        <div>
                            <label class="block text-gray-700 mb-1">Username*</label>
                            <input type="text" name="username" required
                                   class="w-full px-4 py-2 border rounded-lg medical-input">
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-gray-700 mb-1">Email*</label>
                            <input type="email" name="email" required
                                   class="w-full px-4 py-2 border rounded-lg medical-input">
                        </div>
                        <div>
                            <label class="block text-gray-700 mb-1">Phone Number*</label>
                            <input type="tel" name="phone" required
                                   class="w-full px-4 py-2 border rounded-lg medical-input">
                        </div>
                    </div>

                    <!-- Medical Information -->
                    <div class="border-t pt-4 mt-4">
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">
                            <i class="fas fa-heartbeat text-green-500 mr-2"></i>Medical Information
                        </h3>

                        <div>
                            <label class="block text-gray-700 mb-1">Health Card Number</label>
                            <input type="text" name="healthCardNumber"
                                   class="w-full px-4 py-2 border rounded-lg medical-input"
                                   placeholder="Optional">
                        </div>

                        <div class="mt-3">
                            <label class="block text-gray-700 mb-1">Known Allergies</label>
                            <textarea name="allergies" rows="2"
                                      class="w-full px-4 py-2 border rounded-lg medical-input"
                                      placeholder="List any allergies separated by commas"></textarea>
                        </div>
                    </div>

                    <!-- Security -->
                    <div class="border-t pt-4 mt-4">
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">
                            <i class="fas fa-lock text-green-500 mr-2"></i>Security
                        </h3>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-gray-700 mb-1">Password*</label>
                                <input type="password" name="password" required
                                       class="w-full px-4 py-2 border rounded-lg medical-input">
                            </div>
                            <div>
                                <label class="block text-gray-700 mb-1">Confirm Password*</label>
                                <input type="password" name="confirmPassword" required
                                       class="w-full px-4 py-2 border rounded-lg medical-input">
                            </div>
                        </div>
                    </div>

                    <!-- Address -->
                    <div class="border-t pt-4 mt-4">
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">
                            <i class="fas fa-home text-green-500 mr-2"></i>Address
                        </h3>
                        <div>
                            <label class="block text-gray-700 mb-1">Full Address*</label>
                            <textarea name="address" required rows="3"
                                      class="w-full px-4 py-2 border rounded-lg medical-input"></textarea>
                        </div>
                    </div>

                    <div class="flex items-center mt-6">
                        <input type="checkbox" id="terms" name="terms" required
                               class="mr-2">
                        <label for="terms" class="text-sm text-gray-600">
                            I agree to the <a href="#" class="text-green-600 hover:underline">Terms and Conditions</a>
                            and <a href="#" class="text-green-600 hover:underline">Privacy Policy</a>
                        </label>
                    </div>

                    <button type="submit"
                            class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-4 rounded-lg transition duration-200 mt-4">
                        <i class="fas fa-user-plus mr-2"></i> Create Medical Account
                    </button>
                </form>

                <div class="mt-6 text-center">
                    <p class="text-gray-600">Already have an account?
                        <a href="${pageContext.request.contextPath}/login.jsp" class="text-green-600 hover:underline font-medium">Login here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<%@ include file="footer.jsp" %>

<script>
    // Simple password match validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const password = document.querySelector('input[name="password"]');
        const confirmPassword = document.querySelector('input[name="confirmPassword"]');

        if (password.value !== confirmPassword.value) {
            e.preventDefault();
            alert('Passwords do not match!');
            confirmPassword.focus();
        }
    });
</script>
</body>
</html>