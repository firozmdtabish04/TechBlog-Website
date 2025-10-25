<%@page import="com.tech.blog.dao.LikeDao"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.tech.blog.dao.UserDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tech.blog.entities.Category"%>
<%@page import="com.tech.blog.entities.Category"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.entities.Post"%>
<%@page import="com.tech.blog.entities.User"%>
<%@page  errorPage="error_page.jsp" %>

<%

    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login_page.jsp");
    }

%>

<%    int postId = Integer.parseInt(request.getParameter("post_id"));
    PostDao d = new PostDao(ConnectionProvider.getConnection());

    Post p = d.getPostByPostId(postId);
    LikeDao likeDao = new LikeDao(ConnectionProvider.getConnection());
    boolean userLiked = likeDao.isLikedByUser(postId, user.getId());
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= p.getpTitle()%></title>

        <!--css-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" 
              integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" 
              crossorigin="anonymous">
        <link href="css/mystyle.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

        <style>
            .card-img-top {
                max-height: 250px;  /* Smaller height */
                max-width: 500px;   /* Limited width */
                object-fit: contain;
                width: auto;        /* Don't force 100% width */
                margin: 20px auto;  /* Center it */
                display: block;
                border-radius: 8px;
            }

            .card {
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                background-color: white;
                margin: 40px auto;
                max-width: 850px;
                overflow: hidden;
            }
            .card-header.primary-background {
                background-color: #3563d1;
                color: white;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                padding: 20px;
            }
            .post-title {
                font-weight: 600;
                font-size: 28px;
                margin: 0;
            }
            .card-img-top {
                max-height: 380px;
                object-fit: cover;
                width: 100%;
            }
            .row-user {
                border: 1px solid #e2e2e2;
                padding: 15px;
                margin-top: 15px;
                font-size: 18px;
                align-items: center;
            }
            .post-user-info a {
                text-decoration: none;
                color: #3563d1;
                font-weight: 600;
            }
            .post-date {
                font-style: italic;
                font-weight: bold;
                text-align: right;
                color: #555;
            }
            .post-content {
                font-size: 20px;
                font-weight: 400;
                padding: 15px;
                line-height: 1.6;
            }

            .btn-liked {
                pointer-events: none;
                opacity: 0.6;
                color: #ccc !important;
                border-color: #ccc !important;
                background-color: #f8f9fa !important;
            }

            .code-block {
                border-radius: 8px;
                margin: 30px 0;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                overflow: auto;
            }
            .code-header {
                background: #1e1e1e;
                color: #f8f8f2;
                padding: 10px 15px;
                font-weight: 600;
                border-radius: 8px 8px 0 0;
            }

            .content-block {
                border-radius: 8px;
                margin: 30px 0;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                overflow: hidden;
            }

            .content-header {
                background: #f8f9fa;
                color: #333;
                padding: 10px 15px;
                font-weight: 600;
                border-radius: 8px 8px 0 0;
                border-bottom: 2px solid #e2e2e2;
            }

            .content-body {
                margin: 0;
                padding: 20px;
                background: #ffffff;
                color: #333;
                border-radius: 0 0 8px 8px;
                border: 1px solid #e2e2e2;
                border-top: none;
                overflow-x: auto;
                white-space: pre-line;
                font-family: 'Georgia', serif;
                font-size: 18px;
                line-height: 1.8;
            }

            .code-block {
                border-radius: 8px;
                margin: 30px 0;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                overflow: hidden;
            }

            .code-header {
                background: #1e1e1e;
                color: #f8f8f2;
                padding: 10px 15px;
                font-weight: 600;
                border-radius: 8px 8px 0 0;
            }

        </style>
    </head>
    <body>

        <!--navbar--> 

        <nav class="navbar navbar-expand-lg navbar-dark primary-background">
            <a class="navbar-brand" href="index.jsp"> <span class="fa fa-laptop icon"></span> Tech Blog</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" 
                    data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" 
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="profile.jsp"> <span class="fa fa-book icon"></span> Read and Learn <span class="sr-only">(current)</span></a>
                    </li>
                    <!--Do Post Modal Off-->
                    <!--                    <li class="nav-item">
                                            <a class="nav-link" href="#" data-toggle="modal" data-target="#add-post-modal" > <span class="fa fa-plus-circle icon"></span> Do Post</a>
                                        </li>-->

                </ul>

                <ul class="navbar-nav mr-right">
                    <li class="nav-item">
                        <a class="nav-link" href="#!" data-toggle="modal" data-target="#profile-modal"> <span class="fa fa-user-circle "></span> <%= user.getName()%> </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet"> <span class="fa fa-user-plus "></span> Logout</a>
                    </li>
                </ul>
            </div>
        </nav>

        <!--end of navbar-->

        <!--main content of body-->

        <div class="container">

            <div class="row my-4">

                <div class="col-md-8 offset-md-2">


                    <div class="card">

                        <div class="card-header primary-background">
                            <h4 class="post-title"><%= p.getpTitle()%></h4>
                        </div>

                        <img class="card-img-top" src="blog_pics/<%= p.getpPic()%>" alt="Card image cap">

                        <div class="card-body">

                            <div class="row my-3 row-user">
                                <div class="col-md-8 post-user-info">
                                    <% UserDao ud = new UserDao(ConnectionProvider.getConnection());%>
                                    <p><a href="#!"><%= ud.getUserByUserId(p.getUserId()).getName()%></a> has posted:</p>
                                </div>

                                <div class="col-md-4 post-date">
                                    <p><%= DateFormat.getDateTimeInstance().format(p.getpDate())%></p>
                                </div>
                            </div>

                            <!-- FORMATTED CONTENT BLOCK WITH WHITE BACKGROUND -->
                            <div class="content-block mt-3">
                                <div class="content-header" style="background: #f8f9fa; color: #333; padding: 10px 15px; border-radius: 8px 8px 0 0; border-bottom: 2px solid #e2e2e2;">
                                    <h6 style="margin: 0;"><i class="fa fa-file-text-o"></i> Content</h6>
                                </div>
                                <div style="margin: 0; padding: 20px; background: #ffffff; color: #333; border-radius: 0 0 8px 8px; border: 1px solid #e2e2e2; border-top: none; overflow-x: auto; white-space: pre-line; font-family: 'Georgia', serif; font-size: 18px; line-height: 1.8;"><%= p.getpContent()%></div>
                            </div>

                            <!-- CODE BLOCK WITH DARK BACKGROUND -->
                            <% if (p.getpCode() != null && !p.getpCode().trim().isEmpty()) {%>
                            <div class="code-block mt-3">
                                <div class="code-header" style="background: #1e1e1e; color: white; padding: 10px 15px; border-radius: 8px 8px 0 0;">
                                    <h6 style="margin: 0;"><i class="fa fa-code"></i> Code Snippet</h6>
                                </div>
                                <pre style="margin: 0; padding: 20px; background: #2d2d2d; color: #f8f8f2; border-radius: 0 0 8px 8px; overflow-x: auto; white-space: pre-wrap; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.6;"><code><%= p.getpCode()%></code></pre>
                            </div>
                            <% }%>

                        </div>



                        <div class="card-footer primary-background">
                            <a href="#!" 
                               onclick="doLike(<%= p.getPid()%>, <%= user.getId()%>, this)" 
                               class="btn btn-outline-light btn-sm <%= userLiked ? "btn-liked" : ""%>" 
                               <%= userLiked ? "disabled" : ""%>>
                                <i class="fa fa-thumbs-o-up"></i> 
                                <span class="like-counter"><%= likeDao.countLikeOnPost(p.getPid())%></span>  
                            </a>
                        </div>

                    </div>


                </div>

            </div>

        </div>

        <!--end of main content  of body-->

        <!--profile modal-->

        <!-- Modal -->
        <div class="modal fade" id="profile-modal" tabindex="-1" role="dialog" 
             aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header primary-background text-white text-center">
                        <h5 class="modal-title" id="exampleModalLabel"> TechBlog </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="container text-center">
                            <img src="pics/<%= user.getProfile()%>" class="img-fluid" style="border-radius:50%;max-width: 150px;;" >
                            <br>
                            <h5 class="modal-title mt-3" id="exampleModalLabel"> <%= user.getName()%> </h5>
                            <!--//details-->

                            <div id="profile-details">
                                <table class="table">

                                    <tbody>
                                        <tr>
                                            <th scope="row"> ID :</th>
                                            <td> <%= user.getId()%></td>

                                        </tr>
                                        <tr>
                                            <th scope="row"> Email : </th>
                                            <td><%= user.getEmail()%></td>

                                        </tr>
                                        <tr>
                                            <th scope="row">Gender :</th>
                                            <td><%= user.getGender()%></td>

                                        </tr>
                                        <tr>
                                            <th scope="row">Status :</th>
                                            <td><%= user.getAbout()%></td>

                                        </tr>
                                        <tr>
                                            <th scope="row">Registered on :</th>
                                            <td><%= user.getDateTime().toString()%></td>

                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!--profile edit-->

                            <div id="profile-edit" style="display: none;">
                                <h3 class="mt-2">Please Edit Carefully</h3>
                                <form action="EditServlet" method="post" enctype="multipart/form-data">
                                    <table class="table">
                                        <tr>
                                            <td>ID :</td>
                                            <td><%= user.getId()%></td>
                                        </tr>
                                        <tr>
                                            <td>Email :</td>
                                            <td> <input type="email" class="form-control" name="user_email" value="<%= user.getEmail()%>" > </td>
                                        </tr>
                                        <tr>
                                            <td>Name :</td>
                                            <td> <input type="text" class="form-control" name="user_name" value="<%= user.getName()%>" > </td>
                                        </tr>
                                        <tr>
                                            <td>Password :</td>
                                            <td> <input type="password" class="form-control" name="user_password" value="<%= user.getPassword()%>" > </td>
                                        </tr>
                                        <tr>
                                            <td>Gender :</td>
                                            <td> <%= user.getGender().toUpperCase()%> </td>
                                        </tr>
                                        <tr>
                                            <td>About  :</td>
                                            <td>
                                                <textarea rows="3" class="form-control" name="user_about" ><%= user.getAbout()%>
                                                </textarea>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>New Profile:</td>
                                            <td>
                                                <input type="file" name="image" class="form-control" >
                                            </td>
                                        </tr>

                                    </table>

                                    <div class="container">
                                        <button type="submit" class="btn btn-outline-primary">Save</button>
                                    </div>

                                </form>    

                            </div>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button  id="edit-profile-button" type="button" class="btn btn-primary">EDIT</button>
                    </div>
                </div>
            </div>
        </div>

        <!--end of profile modal-->

        <!--add post modal-->

        <!-- Modal -->
        <div class="modal fade" id="add-post-modal" tabindex="-1" role="dialog" 
             aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Provide the post details..</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <form id="add-post-form" action="AddPostServlet" method="post">

                            <div class="form-group">
                                <select class="form-control" name="cid">
                                    <option selected disabled>---Select Category---</option>

                                    <%
                                        PostDao postd = new PostDao(ConnectionProvider.getConnection());
                                        ArrayList<Category> list = postd.getAllCategories();
                                        for (Category c : list) {
                                    %>
                                    <option value="<%= c.getCid()%>"><%= c.getName()%></option>

                                    <%
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="form-group">
                                <input name="pTitle" type="text" placeholder="Enter post Title" class="form-control"/>
                            </div>

                            <div class="form-group">
                                <textarea name="pContent" class="form-control" style="height: 200px;" placeholder="Enter your content"></textarea>
                            </div>
                            <div class="form-group">
                                <textarea name="pCode" class="form-control" style="height: 200px;" placeholder="Enter your program (if any)"></textarea>
                            </div>
                            <div class="form-group">
                                <label>Select your pic..</label>
                                <br>
                                <input type="file" name="pic"  >
                            </div>

                            <div class="container text-center">
                                <button type="submit" class="btn btn-outline-primary">Post </button>
                            </div>

                        </form>

                    </div>

                </div>
            </div>
        </div>

        <!--END add post modal-->

        <!--javascripts-->
        <script
            src="https://code.jquery.com/jquery-3.4.1.min.js"
            integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
        crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" 
                integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" 
        crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" 
                integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" 
        crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
        <script src="js/myjs.js" type="text/javascript"></script>

        <script>
                                   $(document).ready(function () {
                                       let editStatus = false;

                                       $('#edit-profile-button').click(function ()
                                       {

                                           if (editStatus == false)
                                           {
                                               $("#profile-details").hide()

                                               $("#profile-edit").show();
                                               editStatus = true;
                                               $(this).text("Back")
                                           } else
                                           {
                                               $("#profile-details").show()

                                               $("#profile-edit").hide();
                                               editStatus = false;
                                               $(this).text("Edit")

                                           }
                                       })
                                   });
        </script>

        <!--like button ajax-->
        <script>
            function doLike(pid, uid, btn) {
                if (btn.disabled)
                    return;

                $.ajax({
                    url: 'LikeServlet',
                    type: 'POST',
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
