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
<body>
<!-- Include header -->
<%@ include file="header.jsp" %>
<div class="min-h-screen flex items-center justify-center">
  <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
    <div class="text-center mb-8">
      <h1 class="text-2xl font-bold text-green-700">Admin Portal</h1>
      <p class="text-gray-600">Sign in to access the admin dashboard</p>
    </div>

    <c:if test="${not empty error}">
      <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          ${error}
      </div>
    </c:if>

    <form action="adminLogin" method="post">
      <div class="mb-4">
        <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Username</label>
        <input type="text" id="username" name="username"
               class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500"
               required>
      </div>
      <div class="mb-6">
        <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password</label>
        <input type="password" id="password" name="password"
               class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500"
               required>
      </div>
      <button type="submit"
              class="w-full bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-lg font-semibold">
        Sign In
      </button>
    </form>
  </div>
</div>
<!-- footer section-->
<%@ include file="footer.jsp" %>
</body>
</html>