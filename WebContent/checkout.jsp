<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html>
<head>
    <title>D&D Pets Inc - Checkout</title>
</head>
<body>
<%@include file="header.jsp"%>
<div class="centerDiv"style="background-color: white">
<h3>Enter your customer id, payment info, and shipping information to complete the transaction:</h1>
<form method="get" action="order.jsp">
    <input type="text" name="customerId" size="50">
    <br>
    <h4> Payment Information </h1>
    <div>
        <label for="paymentType"> Payment Type </label>
    <select name="paymentType" id="paymentType">
        <option value="MC">MonsterCard</option>
        <option value="VS">Vampisa</option>
        <option value="DB">DireDebit</option>
        </select>
    <div>
    <label> Name on Card </label>
    <input type="text" name="cardholdername" placeholder="Frodo Baggins">
    </div>
    <label> Card Number </label>
    <input type="text" name="cardnumber" placeholder="xxxx-xxxx-xxxx-xxxx" pattern =^[0-9]{4}(-)?[0-9]{4}(-)?[0-9]{4}(-)?[0-9]{4}$ >
    <label> Expiration Date </label>
    <input type="text" name="expirationdate" placeholder="MM/YYYY" pattern =^((0[1-9])|(1[0-2]))\/20[2-9][0-9]$>
    <div>
    <label> CVV </label>
    <input maxlength=3 type="text" name="cvv" placeholder="123" pattern =^[0-9]{3}$>
    </div>
    </div>

    <h4> Shipment Information </h1>
    <div>
    <div>
    <label> Full Name </label>
    <input type="text" name="fullname" placeholder="Frodo Baggins">
    </div>
    <label> Street Address </label>
    <input type="text" name="streetaddr" placeholder="1600 Middleearth Pkwy">
    <label> City </label>
    <input type="text" name="city" placeholder="Gondor">
    <div>
    <label> State </label>
    <input type="text" name="state" placeholder="CA">
    <label> Postal Code </label>
    <input type="text" name="postalcode" placeholder="94043" pattern= ([0-9]{5})|([a-Z][0-9][a-Z](\s|-)?[0-9][a-Z][0-9])$>
    </div>
     <label> Country </label>
    <input type="text" name="country" placeholder="United States">
    </div>
    <input type="submit" value="Submit"><input type="reset" value="Reset">
    </div>

</form>
</div>
</body>
</html>

