<%
try{
    getConnection();
    // Set that includes all Order Ids of shipped products
    Set<Integer> shipOrderIds = new HashSet<Integer>();
    out.print("<h1> Shipments </h1><table><thead><td>Shipment ID</td><td>Shipment Date</td><td>Shipment Desc: Order Id</td></thead><tbody>");
    String sql = "SELECT * FROM shipment";
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();
    
    while(rst.next()){
        out.print("<tr>");
        
        for(int i = 1; i <= 3; i++){
            // Add shipDesc(orderId) to shipOrderIds set
            if (i == 3) {
                shipOrderIds.add(Integer.parseInt(rst.getString(3)));
            }
        out.print("<td>"+rst.getString(i)+"</td>");   
        }
        out.print("</tr>");
    }
    
    
    out.print("</tbody></table>");
    out.println("<h1>Order and Sales Report Table</h1><table><thead>");
    out.print("<tr><th>orderDate</th><th>orderId</th><th>customerId</th><th>totalAmount</th></tr>");
    sql = "SELECT orderDate, orderId, customerId, totalAmount FROM ordersummary ORDER BY orderDate DESC";
    out.print("</thead><tbody>"); 
    pstmt = con.prepareStatement(sql);
    rst = pstmt.executeQuery();
    
    while(rst.next()){
        int[] arr = {1, 2, 3, 4};
        ArrayList<String> attributeList = new ArrayList<String>();
    
        for(int i: arr) {
           attributeList.add(rst.getString(i));
        }
    
    // Create a new new and insert attributes into customers 
        out.print("<tr>");
        for(String attr : attributeList) {
            out.print("<td>"+attr+"</td>");
        }
    // Check if order has already been shipped or not
    if(!shipOrderIds.contains(Integer.parseInt(rst.getString(2)))) {
        out.print("<td><button type=\"button\"><a href=ship.jsp?orderId=" + rst.getString(2) + "> Add Shipment</a></td></tr>");
    } else {
        out.print("<td>Status=Shipped</td></tr>");
    }
    
    }
    out.print("</tbody></table>");
    
    }
    catch (Exception ex) {
        out.println(ex);
        throw(ex);
    } finally {
        closeConnection();
    }
%>