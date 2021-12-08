<!DOCTYPE html>
<html>
<head>
<title>D&D Pets inc. - Customer Update</title>
</head>
<body>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<div style="margin:0 auto;text-align:center;display:inline">
<%@include file="header.jsp"%>
<div class = "centerDiv" style="background-color: white">
<h3>Edit your info!</h3>

<br>
<form name="updateCustomer" method=post action="submitUpdateCustomer.jsp">

<%
    
    try {
        getConnection();
        String sql = "SELECT * FROM customer WHERE customerId = (?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, request.getParameter("customerId"));
        ResultSet rst = pstmt.executeQuery();
        if(rst.next()){
            out.print("<input type=\"hidden\" name=\"customerId\"value=\""+rst.getString(1)+"\">");    
            
            //Username / password
            out.println("<div><table style=\"display: inline;\"><tr>");
            out.println("<td><div align=\"right\"><font size=\"2\">Username:</font></div></td><td><input type=\"text\" name=\"username\" size=10 maxlength=\"20\" required value=\""+rst.getString(11)+"\"></td>");
            out.println("<td><div align=\"right\"><font size=\"2\">Password:</font></div></td><td><input type=\"password\" name=\"password\" size=10 maxlength=\"30\" required value =\""+rst.getString(12)+"\"></td>");
            out.println("</tr></table></div>");
            out.println("<hr>");
            // Personal Info
            out.println("<h4>Personal Info</h4>");
            out.println("<table style=\"display:inline\"><tr>");
            out.println("<td><div align=\"right\"><font size=\"2\">First Name:</font></div></td><td><input type=\"text\" name=\"firstname\" maxlength=\"40\" required value =\""+rst.getString(2)+"\"></td>");
            out.println("<td><div align=\"right\"><font size=\"2\">Last Name:</font></div></td><td><input type=\"text\" name=\"lastname\" maxlength=\"40\" required value=\""+rst.getString(3)+"\"></td>");
            out.println("</tr><tr>");
            out.println("<td><div align=\"right\"><font size=\"2\">Email:</font></div></td><td><input type=\"email\" name=\"email\" maxlength=\"50\" value=\""+rst.getString(4)+"\"></td>");
            out.println("<td><div align=\"right\"><font size=\"2\">Phone:</font></div></td><td><input type=\"tel\" name=\"phone\" maxlength=\"20\" pattern =^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]\\d{3}[\\s.-]\\d{4}$ value=\""+rst.getString(5)+"\"></td>");
            out.println("</tr></table>");
            out.println("<hr><h4>Address Info:</h4>");

            out.println("<table style=\"display: inline;\"><tr>");
            out.println("<td><label><font size=\"2\"> Street Address </font></label></td><td><input type=\"text\" name=\"streetaddr\" maxlength=\"60\" value=\""+rst.getString(6)+"\"></td>");
            out.println("<td><label> City </label></td><td><input type=\"text\" name=\"city\" maxlength=\"40\" value=\""+rst.getString(7)+"\"></td>");
            out.println("</tr><tr>");
            out.println("<td><label> State </label></td><td><input type=\"text\" name=\"state\" maxlength=\"20\" value=\""+rst.getString(8)+"\"></td>");
            out.println("<td><label>Postal Code</label></td><td><input type=\"text\" name=\"postalcode\" maxlength=\"20\" value=\""+rst.getString(9)+"\" pattern= ([0-9]{5})|([a-Z][0-9][a-Z](\\s|-)?[0-9][a-Z][0-9])$></td>");
            out.println("</tr><tr>");
            out.println("<td><label> Country </label></td><td><input type=\"text\" name=\"country\" maxlength=\"40\" value=\""+rst.getString(10)+"\"></td>");
            out.println("</tr></table>");
        }
        
    
    } catch (SQLException ex) {
        out.println(ex);
    }finally{

    }
    
%>
<br>
<input class="submit" type="submit" name="Submit2" value="Save">
</form>

</div>
</div>
</body>
</html>

