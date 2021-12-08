<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
<%@include file="header.jsp"%>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<div style="margin:0 auto;text-align:center;display:inline">
<h2 class="font-effect-fire-animation">Customer Information</h2>
<div class = "centerDiv" style="background-color: white">
<%
try  {
	getConnection();
	// TODO: Print Customer information
	String sql = "SELECT * FROM customer WHERE userid = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	String customerId = null;
	if(rst.next()){
		customerId = rst.getString(1);
		out.println("<table style=\"display: inline;\">");
		out.println("<tr><td><h4>Id</h4></td><td>"+rst.getString(1)+"</td><td><h4>Username</h4></td><td>"+rst.getString(11)+"</td></tr>");
		out.println("<tr><td><h4>Name</h4></td><td>"+rst.getString(2) +" "+rst.getString(3)+"</td></tr>");
		out.println("<tr><td><h4>Email</h4></td><td>"+rst.getString(4)+"</td><td><h4>Phone</h4></td><td>"+rst.getString(5)+"</td></tr>");
		out.println("<tr><td><h4>Address</h4></td><td>"+rst.getString(6)+"</td></tr>");
		out.println("<tr><td><h4>City</h4></td><td>"+rst.getString(7)+"</td><td><h4>State</h4></td><td>"+rst.getString(8)+"</td></tr>");
		out.println("<tr><td><h4>Country</h4></td><td>"+rst.getString(10)+"</td><td><h4>Postal Code</h4></td><td>"+rst.getString(9)+"</td></tr>");
		
		out.println("</table>");
		//Edit customer account
		out.println("<div>");
		out.println("<a href=\"updateCustomer.jsp?customerId="+rst.getString(1)+"\"><button type=\"button\">Edit Account Info</button></a>");
		out.println("</div>");
	}

//Create table of customer orders.  
	out.println("<hr>");
	out.print("<h1> Order History</h1><table><thead><td>Order Id</td><td>Order Date</td><td>Total Amount</td><td>Ship to Address</td></thead><tbody>");
    String SQL = "SELECT * FROM ordersummary WHERE customerId = ?";
	pstmt = con.prepareStatement(SQL);
	pstmt.setString(1, customerId); // double check this is proper value
	ArrayList<String> resultData = new ArrayList<String>();  
	rst = pstmt.executeQuery(); 
	while(rst.next()){
		out.print("<tr>");
		for(int i = 1; i <= 4; i++ ){
			out.print("<td>"+rst.getString(i)+"</td>");
		}
		out.print("</tr>");
	}
	out.print("</thead></table>"); 
	



} catch (SQLException ex) {
	out.print(ex);
} finally {
// Make sure to close connection
	closeConnection();
}
%>
</div>
</body>
</html>

