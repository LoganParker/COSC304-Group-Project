<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ include file="header.jsp"%>
<form method="post" action="submitUpdateProd.jsp">
<br>

<div style="margin:0 auto;text-align:center;display:inline">
<h1> Update Product </h1>
<div class="centerDiv"style="background-color: white">

<%
String[] labelNames = {"Product Id = "+request.getParameter("productId")+"","Product Name","Product Price","Product Description", "Category Id"};
String[] names = {"productId","productName","productPrice","productDesc", "categoryId"};
String[] parameters={"10","40","10","1000","1"};
ArrayList<String> resultData = new ArrayList<String>();   
for(String i:names){
    resultData.add(request.getParameter(i));
}

//String link = "?productId="+rst.getString(1)+"&productName="+rst.getString(2)+"&productPrice="+rst.getString(3)+"&productDesc="+rst.getString(6)+"&categoryId="+rst.getString(7);
for(int i = 0; i < 5; i++){
    
    out.print("<label>"+labelNames[i]+"</label>");
    if(i==0){
        out.print("<input type=\"hidden\" name=\""+names[i]+"\"value=\""+resultData.get(i)+"\"maxlength = \""+parameters[i]+"\">");    
    }else{
        out.print("<input type=\"text\" name=\""+names[i]+"\"value=\""+resultData.get(i)+"\"maxlength = \""+parameters[i]+"\">");
    }
    out.print("<br>");
}
%>
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>
</div>
</div>