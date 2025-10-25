<%@page import="com.tech.blog.dao.LikeDao"%>
<%@page import="com.tech.blog.entities.Post"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>TechBlog - Home</title>
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
            /* Image Container */
            .card-img-container {
                width: 100%;
                max-height: 300px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: #f8f9fa;
                overflow: hidden;
                border-radius: 8px 8px 0 0;
            }

            .card-img-top {
                max-width: 100%;
                max-height: 300px;
                height: auto;
                width: auto;
                object-fit: contain;
                transition: transform 0.3s ease;
            }

            .card-img-top:hover {
                transform: scale(1.05);
            }



        </style>
        <script>
            function showFullContent(id) {
                document.getElementById('snippet-' + id).style.display = 'none';
                document.getElementById('fullcontent-' + id).style.display = 'block';
                document.getElementById('read-more-btn-' + id).style.display = 'none';
            }
        </script>
    </head>
    <body>
        <%@include file="normal_navbar.jsp" %>


        <!--banner start-->

        <!--banner-->
        <div class="container-fluid p-0 m-0">
            <div class="jumbotron primary-background text-white banner-background">
                <div class="container">
                    <h3 class="display-3">Welcome to TechBlog </h3>
                    <p>Welcome to technical blog, world of technology
                        A programming language is a formal language, which comprises a set of instructions that produce various kinds of output. Programming languages are used in computer programming to implement algorithms.
                    </p>
                    <p>
                        Most programming languages consist of instructions for computers. There are programmable machines that use a set of specific instructions, rather than general programming languages.
                    </p>
                    <a href="register_page.jsp" class="btn btn-outline-light btn-lg">
                        <span class="fa fa-user-plus"></span>  Start! It's Free
                    </a>
                    <a href="login_page.jsp" class="btn btn-outline-light btn-lg"> 
                        <span class="fa fa-user-circle fa-spin"></span>  Login
                    </a>
                </div>
            </div>
        </div>

        <!--banner end-->

        <h1 class="text-center" style="text-decoration: underline; font-size:3.0rem; color:#2c3e50; margin-bottom:28px;">
            See All Posts Below
        </h1>


        <!--posts-->
        <div class="container">
            <div class="row">
                <%                PostDao postDao = new PostDao(ConnectionProvider.getConnection());
                    LikeDao likeDao = new LikeDao(ConnectionProvider.getConnection());
                    List<Post> posts = postDao.getAllPosts();

                    if (posts == null || posts.isEmpty()) {
                %>
                <div class="col-12">
                    <h3 class="display-3 text-center">No Posts Available</h3>
                </div>
                <%
                } else {
                    HashSet<Integer> likedPostIds = new HashSet<>();
                    if (currentUser != null) {
                        for (Post post : posts) {
                            if (likeDao.isLikedByUser(post.getPid(), currentUser.getId())) {
                                likedPostIds.add(post.getPid());
                            }
                        }
                    }
                    for (Post post : posts) {
                        boolean userLiked = currentUser != null && likedPostIds.contains(post.getPid());
                %>
                <div class="col-md-6 mt-2">
                    <div class="card">
                        <div class="card-img-container">
                            <img class="card-img-top" src="blog_pics/<%= post.getpPic()%>" alt="Post Image">
                        </div>

                        <div class="card-body">
                            <b><%= post.getpTitle()%></b>

                            <div id="snippet-<%= post.getPid()%>" class="card-content">
                                <%
                                    String content = post.getpContent();
                                    if (content.length() > 150) {
                                        out.print(content.substring(0, 150) + "...");
                                    } else {
                                        out.print(content);
                                    }
                                %>
                            </div>

                            <% if (currentUser != null && post.getpContent().length() > 150) {%>
                            <div id="fullcontent-<%= post.getPid()%>" class="card-content" style="display:none;">
                                <%= post.getpContent()%>
                            </div>
                            <% } %>
                        </div>
                        <div class="card-footer primary-background text-center">
                            <%
                                int likeCount = likeDao.countLikeOnPost(post.getPid());
                            %>
                            <% if (currentUser != null) {%>
                            <a href="#!" 
                               onclick="doLike(<%= post.getPid()%>, <%= currentUser.getId()%>, this)" 
                               class="btn btn-outline-light btn-sm <%= userLiked ? "btn-liked" : ""%>" 
                               <%= userLiked ? "disabled" : ""%>>
                                <i class="fa fa-thumbs-o-up"></i> 
                                <span class="like-counter"><%= likeCount%></span>
                            </a>
                            <a href="show_blog_page.jsp?post_id=<%= post.getPid()%>" 
                               class="btn btn-outline-light btn-sm">Read More...
                            </a>

                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <!--footer start-->
        <footer style="background:#232d3b; color:#fff; padding:34px 0 18px 0; margin-top:40px; border-top:2px solid #3563d1;">
            <div class="container text-center">
                <h5 style="font-weight:600; margin-bottom:10px;">TechBlog Community</h5>
                <p style="margin-bottom:4px;font-size:16px;">
                    &copy; 2025 TechBlog | All Rights Reserved
                </p>
                <div style="margin-bottom:4px;">
                    Made by <span style="color:#1abc9c;font-weight:500;">TechBlog Team</span>
                </div>
                <div>
                    <a href="https://www.facebook.com/" style="color:#fff; margin:0 12px; font-size:21px; text-decoration:none;"><i class="fa fa-facebook"></i></a>
                    <a href="https://x.com/" style="color:#fff; margin:0 12px; font-size:21px; text-decoration:none;"><i class="fa fa-twitter"></i></a>
                    <a href="https://github.com/" style="color:#fff; margin:0 12px; font-size:21px; text-decoration:none;"><i class="fa fa-github"></i></a>
                </div>
            </div>
        </footer>



        <!--footer end-->


        <!--        <br><br>-->

        <script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" crossorigin="anonymous"></script>
        <script src="js/myjs.js" type="text/javascript"></script>

        <script>
                                   function doLike(pid, uid, btn) {
                                       if (btn.disabled)
                                           return;
                                       $.ajax({
                                           url: 'LikeServlet',
                                           method: 'POST',
                                           data: {operation: 'like', pid: pid, uid: uid},
                                           success: function (response) {
                                               if (response.trim() === 'true') {
                                                   let likeSpan = $(btn).find('.like-counter');
                                                   let currentCount = parseInt(likeSpan.text());
                                                   likeSpan.text(currentCount + 1);
                                                   btn.disabled = true;
                                                   $(btn).addClass('btn-liked');
                                               } else {
                                                   alert("You already liked this post.");
                                                   btn.disabled = true;
                                                   $(btn).addClass('btn-liked');
                                               }
                                           },
                                           error: function () {
                                               alert("Error liking the post. Please try again.");
                                           }
                                       });
                                   }
        </script>
    </body>
</html>
