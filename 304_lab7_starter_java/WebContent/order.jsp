<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html>
<head>
    <title>DND Pets Inc Grocery Order Processing</title>
</head>
<body>

<%
    // Get customer id
    String custId = request.getParameter("customerId");
    @SuppressWarnings({"unchecked"}) HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";
    // Make connection
    try (Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();) {
        PreparedStatement pstmt = null;
        ResultSet rst = null;
        String sql = "SELECT customerId FROM customer";
        // Determine if valid customer id was entered
        Boolean hasCustId = (custId != null) && !custId.equals("");
        Boolean isValid = true;

        //Ensure that custId is a valid integer
        if (hasCustId) {
            try {
                String[] numsSplit = custId.split("-");

                String join = String.join("", numsSplit);
                out.print(join);
                int custNum = Integer.parseInt(join);
            } catch (Exception ex) {
                hasCustId = false;
                isValid = false;
            }
        }

        if (!hasCustId) {
            isValid = false;
            out.print("<b> Error1! That is not a valid Adventurers Guild Number!!! </b>");
        } else {
            sql += " WHERE customerId = ? ";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, custId);
            rst = pstmt.executeQuery();
        }
        /** Determine if there are products in the shopping cart */

        if (rst != null) {
            sql = "SELECT * FROM customer JOIN ordersummary ON customer.customerId = ordersummary.customerId JOIN incart ON incart.orderId = ordersummary.orderId WHERE ordersummary.customerId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, custId);
            rst = pstmt.executeQuery();

            // If either are not true, display an error message
            if (rst == null) {
                isValid = false;
                out.print("<b>3 This Dungeon is Empty!!! </b>");
            }

        } else {
            isValid = false;
            out.print("<b> Error2! You are not a member of the Adventurers Guild!!! </b>");
        }

        /**Save order information to database */
        if (isValid) {
            //customer(customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password)
            //Pull what is needed from customer for order summary
            sql = "SELECT address, city, state, postalCode, country, customerId FROM customer WHERE customerId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, custId);
            ResultSet rst2 = pstmt.executeQuery();

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
            Date date = new Date();

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ResultSet keys = pstmt.getGeneratedKeys();
            keys.next();
            int orderId = keys.getInt(1);

            //orderId, orderDate ,totalAmount (initialize to null, update later) ,shiptoAddress ,shiptoCity ,shiptoState ,shiptoPostalCode ,shiptoCountry , customerId
            sql = "INSERT INTO ordersummary(orderId, orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCounty, customerId) VALUES ('?','?','?','?','?','?','?')";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            pstmt.setString(2, formatter.format(date));
            pstmt.setString(3, rst2.getString(1));
            pstmt.setString(4, rst2.getString(2));
            pstmt.setString(5, rst2.getString(3));
            pstmt.setString(6, rst2.getString(4));
            pstmt.setString(7, rst2.getString(5));
            pstmt.setString(8, rst2.getString(6));
            rst = pstmt.executeQuery();

            // Insert each item into OrderProduct table using OrderId from previous INSERT

            //sql = "SELECT orderId FROM orderSummary ORDER BY orderId DESC"
            //Statment stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


            /** **/
            //sql = "SELECT * FROM incart";
            //rst = stmt.executeQuery(sql);

            //while(rst.next()){
            //	String orderId = rst.getString(1);
            //	String productId = rst.getString(2);
            //	String quantity = rst.getString(3);
            //	String price = rst.getString(4);

            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                String productId = (String) product.get(0);
                String price = (String) product.get(2);
                double pr = Double.parseDouble(price);
                int qty = ((Integer) product.get(3)).intValue();

                //sql = String.format("INSERT INTO orderProduct VALUES (?,?,?,?)", orderId, productId, qty, price);
                sql = "INSERT INTO orderproduct VALUES (?,?,?,?)";
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, orderId);
                pstmt.setString(2, productId);
                pstmt.setString(3, price);
                pstmt.setInt(4, qty);


                rst = pstmt.executeQuery();
            }


            //}
            // UPDATE total amount in orderSummary table
            sql = "SELECT sum(price*quantity) as totalAmount FROM orderproduct WHERE ordId = ? ";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rst = pstmt.executeQuery();

            double sum = 0;

            while (rst.next()) {
                double val = (Integer);
                sum += rst.getDouble(1);
            }
            //sql = "INSERT INTO orderSummary VALUES (?,?,?,?,?,?,?,?,?)";


            // Update total amount for order record
            sql = "UPDATE ordersummary set totalAmount = %s";

            // Print out order summary


            // Clear cart if order placed successfully
            productList.clear();
        }
    } catch (SQLException ex) {
        out.println(ex);
        throw (ex);

    }


%>
</BODY>
</HTML>

