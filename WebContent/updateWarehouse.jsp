<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%
try{
    getConnection();
    //String sql = "UPDATE product SET productName = ?, productPrice = ?, productDesc = ?, categoryId = ? WHERE productId = ?";
    String warehouseId = request.getParameter("warehouseId");
    String sql = "SELECT productId FROM productinventory JOIN warehouse ON productinventory.warehouseId = warehouse.warehouseId WHERE warehouse.warehouseId = (?)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, warehouseId);
    ResultSet rst = pstmt.executeQuery();
    ArrayList<String> itemIds = new ArrayList<String>(); 
    
    while(rst.next()){
        itemIds.add(rst.getString(1));
    }
    String cases = "";
    ArrayList<String> valsIn = new ArrayList<String>(); 
    for(int i =0; i<itemIds.size()-1;i++){
        String qtyVal = request.getParameter(itemIds.get(i));
        if(qtyVal != null){
            cases += " WHEN productId = "+itemIds.get(i)+" THEN "+qtyVal;
            valsIn.add(itemIds.get(i)); 
        }
    }
    String ids = String.join(",", valsIn);
    sql = "Update productinventory SET quantity = CASE"+cases + " ELSE quantity END WHERE productId IN ("+ids+") AND warehouseId = (?)";  
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1, warehouseId);
    int numRows = pstmt.executeUpdate();
}catch (SQLException ex) {
    out.println(ex);
}finally{
    closeConnection();
}
%>
<jsp:forward page="warehouse.jsp"/>