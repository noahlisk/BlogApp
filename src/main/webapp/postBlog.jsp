<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Make Blog Post</title>
</head>
<body>
	<form action="/sign" method="post">
		<p id="writing_headers">Title</p>
		<div><textarea name="title" rows="1" cols="69"></textarea></div>
		<p id="writing_headers">Body</p>
		<div><textarea name="content" rows="6" cols="120"></textarea></div>
		<br>
		<div><input type="submit" value="Post Blog" /></div>
			<input type="hidden" name="blogAppName" value="ourBlog" />
			<input type="hidden" name="key" value="${fn:escapeXml(post_key)}" />	
	</form>

</body>
</html>