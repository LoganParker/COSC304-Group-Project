<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%

// Retrieve values from form and session
String custId = (String) session.getAttribute("customerId");
String productId = request.getParameter("productId");
String reviewComment = request.getParameter("reviewComment");
String rating = request.getParameter("rating");
SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
Date date = new Date(); 


try {
    getConnection();

    String sql = "SELECT customerId, productId FROM review WHERE customerId = ? and productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, custId);
    pstmt.setString(2, productId);
    ResultSet rst = pstmt.executeQuery();

    if(!rst.next()) {
    
    sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?,?,?,?,?)";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1,rating);
    pstmt.setString(2,formatter.format(date));
    pstmt.setString(3,custId);
    pstmt.setString(4,productId);
    pstmt.setString(5,reviewComment);
    
    int rst2 = pstmt.executeUpdate();
    out.println(rst2);
    }
    else {
        out.print("shame");
    }
}catch (SQLException ex) {
    out.println(ex);
}finally{
    closeConnection();
}
response.sendRedirect("product.jsp?id="+productId);
%>