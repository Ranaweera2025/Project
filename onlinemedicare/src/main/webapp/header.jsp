<%@ page import="model.User" %>
<%
  User headerUser = (User) session.getAttribute("user");
  boolean isLoggedIn = headerUser != null;
%>

<div class="flex pl-[50px] pr-[30px] bg-blue-100 items-center justify-between h-[70px]">
  <!-- Logo and Navigation Menu -->
  <ul class="flex justify-center gap-5 items-center">
    <button id="menu-btn" class="md:hidden">
      <i class="fa-solid fa-bars text-xl my-[12px] cursor-pointer hover:scale-110"></i>
    </button>

    <!-- Desktop Menu -->
    <div class="hidden md:flex justify-center gap-5">
      <li class="menu-items"><a href="index.jsp">HOME</a></li>
      <li class="menu-items"><a href="#categories" class="smooth-scroll">SHOP</a></li>
      <li class="menu-items"><a href="#about" class="smooth-scroll">About Us</a></li>
      <li class="menu-items"><a href="#">Contact us</a></li>
    </div>

    <!-- Mobile Menu -->
    <div id="mobile-menu" class="hidden md:hidden absolute top-16 left-0 w-full bg-white shadow-lg z-50 rounded-b-lg">
      <li class="menu-items px-6"><a href="index.jsp">HOME</a></li>
      <li class="menu-items px-6"><a href="#categories">SHOP</a></li>
      <li class="menu-items px-6"><a href="#about">About Us</a></li>
      <li class="menu-items px-6"><a href="#">Contact us</a></li>

      <!-- Mobile-only login/register or user menu -->
      <% if (isLoggedIn) { %>
      <li class="menu-items px-6 border-t border-gray-200 mt-2 pt-2">
        <a href="dashboard.jsp" class="flex items-center">
          <i class="fas fa-user-circle mr-2"></i> My Dashboard
        </a>
      </li>
      <li class="menu-items px-6">
        <a href="logout.jsp" class="flex items-center text-red-500">
          <i class="fas fa-sign-out-alt mr-2"></i> Logout
        </a>
      </li>
      <% } else { %>
      <li class="menu-items px-6 border-t border-gray-200 mt-2 pt-2">
        <a href="login.jsp" class="flex items-center">
          <i class="fas fa-sign-in-alt mr-2"></i> User Login
        </a>
      </li>
      <li class="menu-items px-6">
        <a href="admin-login.jsp" class="flex items-center">
          <i class="fas fa-user-shield mr-2"></i> Admin Login
        </a>
      </li>
      <li class="menu-items px-6">
        <a href="register.jsp" class="flex items-center">
          <i class="fas fa-user-plus mr-2"></i> Register
        </a>
      </li>
      <% } %>
    </div>

    <script>
      // Get DOM elements
      const menuBtn = document.getElementById('menu-btn');
      const mobileMenu = document.getElementById('mobile-menu');

      // Toggle mobile menu
      menuBtn.addEventListener('click', () => {
        mobileMenu.classList.toggle('hidden');
      });

      // Close mobile menu when clicking outside
      document.addEventListener('click', (event) => {
        if (!mobileMenu.contains(event.target) && event.target !== menuBtn) {
          mobileMenu.classList.add('hidden');
        }
      });
    </script>
  </ul>

  <!-- Right side menu (Cart, User Profile) -->
  <ul class="flex gap-4 items-center">
    <li class="bg-green-500 my-[10px] px-[8px] py-[6px] text-black rounded-[5px] text-sm hover:bg-green-600 hover:text-white transition delay-10 duration-600 ease-in-out cursor-pointer">
      <a href="prescriptionUpload.jsp">Upload Your Prescription</a>
    </li>

    <a href="${pageContext.request.contextPath}/cart" class="p-3 hover:scale-110 relative">
      <i class="fas fa-shopping-cart text-xl"></i>
      <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center cart-count">0</span>
    </a>

    <!-- User Profile or Login/Register buttons -->
    <% if (isLoggedIn) { %>
    <!-- User Dropdown Menu -->
    <div class="relative" id="user-dropdown-container">
      <button id="user-dropdown-btn" class="flex items-center gap-2 py-2 px-3 rounded-full hover:bg-blue-200 transition-colors">
        <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center text-white font-semibold">
          <%= headerUser.getUsername().substring(0, 1).toUpperCase() %>
        </div>
        <span class="hidden md:block"><%= headerUser.getUsername() %></span>
        <i class="fas fa-chevron-down text-xs"></i>
      </button>

      <!-- Dropdown Menu -->
      <div id="user-dropdown" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-50 hidden">
        <div class="px-4 py-2 border-b border-gray-100">
          <p class="text-sm font-semibold"><%= headerUser.getUsername() %></p>
          <p class="text-xs text-gray-500"><%= headerUser.getEmail() %></p>
        </div>

        <a href="dashboard.jsp" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
          <i class="fas fa-user-circle mr-2"></i> Dashboard
        </a>

        <% if ("admin".equals(headerUser.getRole())) { %>
        <a href="admin/dashboard" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
          <i class="fas fa-shield-alt mr-2"></i> Admin Panel
        </a>
        <% } %>

        <a href="${pageContext.request.contextPath}/orderHistory" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
          <i class="fas fa-shopping-bag mr-2"></i> My Orders
        </a>

        <div class="border-t border-gray-100 mt-1"></div>

        <a href="logout.jsp" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">
          <i class="fas fa-sign-out-alt mr-2"></i> Logout
        </a>
      </div>
    </div>
    <% } else { %>
    <!-- Login/Register Buttons -->
    <div class="hidden md:flex gap-2">
      <div class="relative" id="login-dropdown-container">
        <button id="login-dropdown-btn" class="py-2 px-4 text-sm font-medium text-green-600 hover:text-green-800 transition-colors flex items-center">
          Login <i class="fas fa-chevron-down ml-1 text-xs"></i>
        </button>
        <div id="login-dropdown" class="absolute right-0 mt-1 w-48 bg-white rounded-md shadow-lg py-1 z-50 hidden">
          <a href="login.jsp" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
            <i class="fas fa-user mr-2"></i> User Login
          </a>
          <a href="admin-login.jsp" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
            <i class="fas fa-user-shield mr-2"></i> Admin Login
          </a>
        </div>
      </div>
      <a href="register.jsp" class="py-2 px-4 bg-green-600 text-white text-sm font-medium rounded-md hover:bg-green-700 transition-colors">
        Register
      </a>
    </div>

    <!-- Mobile Login Button (only visible on small screens) -->
    <div class="md:hidden">
      <button id="mobile-login-btn" class="py-2 px-3 text-sm font-medium text-green-600 hover:text-green-800 transition-colors">
        <i class="fas fa-user-circle text-xl"></i>
      </button>
      <div id="mobile-login-dropdown" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden">
        <div class="bg-white rounded-lg shadow-xl p-6 w-11/12 max-w-sm mx-auto mt-20">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-bold text-gray-800">Login Options</h3>
            <button id="close-mobile-login" class="text-gray-500 hover:text-gray-700">
              <i class="fas fa-times"></i>
            </button>
          </div>
          <div class="space-y-3">
            <a href="login.jsp" class="flex items-center justify-center gap-2 w-full py-3 px-4 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
              <i class="fas fa-user mr-2"></i> User Login
            </a>
            <a href="admin-login.jsp" class="flex items-center justify-center gap-2 w-full py-3 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
              <i class="fas fa-user-shield mr-2"></i> Admin Login
            </a>
            <div class="border-t border-gray-200 my-2 pt-2 text-center">
              <p class="text-sm text-gray-600 mb-2">Don't have an account?</p>
              <a href="register.jsp" class="flex items-center justify-center gap-2 w-full py-3 px-4 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors">
                <i class="fas fa-user-plus mr-2"></i> Register
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <% } %>
  </ul>
</div>

<!-- Create logout.jsp functionality -->
<script>
  // User dropdown toggle
  document.addEventListener('DOMContentLoaded', function() {
    const userDropdownBtn = document.getElementById('user-dropdown-btn');
    const userDropdown = document.getElementById('user-dropdown');

    if (userDropdownBtn) {
      userDropdownBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        userDropdown.classList.toggle('hidden');
      });

      // Close dropdown when clicking outside
      document.addEventListener('click', function(e) {
        if (!document.getElementById('user-dropdown-container').contains(e.target)) {
          userDropdown.classList.add('hidden');
        }
      });
    }

    // Login dropdown toggle
    const loginDropdownBtn = document.getElementById('login-dropdown-btn');
    const loginDropdown = document.getElementById('login-dropdown');

    if (loginDropdownBtn) {
      loginDropdownBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        loginDropdown.classList.toggle('hidden');
      });

      // Close dropdown when clicking outside
      document.addEventListener('click', function(e) {
        if (!document.getElementById('login-dropdown-container').contains(e.target)) {
          loginDropdown.classList.add('hidden');
        }
      });
    }

    // Mobile login dropdown
    const mobileLoginBtn = document.getElementById('mobile-login-btn');
    const mobileLoginDropdown = document.getElementById('mobile-login-dropdown');
    const closeMobileLogin = document.getElementById('close-mobile-login');

    if (mobileLoginBtn) {
      mobileLoginBtn.addEventListener('click', function() {
        mobileLoginDropdown.classList.remove('hidden');
        document.body.classList.add('overflow-hidden'); // Prevent scrolling
      });

      if (closeMobileLogin) {
        closeMobileLogin.addEventListener('click', function() {
          mobileLoginDropdown.classList.add('hidden');
          document.body.classList.remove('overflow-hidden');
        });
      }

      // Close when clicking outside the modal content
      mobileLoginDropdown.addEventListener('click', function(e) {
        if (e.target === mobileLoginDropdown) {
          mobileLoginDropdown.classList.add('hidden');
          document.body.classList.remove('overflow-hidden');
        }
      });
    }
  });
</script>
<script>
    // Function to update cart count
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart/count', {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
            }
        })
        .then(response => response.json())
        .then(data => {
            const cartCountElements = document.querySelectorAll('.cart-count');
            cartCountElements.forEach(element => {
                element.textContent = data.count;
            });
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }

    // Update cart count when page loads
    document.addEventListener('DOMContentLoaded', updateCartCount);
</script>