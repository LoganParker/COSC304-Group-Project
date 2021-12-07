<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>

<%
//create array with recieved parameters
String[] rsArr = {"productName","productPrice","productImageURL","productDesc","categoryName"};
ArrayList<String> rsList = new ArrayList<String>();
for(String i: rsArr){
    rsList.add(request.getParameter(i));
}

//Check if category is in category table

try{
    getConnection();
    Boolean missingCategory = true;
    String categoryName = request.getParameter("categoryName");
    String categoryId = "";
    while(missingCategory){
        
    //query to check if category id is in table   
        String sql = "SELECT categoryId FROM category WHERE categoryName = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, rsList.get(4)); //possible error here 
        ResultSet rst = pstmt.executeQuery();
        
    //if query is empty insert category into table
        if(!rst.next()){
            
            sql= "INSERT INTO category (categoryName) VALUES (?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, categoryName);
            pstmt.executeUpdate();
        }else{
            //Get category Id and break loop
            categoryId = rst.getString(1);  
            missingCategory = false;  
        }
    }

    //insert values into database 
    String valFields = "productName,productPrice,productImageURL,productDesc,categoryId";
    rsList.set(4, categoryId);
    String listResults = String.join(", ", rsList);
    out.print(listResults);
    String sql = "INSERT INTO product ("+valFields+") VALUES (?,?,?,?,?)"; 
    out.println(sql);
    PreparedStatement pstmt = con.prepareStatement(sql);

    for(int i = 1; i <= 5; i++) {
        pstmt.setString(i,rsList.get(i-1));
    }
    pstmt.executeUpdate();

}catch (Exception ex) {
    out.println(ex);
    //throw(ex);
}finally{
    closeConnection();
}

%>
<jsp:forward page="admin.jsp"/>