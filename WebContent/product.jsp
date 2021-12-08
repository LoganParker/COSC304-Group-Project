<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Collections" %> 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<html>
<head>
    <title>D&D Pets Inc</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<%@ include file="header.jsp" %>
<body>

<%
// Get product name to search for
String productId = request.getParameter("id");
/** Connection Info */
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

/** Product Info */
String productName= "";
double productPrice = 0;
String productImageURL = "";
String productImage = "";
String productDesc = "";
int categoryId = 0;

Locale locale = new Locale("en", "US");
NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

try( Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();){

// Get all data from the databse under product ID.    
String sql = "SELECT * FROM product WHERE productId = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1,productId);
ResultSet rst = pstmt.executeQuery();
rst.next();

productName = rst.getString(2);
productPrice = rst.getDouble(3);
productImageURL = rst.getString(4);
productImage = rst.getString(5);
productDesc = rst.getString(6);
categoryId = rst.getInt(7);
String addCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice;

//If there is a productImageURL, display using IMG tag

out.print("<h2 align=center class=\"subheaderText font-effect-fire-animation\" >" + productName + "</h2>");
out.println("<div class=\"centerDiv\" style=\"background-color: white;\">");
//if(productImageURL != null){
    
    out.print("<img src= \"" + productImageURL + "\" alt= \"" + productName + "\" width=\"500\" height=\"600\">" );
//}

out.print("<p><b>ID:</b> " + productId + "<br></br><b>Price:</b> " + currFormat.format(productPrice) + "</p>");
out.println("<button><a href=\""+addCartLink+"\">Add to Cart</a></button>");
out.println("<button><a href=\"listprod.jsp\"> Continue Shopping </a></button>");
//CREATE TABLE review (
//    reviewId            INT IDENTITY,
//    reviewRating        INT,
//    reviewDate          DATETIME,   
//    customerId          INT,
//    productId           INT,
//    reviewComment       VARCHAR(1000)
out.println("<hr>");
out.print("<h2>Product Reviews</h2>");

sql = "SELECT firstName, reviewDate, reviewRating, reviewComment FROM review JOIN customer ON customer.customerId = review.customerId WHERE review.productId = (?)";
pstmt = con.prepareStatement(sql);
pstmt.setString(1, productId);
rst = pstmt.executeQuery();


while(rst.next()) {
    String firstName = rst.getString(1);
    String reviewDate = rst.getString(2);
    int reviewRating = Integer.parseInt(rst.getString(3));
    String reviewComment = rst.getString(4);
    String review = "🌀";
    String repeated = String.join("", Collections.nCopies(reviewRating,review));
    out.print("<div><hr>");
    out.print("<span class = heading>Name: " + firstName + "</span>");
    out.print("<p>Date: "+ reviewDate +"</p>");
    out.print("<p>Number of Spell Slots(1-5): "+ repeated +"</p>");
    out.print("<p>Comment: " + reviewComment + "<p>");
    out.print("<hr></div>");
}
} catch (SQLException ex){
    out.println(ex);
    throw(ex);
}
%>


<h3> Insert Product Review </h3>
<form method="get" action="addReview.jsp">
    <br>
    <h4> Insert Product Review </h1>
    <div>
    <label for="Rating"> Rating </label>
    <select name="rating" id="reviewRating">
        <option value="1">1 Star</option>
        <option value="2">2 Star</option>
        <option value="3">3 Star</option>
        <option value="4">4 Star</option>
        <option value="5">5 Star</option>
    </select>
    <label> Review </label>
    <input type="text" name="reviewComment" placeholder="add comment" maxlength="1000">
    <%
        //out.println("<input type=\"hidden\" name=\"userId\" value=\""+userName+"\">");
        out.println("<input type=\"hidden\" name=\"productId\" value=\""+productId+"\">");

    %>
    <input type="submit" value="Submit">
    </div>
</form>
</div>
</body>
</html>

