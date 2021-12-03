<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>D&D Pets Inc. - Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>
<h2 align="center" class="font-effect-fire-animation">Shipment</h2>
<div class="centerDiv" style="background-color: white;">
<%
	// TODO: Get order id
	String orderId = request.getParameter("orderId");
	
	// TODO: Check if valid order id
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";
    try (Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement();){
	
	// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);
		String sql = "SELECT orderId FROM ordersummary WHERE orderId = " + orderId;
		ResultSet rst = stmt.executeQuery(sql);
		ResultSet rst2 = null;
		// con.commit()
		
		boolean validID = rst.next();
		boolean validOrderItems = false;
		boolean inStock = false;
		
		if(validID){
			// Check if there are products under the orderId
			rst = stmt.executeQuery("Select productId from orderproduct where orderId = "+orderId);
			validOrderItems = rst.next();

		}

		if(validOrderItems && validID){ 	
			// Get a list of every order item that orders a higher quantity than what is in stock.
			sql = "SELECT OP.orderId, OP.quantity, PI.quantity FROM  orderproduct AS OP JOIN productinventory AS PI on OP.productId = PI.productId WHERE  OP.quantity > PI.quantity AND warehouseID = 1 AND orderId = " + orderId;
			rst2 = stmt.executeQuery(sql);
			inStock = !rst2.next();

			// Print out items that don't have enough quantity
		}
				
		if(inStock && validOrderItems && validID){	
			// TODO: Insert Shipment Record
			
			//    shipmentId          INT IDENTITY,
			//    shipmentDate        DATETIME,   
			//    shipmentDesc        VARCHAR(100),   
			//    warehouseId         INT,  

			ResultSet rst3 = null;

			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			Date date = new Date();

			stmt.executeUpdate(String.format("INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (%s, '%s', 1)", formatter.format(date), "Sexy ORDEER" ));
			
			sql = "SELECT OP.orderId, OP.quantity, PI.quantity, OP.productId FROM  orderproduct AS OP JOIN productinventory AS PI on OP.productId = PI.productId WHERE warehouseID = 1 AND orderId = " + orderId;
			
			rst3 = stmt.executeQuery(sql);
			Statement stmt2 = con.createStatement();
			// Print Products in order 
			while(rst3.next()){
				out.print("<p>Ordered product: " + rst3.getString(1) + " Qty: " + rst3.getString(2) + "  Previous inventory: " + rst3.getString(3) + " New inventory: " + (rst3.getInt(3) - rst3.getInt(2)));
				out.print("<br>");

				sql = "UPDATE productinventory SET quantity = " + (rst3.getInt(3) - rst3.getInt(2)) + " WHERE productId = " + rst3.getString(4);
				stmt2.executeUpdate(sql);
			}
			
			// Decrement product inventory
			// sql = "UPDATE productinventory SET quantity = (SELECT (PI.quantity - OP.quantity) AS amount FROM orderproduct AS OP JOIN productinventory AS PI ON OP.productId = PI.productId WHERE warehouseId=1 and orderId = "+orderId+")";
			// stmt.executeUpdate(sql);
			con.commit();

			// Print statement about success
			out.print("<img src=\"https://lh3.googleusercontent.com/proxy/AIAke5DM2gkLkgmiNRUlSCkvJaqpJ_rSZFMxFhQrPoL3s_MyETMhn5xPxuvoVRq7noEyUnIle8y58W3orau39AJm2g9noLy1A4wsE4_NTKVEmItZXSH0IGuKaF4vZVjrDKNq6P91yysCLfhkq64pcVTMXiIS-lfsewQ\"> <br><b> Your New Adventure Buddies are on their way! woot :D</b>");
		} else{
			// Print statement about failure.
			if(!validOrderItems){
				out.print("<b> Shipment failed. Invalid orderId</b>");
			} else if (!validOrderItems){
				out.print("<b> Shipment failed. No order items</b>");
			} else if (!inStock){
				out.print("<b>Shipment Failed. Insufficient inventory for</b><br>Product: " + rst2.getString(1) + " Current inventory: " + rst2.getString(3) + " Requested Amount: "+ rst2.getString(2));
				while(rst2.next()){
					out.print("<br>Product: " + rst2.getString(1) + " Current inventory: " + rst2.getString(3) + " Requested Amount: "+ rst2.getString(2));
				}
			}

			con.rollback();
		}
	
		// TODO: Auto-commit should be turned back on
		con.setAutoCommit(true);


	}
	catch(SQLException e){
		out.print(e);
		throw(e);		
	}
%>
<h2><a href="shop.html">Back to Main Page</a></h2>                       				
</div>


</body>
</html>
