<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - OnlineMediCare</title>
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
            @apply w-full mb-4 p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 transition duration-300 ease-in-out
        }
        .btn-primary {
            @apply w-full bg-green-600 hover:bg-green-700 text-white py-3 rounded-lg font-semibold transition duration-300 ease-in-out transform hover:scale-[1.02]
        }
        .card-shadow {
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .login-container {
            @apply bg-white p-8 rounded-2xl shadow-lg w-96 border border-gray-100
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Second header bar -->
<%@ include file="header.jsp" %>

<!--login form section-->
<div class="min-h-screen flex items-center justify-center p-4">
    <!--login box-->
    <div class="flex w-full max-w-4xl h-full max-h-120 items-center justify-center rounded-xl overflow-hidden card-shadow bg-white">
        <!-- Left side - Image -->
        <div class="hidden md:block w-1/2 h-full">
            <img src="${pageContext.request.contextPath}/resources/images/loginpage.avif" class="w-full h-full object-cover" alt="Healthcare professionals">
        </div>

        <!-- Right side - Login form -->
        <div class="w-full md:w-1/2 p-8 md:p-12">
            <div class="login-container mx-auto">
                <h1 class="text-3xl font-bold mb-6 text-center text-gray-800">Welcome Back</h1>
                <p class="text-gray-600 text-center mb-8">Sign in to access your account</p>

                <!-- Error message display -->
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 text-sm">
                        <i class="fas fa-exclamation-circle mr-2"></i> ${errorMessage}
                    </div>
                </c:if>

                <form action="login" method="post">
                    <div class="mb-4">
                        <label for="username" class="block text-gray-700 text-sm font-medium mb-2">Username</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                                <i class="fas fa-user"></i>
                            </span>
                            <input type="text" id="username" name="username" placeholder="Enter your username"
                                   class="input-field pl-10" required>
                        </div>
                    </div>

                    <div class="mb-6">
                        <label for="password" class="block text-gray-700 text-sm font-medium mb-2">Password</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                                <i class="fas fa-lock"></i>
                            </span>
                            <input type="password" id="password" name="password" placeholder="Enter your password"
                                   class="input-field pl-10" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary">
                        <i class="fas fa-sign-in-alt mr-2"></i> Sign In
                    </button>
                </form>

                <div class="mt-6 text-center">
                    <p class="text-gray-600">
                        New to OnlineMediCare?
                        <a href="register.jsp" class="text-green-600 hover:text-green-800 font-medium hover:underline transition duration-300">
                            Create an account
                        </a>
                    </p>
                    <a href="#" class="block mt-2 text-sm text-green-600 hover:text-green-800 hover:underline transition duration-300">
                        Forgot your password?
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- footer section-->
<%@ include file="footer.jsp" %>

</body>
</html>
