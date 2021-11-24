<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
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

} catch (SQLException ex){
    out.println(ex);
    throw(ex);
}
// TODO: If there is a productImageURL, display using IMG tag

out.print("<h2 align=center class=\"subheaderText\" >" + productName + "</h2>");
out.println("<div class=\"centerDiv\" style=\"background-color: white;\">");
//if(productImageURL != null){
    
    out.print("<img src= \"" + productImageURL + "\" alt= \"" + productName + "\" width=\"500\" height=\"600\">" );
//}

out.print("<p><small><b>ID:</b> " + productId + "</small><br></br><small><b>Price:</b> " + currFormat.format(productPrice) + "</small></p>");


// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
	//String jpeg = out.print(<a><href = \"displayImage.jsp?Id= productId\"></a>")
// TODO: Add links to Add to Cart and Continue Shopping
String addCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice;
out.println("<h1><button><a href=\""+addCartLink+"\">Add to Cart</a></button></h1>");
out.println("<h1><button><a href=\"listprod.jsp\"> Continue Shopping </a></button><p></h1>");
%>
</div>
</body>
</html>

