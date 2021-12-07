<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<form method="post" action="submitUpdateProd.jsp">
<br>
<h1> Update Product </h1>
<%
String[] labelNames = {"Product Id","Product Name","Product Price","Product Description", "Category Id"};
String[] names = {"productId","productName","productPrice","productDesc", "categoryId"};
ArrayList<String> resultData = new ArrayList<String>();   
for(String i:names){
    resultData.add(request.getParameter(i));
}

//String link = "?productId="+rst.getString(1)+"&productName="+rst.getString(2)+"&productPrice="+rst.getString(3)+"&productDesc="+rst.getString(6)+"&categoryId="+rst.getString(7);
for(int i = 0; i < 5; i++){
    
    out.print("<label>"+labelNames[i]+"</label>");
    if(i==0){
        out.print("<input type=\"hidden\" name=\""+names[i]+"\"value=\""+resultData.get(i)+"\">");    
    }else{
        out.print("<input type=\"text\" name=\""+names[i]+"\"value=\""+resultData.get(i)+"\">");
    }
    out.print("<br>");
}
%>
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>
