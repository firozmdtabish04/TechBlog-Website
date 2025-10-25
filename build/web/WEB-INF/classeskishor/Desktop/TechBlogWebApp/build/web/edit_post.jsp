<%@page import="com.tech.blog.entities.Post"%>
<%@page import="com.tech.blog.entities.Category"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedInUser = (User) session.getAttribute("currentUser");  // Changed name
    if (loggedInUser == null) {
        response.sendRedirect("login_page.jsp");
        return;
    }
    
    int postId = Integer.parseInt(request.getParameter("post_id"));
    PostDao postDao = new PostDao(ConnectionProvider.getConnection());
    Post post = postDao.getPostByPostId(postId);
    
    if (post == null) {
        response.sendRedirect("my_posts.jsp");
        return;
    }
    
    // Security: Check if current user owns this post
    if (post.getUserId() != loggedInUser.getId()) {  // Use loggedInUser
        response.sendRedirect("my_posts.jsp?error=unauthorized");
        return;
    }
%>


<!DOCTYPE html>
<html>
<head>
    <title>Edit Post - TechBlog</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link href="css/mystyle.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
    <%@include file="normal_navbar.jsp" %>
    
    <div class="container" style="margin-top: 100px;">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header primary-background text-white">
                        <h4><i class="fa fa-edit"></i> Edit Post</h4>
                    </div>
                    <div class="card-body">
                        <form action="EditPost" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="post_id" value="<%= post.getPid()%>">
                            
                            <div class="form-group">
                                <label>Category</label>
                                <select class="form-control" name="cid" required>
                                    <%
                                        ArrayList<Category> categories = postDao.getAllCategories();
                                        for (Category c : categories) {
                                    %>
                                    <option value="<%= c.getCid()%>" <%= (c.getCid() == post.getCatId()) ? "selected" : "" %>>
                                        <%= c.getName()%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>Post Title</label>
                                <input type="text" name="pTitle" class="form-control" value="<%= post.getpTitle()%>" required>
                            </div>
                            
                            <div class="form-group">
                                <label>Post Content</label>
                                <textarea name="pContent" class="form-control" rows="10" required><%= post.getpContent()%></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label>Code Snippet (Optional)</label>
                                <textarea name="pCode" class="form-control" rows="5"><%= post.getpCode() != null ? post.getpCode() : ""%></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label>Current Image: 
                                    <span class="text-muted"><%= post.getpPic() != null ? post.getpPic() : "No image"%></span>
                                </label>
                                <br>
                                <label>Upload New Image (Optional)</label>
                                <input type="file" name="pic" class="form-control-file">
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-save"></i> Update Post
                                </button>
                                <a href="my_posts.jsp" class="btn btn-secondary">
                                    <i class="fa fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
