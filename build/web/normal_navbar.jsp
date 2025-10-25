<%@page import="com.tech.blog.entities.Category"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.entities.User"%>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    String uri = request.getRequestURI();
    boolean isMyPosts = uri.contains("my_posts.jsp");
%>

<!-- Navbar Start -->
<nav class="navbar navbar-expand-lg navbar-dark primary-background fixed-top">
    <a class="navbar-brand" href="index.jsp">
        <span class="fa fa-laptop icon"></span> TechBlog
    </a>

    <button class="navbar-toggler" type="button" data-toggle="collapse"
            data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false"
            aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <!-- Left Side -->
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <a class="nav-link" href="profile.jsp">
                    <span class="fa fa-book icon"></span> Read Blog
                    <span class="sr-only">(current)</span>
                </a>
            </li>

            <% if (currentUser != null) { %>
            <li class="nav-item">
                <a class="nav-link" href="my_posts.jsp">
                    <span class="fa fa-file-text icon"></span> My Posts
                </a>
            </li>
            <% } %>

            <% if (currentUser != null && isMyPosts) { %>
            <li class="nav-item">
                <a class="nav-link" href="#" data-toggle="modal" data-target="#add-post-modal">
                    <span class="fa fa-plus-circle icon"></span> Do Post
                </a>
            </li>
            <% } %>
        </ul>

        <!-- Right Side -->
        <ul class="navbar-nav ml-auto">
            <% if (currentUser != null) {%>
            <li class="nav-item">
                <a class="nav-link text-white" href="#!">
                    Welcome, <%= currentUser.getName()%>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="LogoutServlet">
                    <span class="fa fa-user-plus"></span> Logout
                </a>
            </li>
            <% } else { %>
            <li class="nav-item">
                <a class="nav-link" href="login_page.jsp">
                    <span class="fa fa-user icon"></span> Login
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="register_page.jsp">
                    <span class="fa fa-user-plus icon"></span> Sign up
                </a>
            </li>
            <% }%>
        </ul>

        <!-- Search Form -->
        <form action="SearchServlet" method="get" class="d-flex" role="search" style="margin-left: 20px;">
            <input class="form-control me-2" type="search" name="query"
                   placeholder="Search blogs" aria-label="Search" required>
            <button class="btn btn-outline-success" type="submit"
                    style="margin-left: 20px; background-color: green; color: white;">
                Search
            </button>
        </form>
    </div>
</nav>
<!-- Navbar End -->


<% if (isMyPosts) { %>
<!-- Do Post Modal -->
<div class="modal fade" id="add-post-modal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Create a New Post</h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="add-post-form" action="AddPostServlet" method="post" enctype="multipart/form-data">
                    <!-- Category -->
                    <div class="form-group">
                        <label>Category</label>
                        <select class="form-control" name="cid" required>
                            <option selected disabled value="">---Select Category---</option>
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

                    <!-- Title -->
                    <div class="form-group">
                        <label>Post Title</label>
                        <input type="text" name="pTitle" class="form-control" placeholder="Enter post title" required/>
                    </div>

                    <!-- Content -->
                    <div class="form-group">
                        <label>Post Content</label>
                        <textarea name="pContent" class="form-control" rows="8" placeholder="Write your content here..." required></textarea>
                    </div>

                    <!-- Code Snippet -->
                    <div class="form-group">
                        <label><i class="fa fa-code"></i> Code Snippet (Optional)</label>
                        <textarea id="code-editor" name="pCode" class="form-control" 
                                  style="height: 250px; font-family: 'Courier New', monospace; font-size: 14px; background: #f5f5f5; white-space: pre; overflow-x: auto;" 
                                  placeholder="Paste your code here with proper formatting..."></textarea>
                        <small class="text-muted">Paste code as-is. Formatting will be preserved.</small>
                    </div>

                    <!-- Image Upload -->
                    <div class="form-group">
                        <label>Upload Image (Optional)</label>
                        <input type="file" name="pic" class="form-control-file"/>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-paper-plane"></i> Publish Post
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Rest of your scripts remain the same -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>

<!-- AJAX Submission Script -->
<script>
    $(document).ready(function () {
        $("#add-post-form").on("submit", function (event) {
            event.preventDefault();
            let form = new FormData(this);
            $.ajax({
                url: "AddPostServlet",
                type: 'POST',
                data: form,
                success: function (data) {
                    if (data.trim() === 'done') {
                        swal({
                            title: "Success!",
                            text: "Post saved successfully.",
                            icon: "success"
                        }).then(function () {
                            window.location = "my_posts.jsp";
                        });
                    } else {
                        swal({
                            title: "Error!!",
                            text: "Something went wrong, try again.",
                            icon: "error"
                        });
                    }
                },
                error: function () {
                    swal({
                        title: "Error!!",
                        text: "Something went wrong, try again.",
                        icon: "error"
                    });
                },
                processData: false,
                contentType: false
            });
        });
    });
</script>
<% }%>

