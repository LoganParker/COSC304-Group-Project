<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>

<!DOCTYPE html>
<html>
<head>
    <title>D&D Pets Inc. Grocery Order List</title>
    <style>
        table, th, td {
            border: 1px solid black;
            padding: 1px;
        }
    </style>
</head>
<body>

<h1>Orders List</h1>

<%
    //Note: Forces loading of SQL Server driver
    try {    // Load driver class
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    // Useful code for formatting currency values:
    // NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    // out.println(currFormat.format(5.0));  // Prints $5.00
%>


<%

    // Make connection
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";
    try (Connection con = DriverManager.getConnection(url, uid, pw);

            Statement stmt = con.createStatement();) {

        // Write query to retrieve all order summary records

        ResultSet rst = stmt.executeQuery(
                "SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId");


        // For each order in the ResultSet


        // Print out the order summary information
        // Write a query to retrieve the products in the order
        //   - Use a PreparedStatement as will repeat this query many times
        // For each product in the order
        // Write out product information


        Locale locale = new Locale("en", "US");
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

        while (rst.next()) {
            out.println("<table><thead><tr><th> Order Id </th><th> Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr></thead><tbody>");
            out.println("<tr><td>" + rst.getString(1) + "</td><td>" + rst.getDate(2) + "</td><td>" + rst.getDouble(3) + "</td><td>" + rst.getString(4) + " " + rst.getString(5) + "</td><td> $"
                    + rst.getDouble(6) + "</td></tr>");

            PreparedStatement stmnt2 = con.prepareStatement("SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?");
            stmnt2.setString(1, rst.getString(1));
            ResultSet rst2 = stmnt2.executeQuery();
            out.println("<tr><table><thead><tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr></thead><tbody>");

            while (rst2.next()) {
                out.println("<tr><td>" + rst2.getString(1) + "</td><td>" + rst2.getInt(2) + "</td><td>" + currFormat.format(rst2.getDouble(3)) + "</td></tr>");
            }
            rst2.close();
            out.println("</tbody></table></tr>");
        }

        out.println("</tbody></table>");


    } catch (SQLException ex) {
        out.println(ex);
    }


%>
// For each order in the ResultSet

// Print out the order summary information
// Write a query to retrieve the products in the order
// - Use a PreparedStatement as will repeat this query many times
// For each product in the order
// Write out product information

// Close connection


</body>
</html>

