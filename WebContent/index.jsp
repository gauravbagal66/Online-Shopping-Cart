<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*, javax.servlet.ServletOutputStream, java.io.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>GB Electronics</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet"
        href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #E6F9E6;">

<%
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");
    String userType = (String) session.getAttribute("usertype");

    boolean isValidUser = true;
    if (userType == null || userName == null || password == null || !userType.equals("customer")) {
        isValidUser = false;
    }

    ProductServiceImpl prodDao = new ProductServiceImpl();
    List<ProductBean> products = new ArrayList<ProductBean>();

    String search = request.getParameter("search");
    String type = request.getParameter("type");
    String message = "All Products";
    if (search != null) {
        products = prodDao.searchAllProducts(search);
        message = "Showing Results for '" + search + "'";
    } else if (type != null) {
        products = prodDao.getAllProductsByType(type);
        message = "Showing Results for '" + type + "'";
    } else {
        products = prodDao.getAllProducts();
    }

    if (products.isEmpty()) {
        message = "No items found for the search '" + (search != null ? search : type) + "'";
        products = prodDao.getAllProducts();
    }
%>

<jsp:include page="header.jsp" />

<div class="text-center" style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
<div class="text-center" id="message" style="color: black; font-size: 14px; font-weight: bold;"></div>

<!-- Start of Product Items List -->
<div class="container">
    <div class="row text-center">

<%
for (ProductBean product : products) {
    int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
%>
    <div class="col-sm-4" style='height: 420px;'>
        <div class="thumbnail">
            <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
                style="height: 150px; max-width: 180px;">
            <p class="productname"><%=product.getProdName()%></p>

            <%
            String description = product.getProdInfo();
            description = description.substring(0, Math.min(description.length(), 100));
            %>

            <p class="productinfo"><%=description%>..</p>
            <p class="price">Rs <%=product.getProdPrice()%></p>

            <form method="post">
            <%
                if (cartQty == 0) {
            %>
                <button type="submit"
                    formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
                    class="btn btn-success">Add to Cart</button>
                &nbsp;&nbsp;&nbsp;
                <button type="submit"
                    formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
                    class="btn btn-primary">Buy Now</button>
            <%
                } else {
            %>
                <button type="submit"
                    formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
                    class="btn btn-danger">Remove From Cart</button>
                &nbsp;&nbsp;&nbsp;
                <button type="submit" formaction="cartDetails.jsp"
                    class="btn btn-success">Checkout</button>
            <%
                }
            %>
                &nbsp;&nbsp;
                <!-- New Shop Address Button -->
               <button type="button" class="btn btn-warning"
    onclick="handleViewShop('<%=product.getProdId()%>')">
    View Shop
</button>



<script>
    var isLoggedIn = <%= session.getAttribute("user") != null %>;
</script>
<script>
function handleViewShop(prodId) {
    if (!isLoggedIn) {
        window.location.href = 'login.jsp'; // or your login page path
    } else {
        $('#shopAddressModal_' + prodId).modal('show');
    }
}
</script>

            </form>

            <!-- Modal for Shop Address -->
            <div class="modal fade" id="shopAddressModal_<%=product.getProdId()%>" tabindex="-1"
                role="dialog" aria-labelledby="shopAddressLabel_<%=product.getProdId()%>" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span>&times;</span>
                            </button>
                            <h4 class="modal-title" id="shopAddressLabel_<%=product.getProdId()%>">Shop Address</h4>
                        </div>
                        <div class="modal-body">
                            <p><%=product.getShopAddress() != null ? product.getShopAddress() : "Not available."%></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
<%
}
%>

    </div>
</div>
<!-- End of Product Items List -->

<%@ include file="footer.html" %>

</body>
</html>
