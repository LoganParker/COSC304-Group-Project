<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	out.println(userName);
%>

<%
try  {


	getConnection();
// TODO: Print Customer information
String sql = "SELECT * FROM customer WHERE userid = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, userName);
Resultset rst = pstmt.executeQuery()



} catch (SQLException ex) {
	out.print(ex);
} finally {

// Make sure to close connection
	closeConnection();

}
%>

</body>
</html>

