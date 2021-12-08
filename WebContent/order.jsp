<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://fonts.googleapis.com/css?family=MedievalSharp&effect=fire-animation" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="styles.css" rel="stylesheet">
    <style>
        h1 {
            font-family: 'MedievalSharp', cursive;
            font-size: 64px;
        }

    </style>
    <title>D&D Pets Inc - Order Processing</title>
</head>
<body>
<%@include file="header.jsp"%>

<h1 align="center" class="font-effect-fire-animation">Your order has been placed!</h1>
<div class = "centerDiv" style="background-color: white">
    <div>
        

<%
    // Get customer id
    String custId = request.getParameter("customerId");
    @SuppressWarnings({"unchecked"}) HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";
    // Make connection
    try (Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();) {
        Boolean isValid = true; 
        // Determine if entered ID is an integer
        try{
            Integer.parseInt(custId); //throws error if null, empty, or not an int
        }
        catch(NumberFormatException ex){
            isValid = false;
            out.print("<b> Error! That is not a valid Adventurers Guild Number!!! </b>");
        }
        
        //Determine if entered ID is within our list of customer IDs
        ResultSet rst = null;
        String sql = "SELECT address, city, state, postalCode, country, firstName, lastName FROM customer WHERE customerId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, custId);
        rst = pstmt.executeQuery();
        
        //Deterimine if there are products in cart
        if(!rst.next()){
            isValid = false;
            out.print("<b> Error! You are not a member of the Adventurers Guild!!! </b>");
        } else if(productList.isEmpty()) {
            // No items in cart throw error
                isValid = false;
                out.print("<b>3 This Dungeon is Empty!!! </b>");
        }
        
        /**Save order information to database */
        if (isValid) {
            String custName = rst.getString(6) +" " + rst.getString(7);
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Date date = new Date();

            String address = request.getParameter("streetaddr");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postal = request.getParameter("postalcode");
            String country = request.getParameter("country");

            //orderId, orderDate ,totalAmount (initialize to null, update later) ,shiptoAddress ,shiptoCity ,shiptoState ,shiptoPostalCode ,shiptoCountry , customerId
            sql = "INSERT INTO ordersummary(orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?,?,?,?,?,?,?)";
            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, formatter.format(date));
            pstmt.setString(2, address);
            pstmt.setString(3, city);
            pstmt.setString(4, state);
            pstmt.setString(5, postal);
            pstmt.setString(6, country);
            pstmt.setString(7, custId);
            pstmt.executeUpdate();
            rst = pstmt.getGeneratedKeys();
        
            rst.next();
            int orderId = rst.getInt(1);

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
                pstmt.setInt(3, qty);
                pstmt.setDouble(4, pr);

                pstmt.executeUpdate();
            }

            /**UPDATE total amount in orderSummary table */ 
            //retrieve the sum from orderProduct
            sql = "SELECT sum(price*quantity) as totalAmount FROM orderproduct WHERE orderId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rst = pstmt.executeQuery();
            rst.next();
            double sum = rst.getDouble(1);

            // Update total amount for order record
            sql = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setDouble(1,sum);
            pstmt.setInt(2,orderId);
            pstmt.executeUpdate();
            
            // Print out order summary
            sql = "SELECT ordersummary.orderId, orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shipToCountry, customerId, productName, productDesc, quantity, price FROM ordersummary JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId JOIN product ON product.productId = orderproduct.productId WHERE ordersummary.orderId = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rst = pstmt.executeQuery();
            rst.next();
            
            /*
            orderId          rst.getString(1)
            orderDate        rst.getString(2)
            totalAmount      rst.getString(3)
            shiptoAddress    rst.getString(4)
            shiptoCity       rst.getString(5)
            shiptoState      rst.getString(6)
            shiptoPostalCode rst.getString(7)
            shiptoCountry    rst.getString(8)
            customerId       rst.getString(9)
            */
            Locale locale = new Locale("en", "US");
            NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);
            out.println("<h2> Congratulations "+ custName +" on bringing home a brand new D&D pet!!!!</h2>");
            out.println("<h2>Order total: "+rst.getString(3)+"</h2>");
            out.println("<h4>We hope your adventures are full of cuddles.</h3>");
            out.println("<p>Order date: "+rst.getDate(2)+" Order ID: "+rst.getString(1)+"</p>");
            out.println("<p><strong>Shipping Address:</strong><br>"+rst.getString(4)+"<br>"+rst.getString(5)+","+rst.getString(6)+","+rst.getString(7)+"<br>"+rst.getString(8)+"</p>");
            //List out the items in the order                        
            out.println("<table>");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<td>Name</td>");
            out.println("<td>Description</td>");
            out.println("<td>Quantitiy</td>");
            out.println("<td>Price</td>");
            out.println("<td>Product Total</td>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");

            while(true){           
                String productName = rst.getString(10);
                String productDesc = rst.getString(11);
                int qty = Integer.parseInt(rst.getString(12));
                double price = Double.parseDouble(rst.getString(13));
                double summedAmount = qty * price;
                out.println("<tr>");
                out.println("<td> " + productName + " </td>");
                out.println("<td> " + productDesc + " </td>");
                out.println("<td> " + qty + " </td>");
                out.println("<td> " + currFormat.format(price) + " </td>");
                out.println("<td> " + currFormat.format(summedAmount) + " </td>");
                out.println("</tr>");
                if(!rst.next()){
                    break;
                }
            }
            out.println("</tbody>");
            // Clear cart if order placed successfully
            productList.clear();


            String payType = request.getParameter("paymentType");
            String cardNum = request.getParameter("cardNumber");
            String payExpDate = request.getParameter("paymentExpiryDate");

            sql = "INSERT INTO paymentmethod(paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES (?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, payType);
            pstmt.setString(2, cardNum);
            pstmt.setString(3, payExpDate);
            pstmt.setString(4, custId);
            pstmt.executeUpdate();

        }
    } catch (SQLException ex) {
        out.println(ex);
    }
%>
        </table>
    </div>
</div>
</BODY>
</HTML>

