<%@page import="com.tech.blog.entities.Category"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.entities.Message"%>
<%@page import="com.tech.blog.entities.User"%>
<%@page errorPage="error_page.jsp" %>
<%

    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login_page.jsp");
    }

%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <!--css-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous"/>
        <link href="css/mystyle.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
        <style>
            body {
                background-color: #f5f6fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* ===== Post Card ===== */
            .post-card {
                background: #ffffff;
                border-radius: 14px;
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
                margin-bottom: 40px;
                padding: 28px;
                max-width: 720px;
                margin-left: auto;
                margin-right: auto;
                transition: all 0.3s ease;
                border: 1px solid #eaeaea;
            }

            .post-card:hover {
                box-shadow: 0 10px 28px rgba(0, 0, 0, 0.12);
                transform: translateY(-4px);
            }

            /* ===== Title ===== */
            .post-title {
                font-size: 1.6rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 10px;
                line-height: 1.3;
            }

            /* ===== Meta Info ===== */
            .post-meta {
                font-size: 0.9rem;
                color: #888;
                margin-bottom: 18px;
                border-left: 3px solid #3498db;
                padding-left: 10px;
            }

            /* ===== Content ===== */
            .post-snippet,
            .post-full-content {
                font-size: 1rem;
                color: #333;
                line-height: 1.7;
                margin-bottom: 10px;
            }

            .post-full-content {
                display: none;
            }

            /* ===== Read More Button ===== */
            .read-more-btn {
                background-color: #3498db;
                border: none;
                color: white;
                padding: 8px 22px;
                border-radius: 6px;
                cursor: pointer;
                margin-top: 12px;
                font-size: 15px;
                font-weight: 500;
                letter-spacing: 0.3px;
                transition: all 0.3s ease;
            }

            .read-more-btn:hover {
                background-color: #2874a6;
                box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
            }

            /* ===== Image inside Post ===== */
            .post-card img {
                width: 100%;
                height: auto;
                max-height: 300px;
                border-radius: 10px;
                margin-bottom: 15px;
                object-fit: contain;  
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                display: block;
            }

        </style>
    </head>
    <body>
        <!--navbar--> 

        <nav class="navbar navbar-expand-lg navbar-dark primary-background">
            <a class="navbar-brand" href="index.jsp"> <span class="fa fa-laptop icon"></span>   Tech Blog</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="#"> <span class="fa fa-newspaper-o icon"></span> Read Blog <span class="sr-only">(current)</span></a>
                    </li>

                </ul>

                <ul class="navbar-nav mr-right">
                    <li class="nav-item">
                        <a class="nav-link" href="#!" data-toggle="modal" data-target="#profile-modal"> <span class="fa fa-user-circle "></span> <%= user.getName()%> </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet"> <span class="fa fa-user-plus "></span> Logout</a>
                    </li>
                </ul>

                <!--Search form--> 
                <form action="SearchServlet" method="get" class="d-flex" role="search" style="margin-left: 20px;">
                    <input class="form-control me-2" type="search" name="query" placeholder="Search blogs" aria-label="Search" required>
                    <button class="btn btn-outline-success btn " type="submit" style="margin-left: 20px; background-color: green; color: white;">Search</button>
                </form>
            </div>
        </nav>

        <% Message m = (Message) session.getAttribute("msg");
            if (m != null) {
        %>
        <div class="alert <%= m.getCssClass()%>" role="alert">
            <%= m.getContent()%>
        </div> 
        <%
                session.removeAttribute("msg");
            }
        %>

        <!--main body of the page-->
        <main>
            <div class="container-fluid">
                <div class="row mt-4 g-0">
                    <!--first col-->
                    <div class="col-md-3 ">
                        <!--categories-->
                        <div class="list-group">
                            <a href="#" onclick="getPosts(0, this)"  class="c-link list-group-item list-group-item-action active">
                                All Posts
                            </a>
                            <!--categories-->
                            <% PostDao d = new PostDao(ConnectionProvider.getConnection());
                                ArrayList<Category> categories = d.getAllCategories();
                                for (Category c : categories) {
                            %>
                            <a href="#" onclick="getPosts(<%= c.getCid()%>, this)" class="c-link list-group-item list-group-item-action">
                                <%= c.getName()%>
                            </a>
                            <% }%>
                        </div>
                    </div>

                    <!--second col-->
                    <div class="col-md-9 " id="post-container">
                        <div id="loader" class="text-center">
                            <i class="fa fa-refresh fa-4x fa-spin"></i>
                            <h3 class="mt-2">Loading...</h3>
                        </div>
                        <!-- Posts loaded via AJAX will go here -->
                    </div>
                </div>
            </div>
        </main>

        <!--profile modal-->
        <div class="modal fade" id="profile-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
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
                                                <textarea rows="3" class="form-control" name="user_about" ><%= user.getAbout()%></textarea>
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



        <!--javascripts-->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" crossorigin="anonymous"></script>
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
                                })
        </script>



        <script>
            function getPosts(catId, temp) {
                $("#loader").show();
                $("#post-container").hide()
                $(".c-link").removeClass('active')
                $.ajax({
                    url: "load_posts.jsp",
                    data: {cid: catId},
                    success: function (data) {
                        $("#loader").hide();
                        $("#post-container").show();
                        $('#post-container').html(data)
                        $(temp).addClass('active')
                    }
                })
            }

            $(document).ready(function () {
                let allPostRef = $('.c-link')[0]
                getPosts(0, allPostRef)
            })
        </script>

        <script>
            function showFullContent(postId) {
                document.getElementById('snippet-' + postId).style.display = 'none';
                document.getElementById('full-' + postId).style.display = 'block';
                document.getElementById('read-more-btn-' + postId).style.display = 'none';
            }
        </script>

    </body>
</html>
