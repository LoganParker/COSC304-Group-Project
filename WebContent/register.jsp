<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">
<%@include file="header.jsp"%>
<div class = "centerDiv" style="background-color: white">
<h3>Please Register as a customer</h3>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<!-- CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
); -->

<br>
<form name="MyForm" method=post action="validateRegister.jsp">
<div>
    <table style="display: inline;">
        <tr>
            <td><div align="right"><font size="2">Username:</font></div></td>
            <td><input type="text" name="username" size=10 maxlength=10 required></td>
            <td><div align="right"><font size="2">Password:</font></div></td>
            <td><input type="password" name="password" size=10 maxlength="10"></td>
        </tr>
    </table>
    
</div>
<hr>
<h4>Personal Info</h4>
<table style="display:inline">
    

<tr>
	<td><div align="right"><font size="2">First Name:</font></div></td>
	<td><input type="text" name="firstname" required></td>
	<td><div align="right"><font size="2">Last Name:</font></div></td>
	<td><input type="text" name="lastname" required></td>
</tr>
<tr>
	<td><div align="right"><font size="2">Email:</font></div></td>
	<td><input type="email" name="email"></td>
    <td><div align="right"><font size="2">Phone:</font></div></td>
	<td><input type="tel" name="phone" pattern =^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$ placeholder="xxx-xxx-xxx">
    </td>
</tr>
</table>
<hr>
<h4>Address Info:</h4>
<table style="display: inline;">
<tr>
<td><label><font size="2"> Street Address </font></label></td>
<td><input type="text" name="streetaddr" placeholder="1600 Middleearth Pkwy"></td>
<td><label> City </label></td>
<td><input type="text" name="city" placeholder="Gondor"></td>
</tr>
<tr>
    <td><label> State </label></td>
    <td><input type="text" name="state" placeholder="CA"></td>
    <td><label>Postal Code</label></td>
    <td><input type="text" name="postalcode" placeholder="94043" pattern= ([0-9]{5})|([a-Z][0-9][a-Z](\s|-)?[0-9][a-Z][0-9])$></td>
</tr>
<tr>
    <td><label> Country </label></td>
    <td><input type="text" name="country" placeholder="United States"></td>
</tr>
</table>


<br>
<input class="submit" type="submit" name="Submit2" value="Sign up!">
</form>

</div>
</div>
</body>
</html>

