<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ include file="header.jsp"%>
<div style="margin:0 auto;text-align:center;display:inline">
<h2 class="font-effect-fire-animation">Admin Portal</h2>
<div class="centerDiv"style="background-color: white">
<div class="tab">
    <button class="tablinks" onclick="openTab(event,'Customers')" id="defaultOpen">Customers</button>
    <button class="tablinks" onclick="openTab(event,'InsertProduct')">Add a Product</button>
    <button class="tablinks" onclick="openTab(event,'ManageProducts')">Manage Products</button>
    <button class="tablinks" onclick="openTab(event,'Orders')">Orders & Shipments</button>
    <button class="tablinks" onclick="openTab(event,'Database')">Restore Database</button>
</div>



<div id="Customers" class="tabcontent">
<%@include file="adminCustomerInfo.jsp"%>
</div>
<div id="InsertProduct" class="tabcontent">
    <form method="post" action="insertProduct.jsp">
        <br>
        <h1> Insert Product </h1>
        <div>
        <div>
        <label> Product Name </label>
        <input type="text" name="productName" placeholder="wonderous item goes here"  maxlength="40">
        </div>
        <label> Product Price </label>
        <input type="text" name="productPrice" placeholder="wonderous item price here"  maxlength="10">
        <br>
        <label> Image URL  </label>
        <input type="text" name="productImageURL" placeholder="https://monster.png"  maxlength="100">
        <div>
        <label> Product Description </label>
        <input type="text" name="productDesc" placeholder="item flavour text goes here" maxlength="1000">
        </div>
        <div>
        <label> Category  Name</label>
        <input type="text" name="categoryName" placeholder="item category" maxlength="50">
        </div>
        </div>
        <input type="submit" value="Submit"><input type="reset" value="Reset">
    </form>
</div>
<div id="ManageProducts" class="tabcontent">
<!--Update / Delete Product -->
<form method="get" action="admin.jsp">
<input type="text" name="productName" size="50" maxlength="40">
<input type="submit" value="Submit"><input type="reset" value="Reset"> 
<table>
<%@include file="adminManageProduct.jsp"%>
</table>
</div>
<div id="Orders" class="tabcontent">
    <%@include file="adminOrderInfo.jsp"%>
</div>
<div id="Database" class="tabcontent">
    <h1> Restore Database </h1> 
    <a href = "loaddata.jsp"> 
    <input type=button value="Restore Database"> 
    </a> 
</div>

<script>
    // Credit to W3Schools https://www.w3schools.com/howto/howto_js_tabs.asp For the tab design
    function openTab(evt, tabName) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(tabName).style.display = "block";
  evt.currentTarget.className += " active";
}   
document.getElementById("defaultOpen").click();

</script>

</div>
</div>
</body>
</html>

