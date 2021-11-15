<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();	
try ( Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement();) {
	String SQL = "SELECT * FROM product";
	boolean hasName = (name !=null ) && (!name.equals(""));
	PreparedStatement pstmt = null;
	ResultSet rst = null;

	if (!hasName) {
		pstmt = con.prepareStatement(SQL);
	}else{
		name = "%"+name+"%";
		SQL += " WHERE productName LIKE ?";
		pstmt = con.prepareStatement(SQL);
		pstmt.setString(1, name);
	}
	rst = pstmt.executeQuery();
	
	// Note: Asking driver to return actual SQL executed
	// sql = pstmt.toString();
	// out.println("<h2>SQL Query: " + sql + "</h2>");

	//rst = stmt.executeQuery();
    
	out.println("<table><thead><tr><th>Id</th><th>Name</th><th>Price</th><th>Product Image</th><th>Image URL</th><th>Description</th><th>Category Id</th><th>Add to Cart</th></tr>");
	while(rst.next()){
		String productId = rst.getString(1);
		String productName = rst.getString(2);
		String price = rst.getString(3);
		String addCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + price;
		out.println("<tr><td>"+ productId +"</td><td>"+ productName +"</td><td> $"+price+"</td><td>"+rst.getString(4)+"</td><td>"+rst.getString(5)+"</td><td>"+rst.getString(6)+"</td><td>"+rst.getInt(7) +"</td><td><a href ="+addCartLink+">Add To Cart</a></td></tr>");
	}
	out.println("</thead></table>");
	// Print out the ResultSet
	
	// For each product create a link of the form
	// addcart.jsp?id=productId&name=productName&price=productPrice
}
catch (SQLException ex) 
{ 	
	out.println(ex); 
}
// Close connection




// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>






