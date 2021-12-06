<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
<%@include file="header.jsp"%>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<div class = "centerDiv" style="background-color: white">
<%
try  {
	getConnection();
	// TODO: Print Customer information
	String sql = "SELECT * FROM customer WHERE userid = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	if(rst.next()){
		out.println("<table>");
		out.println("<tr><td><h4>Id</h4></td><td>"+rst.getString(1)+"</td></tr>");
		out.println("<tr><td><h4>Name</h4></td><td>"+rst.getString(2) +" "+rst.getString(3)+"</td></tr>");
		out.println("<tr><td><h4>Email</h4></td><td>"+rst.getString(4)+"</td></tr>");
		out.println("<tr><td><h4>Phone</h4></td><td>"+rst.getString(5)+"</td></tr>");
		out.println("<tr><td><h4>Address</h4></td><td>"+rst.getString(6)+"</td></tr>");
		out.println("<tr><td><h4>City</h4></td><td>"+rst.getString(7)+"</td></tr>");
		out.println("<tr><td><h4>State</h4></td><td>"+rst.getString(8)+"</td></tr>");
		out.println("<tr><td><h4>Postal Code</h4></td><td>"+rst.getString(9)+"</td></tr>");
		out.println("<tr><td><h4>Country</h4></td><td>"+rst.getString(10)+"</td></tr>");
		out.println("<tr><td><h4>User ID</h4></td><td>"+rst.getString(11)+"</td></tr>");
		out.println("</table>");
	}
	
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

