<%@page import="java.util.List"%>
<%@page import="com.tech.blog.entities.Post"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Redirect if not logged in
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login_page.jsp");
        return;
    }
    PostDao postDao = new PostDao(ConnectionProvider.getConnection());
    List<Post> myPosts = postDao.getPostsByUserId(((User) session.getAttribute("currentUser")).getId());
%>

<!DOCTYPE html>
<html>
    <head>
        <title>My Posts - TechBlog</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link href="css/mystyle.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            .banner-background{
                clip-path: polygon(30% 0%, 70% 0%, 100% 0, 100% 91%, 63% 100%, 22% 91%, 0 99%, 0 0);
            }
            .btn-liked {
                pointer-events: none;
                opacity: 0.6;
                color: #ccc !important;
                border-color: #ccc !important;
                background-color: #f8f9fa !important;
            }
            .card {
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 24px;
            }
            .card-body b {
                font-size: 18px;
                color: #3563d1;
            }
            .card-content {
                margin-top: 8px;
                font-size: 16px;
                color: #333;
                line-height: 1.5;
            }
            .read-more-btn {
                background-color: #3563d1;
                color: white;
                border: none;
                padding: 5px 15px;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 10px;
            }
            .read-more-btn:hover {
                background-color: #143c74;
            }
            .card-img-top {
                max-width: 100%;
                max-height: 180px;
                object-fit: cover;
                border-radius: 4px;
                margin-bottom: 10px;
                width: auto;
                height: auto;
            }

        </style>
    </head>
    <body>

        <%@include file="normal_navbar.jsp" %>

        <div class="container mt-4">
            <h2 class="text-center mb-4" style="margin-top: 80px;">My Posts</h2>
            <%
                if (myPosts == null || myPosts.isEmpty()) {
            %>
            <div class="alert alert-info text-center">
                You haven't created any posts yet.
            </div>
            <%
            } else {
            %>
            <div class="row">
                <%
                    for (Post post : myPosts) {
                %>
                <div class="col-md-4 mt-2">
                    <div class="card mb-4" style="max-width: 380px; margin: 0 auto;">
                        <img class="card-img-top" src="blog_pics/<%= post.getpPic()%>" alt="Card image cap">
                        <div class="card-body">
                            <h5 class="card-title font-weight-bold" style="color: #232d3b; font-size: 1.4rem;"><%= post.getpTitle()%></h5>
                            <p class="card-text" style="color: #4c5c68; font-size: 1rem;">
                                <%
                                    String content = post.getpContent();
                                    if (content.length() > 140) {
                                        out.print(content.substring(0, 140) + "...");
                                    } else {
                                        out.print(content);
                                    }
                                %>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">

                                <a href="show_blog_page.jsp?post_id=<%= post.getPid()%>" class="btn btn-outline-primary btn-sm">
                                    <i class="fa fa-eye"></i> Read More
                                </a>
                                <a href="edit_post.jsp?post_id=<%= post.getPid()%>" class="btn btn-outline-secondary btn-sm">
                                    <i class="fa fa-pencil"></i> Edit
                                </a>
                                <a href="RemovePost?post_id=<%= post.getPid()%>" class="btn btn-outline-danger btn-sm" 
                                   onclick="return confirm('Are you sure you want to delete this post?');">
                                    <i class="fa fa-trash"></i> Delete
                                </a>

                            </div>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
        </div>


        <!-- JS for Bootstrap functionality -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>


    </body>
</html>
