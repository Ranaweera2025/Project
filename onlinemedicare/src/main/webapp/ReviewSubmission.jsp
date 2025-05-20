<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>your profile</title>
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
    <style type="text/tailwindcss">
        @layer components {
            .star-rating {
                @apply flex flex-row-reverse justify-center
            }
            .star-rating input {
                @apply hidden
            }
            .star-rating label {
                @apply text-gray-300 text-4xl px-1 cursor-pointer
            }
            .star-rating input:checked ~ label,
            .star-rating label:hover,
            .star-rating label:hover ~ label {
                @apply text-yellow-500;
            }
        }
    </style>
</head>
<!-- Second header bar -->
<%@ include file="header.jsp" %>
<body class="bg-gray-100">
<div class="min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md bg-white rounded-lg shadow-md p-6">
        <div class="text-center mb-6">
            <i class="fas fa-comment-medical text-4xl text-green-500 mb-3"></i>
            <h1 class="text-2xl font-bold text-gray-800">Share Your Experience</h1>
            <p class="text-gray-600 mt-2">We value your feedback about our products and services</p>
        </div>

        <form class="space-y-4">
            <!-- Rating -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Your Rating</label>
                <div class="star-rating text-center">
                    <input type="radio" id="star5" name="rating" value="5">
                    <label for="star5" title="5 stars">★</label>
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4" title="4 stars">★</label>
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3" title="3 stars">★</label>
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2" title="2 stars">★</label>
                    <input type="radio" id="star1" name="rating" value="1" required>
                    <label for="star1" title="1 star">★</label>
                </div>
            </div>

            <!-- Product Selection -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Product (Optional)</label>
                <select class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500">
                    <option value="">Select a product...</option>
                    <option>Medical Face Mask</option>
                    <option>Hand Sanitizer</option>
                    <option>Digital Thermometer</option>
                    <option>First Aid Kit</option>
                </select>
            </div>

            <!-- Review Title -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Review Title</label>
                <input type="text" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500" placeholder="Brief summary of your experience">
            </div>

            <!-- Review Text -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Your Review</label>
                <textarea rows="4" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500" placeholder="Share details about your experience..."></textarea>
            </div>

            <!-- Name -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Your Name (Optional)</label>
                <input type="text" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500">
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full bg-green-500 hover:bg-green-600 text-white font-medium py-2 rounded-lg transition mt-4">
                Submit Review
            </button>
        </form>

        <div class="mt-6 text-center text-sm text-gray-500">
            <p>Your review will help others make better choices</p>
        </div>
    </div>
</div>
<!-- footer section-->
<%@ include file="footer.jsp"%>
</body>
</html>
