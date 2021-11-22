<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
	String orderId = Integer.toString((Integer)session.getAttribute("orderId"));
	
	// TODO: Check if valid order id
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";
    try (Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement();){
    
	String sql = "SELECT orderId FROM orderproduct WHERE orderId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1,orderId);
	// TODO: Start a transaction (turn-off auto-commit)
	

	// TODO: Retrieve all items in order with given id

	out.print(orderId);
	
	// TODO: Create a new shipment record.

	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on



	}
	catch(SQLException e){
		out.print(e);
		
	}
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
