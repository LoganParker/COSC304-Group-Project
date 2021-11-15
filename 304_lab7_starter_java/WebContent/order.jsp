<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>DND Pets Inc Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
// Make connection
try ( Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement();){
	PreparedStatement pstmt = null;
	ResultSet rst = null;
	String sql = "SELECT custId FROM customer";
	// Determine if valid customer id was entered
	Boolean hasCustId = (custId != null) && !custId.equals("");
	Boolean isValid = true;
	
	//Ensure that custId is a valid integer
	if(hasCustId){
		try{
			int custNum = Integer.parseInt(custId);
		}catch(NumberFormatException ex){
			hasCustId = false;
			isValid = false;
		}
	}
	
	if(!hasCustId){
		isValid = false;
		out.print("<b> Error! You are that is not a valid Adventurers Guild Number!!! </b>");	
		break;
	} else  {
		sql += " WHERE custId = ? ";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1,custId);
		rst = pstmt.executeQuery();
	}
/** Determine if there are products in the shopping cart */
	
	if (rst != null ) {
		sql ="SELECT * FROM customer JOIN ordersummary ON customer.customerId = ordersummary.customerId JOIN incart ON incart.orderId = ordersummary.orderId WHERE customerId = ?";
		pstmt = con.prepareStatement(sql);		
		pstmt.setString(1,custId);
		rst = pstmt.executeQuery(sql);
		
		// If either are not true, display an error message
		if(rst == null){
			isValid = false;
			out.print("<b> This Dungeon is Empty!!! </b>");
		} else {
		isValid = false;
		out.print("<b> Error! You are not a member of the Adventurers Guild!!! </b>");	
	}	

/**Save order information to database */	
	if(isValid){
		//Create auto-generated auto id
			
		//Pull what is needed from customer for order summary
		sql = "SELECT * FROM customer WHERE customerId = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, custId);
		rst = pstmt.executeQuery(sql);

		//orderId, orderDate ,totalAmount (initialize to null, update later) ,shiptoAddress ,shiptoCity ,shiptoState ,shiptoPostalCode ,shiptoCountry , customerId
		sql = "INSERT INTO orderSummary VALUES (?,?,?,?,?,?,?,?,?)"; 

/** **/
		sql = "SELECT * FROM incart";
		rst = stmt.executeQuery(sql);
		while(rst.next()){
			String orderId = rst.getString(1);
			String productId = rst.getString(2);
			String quantity = rst.getString(3);
			String price = rst.getString(4);
			sql = String.format("INSERT INTO orderProduct VALUES (%s,%s,%s,%s)", orderId, productId, quantity, price);
			
		}
		// UPDATE total amount in orderSummary table
		

			// Use retrieval of auto-generated keys.
			PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
			ResultSet keys = pstmt.getGeneratedKeys();
			keys.next();
			int orderId = keys.getInt(1);
		

		// Insert each item into OrderProduct table using OrderId from previous INSERT

		// Update total amount for order record

		// Here is the code to traverse through a HashMap
		// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

		
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
			}
		

		// Print out order summary

		// Clear cart if order placed successfully

	}
}
catch (SQLException ex) 
{ 	
	out.println(ex); 
}


%>
</BODY>
</HTML>

