<%--
  Created by IntelliJ IDEA.
  User: 950618
  Date: 2019/2/19
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>账号管理</title>
    <link rel="stylesheet" type="text/css" href="css/page/style.css" media="screen"/>
    <script src="js/jquery/jquery2.0.3/jquery-2.0.3.min.js"></script>
    <link href="css/3.3.6/bootstrap.min.css" rel="stylesheet">
    <link href="css/bootstrap-select.min.css">
    <script src="js/jquery/2.0.0/jquery.min.js"></script>
    <script src="js/3.3.6/bootstrap.min.js"></script>
    <script src="js/bootstrap-select.min.js"></script>
    <link href="css/navbar.css" rel="stylesheet">
    <script src="js/navbar.js"></script>
    <script src="js/insurance/accountManage.js"></script>
    <script src="js/util.js"></script>
    <link rel="icon" href="image/favicon.ICO" type="image/x-icon"/>

</head>
<body onload="setCompanySelectData();onLoadAccountList();">
<!--导航条-->
<nav class="navbar navbar-inverse navbar-fixed-top float" id="navbar1" style="height: 50px;">
    <div class="main-title">
        <ul class="nav navbar-nav navbar-left navbar-side">
            <li>
                <a href="#" onclick="$('body').toggleClass('sidebar-collapse');" style="width: 50px;height: 50px">
                    <span class="glyphicon glyphicon-menu-hamburger"></span>
                </a>
            </li>
        </ul>
    </div>
    <div class="container navbar-left" style="width: 70%;">
        <div class="navbar-header">
            <a class="navbar-brand" href="#"><img src="image/logo1.png"></a>
        </div>
        <div id="navbar" class="collapse navbar-collapse" style="margin-left: 150px;">
            <ul class="nav navbar-nav">
                <li class="active"><a href="">账号管理</a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
    <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
            <a href="#" title="我的" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
               aria-expanded="false"><span class="glyphicon glyphicon-user"></span></a>
            <ul class="dropdown-menu">
                <li><a href="account">账号管理</a></li>
                <li><a href="cleanUserInfo">注销</a></li>
            </ul>
        </li>
    </ul>
</nav>

<div class="container-fluid">
    <div class="row">
        <div class="sidebar">
            <ul class="sidenav animated fadeInUp" style="margin-top: 50px">
                <li><a class="withripple" href="orderList"><span class="glyphicon glyphicon-th-list"
                                                                 aria-hidden="true"></span><span class="sidespan">&nbsp;&nbsp;订单列表 </span><span
                        class="iright pull-right">&gt;</span></a></li>
                <li onclick="jumpToAccountManage()"><a class="withripple" ><span class="glyphicon glyphicon-th-list"
                                                                     aria-hidden="true"></span><span class="sidespan">&nbsp;&nbsp;账号管理 </span><span
                        class="iright pull-right">&gt;</span></a></li>
                <li><a class="withripple" href="basicData"><span class="glyphicon glyphicon-signal"
                                                                 aria-hidden="true"></span><span class="sidespan">&nbsp;&nbsp;基础数据 </span><span
                        class="iright pull-right">&gt;</span></a></li>
            </ul>
        </div>
    </div>

    <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main" style="margin-top: 2%">
        <div class="row">
            <h4 class="sub-header">账号列表</h4>
        </div>
        <div class="row">
                <!--操作按钮-->
                <div class="pull-left col-md-6">
                    <button class="btn btn-primary btn-xs" type="button" onclick="showAddModal();" href=""><span
                            class="glyphicon glyphicon-plus"
                            aria-hidden="true"></span> 新增
                    </button>
                </div>
                <!--查询框-->
                <div class="input-group col-md-4 pull-right">
                    <input type="text" class="form-control" placeholder="搜索..." id="searchContent">
                    <span class="input-group-btn">
              <a class="btn btn-default" onclick="searchData();"><span class="glyphicon glyphicon-search"
                                                                       aria-hidden="true"></span> 查询</a>
              <a class="btn btn-default" onclick="$('#senior').toggle();"><span class="glyphicon glyphicon-cog"
                                                                                aria-hidden="true"></span> 高级查询</a>
              <a class="btn btn-default" onclick="reset();"><span class="glyphicon glyphicon-cog"
                                                                  aria-hidden="true"></span> 重置</a>
          </span>
                </div>
        </div>
        <br>
        <div class="panel panel-default" id="senior" style="display: none;">
            <div class="panel-body">
                <div class="row">
                    <div class="form-horizontal col-md-4">
                        <div class="form-group">
                            <label for="search_userName" class="col-sm-4 control-label">账号</label>
                            <div class="col-xs-7">
                                <input type="text" onkeyup="enterSearch();" class="form-control" id="search_userName" name="code"
                                       placeholder="">
                            </div>
                        </div>
                    </div>
                    <div class="form-horizontal col-md-4">
                        <div class="form-group">
                            <label for="search_name" class="col-sm-4 control-label">姓名</label>
                            <div class="col-xs-7">
                                <input type="text" onkeyup="enterSearch();" class="form-control" id="search_name" name="name"
                                       placeholder="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="table">
            <table class="table table-striped table-hover table-condensed">
                <thead>
                <tr>
                    <th class="text-center">
                        <label>
                            <input class="checkbox" type="checkbox" value="option1" aria-label="..." name="allSel"
                                   id="allSel">
                        </label>
                    </th>
                    <th class="text-center">编号</th>
                    <th class="text-center">账号</th>
                    <th class="text-center">姓名</th>
                    <th class="text-center">公司</th>
                    <th class="text-center">部门</th>
                    <th class="text-center">项目组</th>
                    <th class="text-center">创建日期</th>
                    <th class="text-center">创建人</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tBody">
                <tr>
                    <td class="text-center">
                        <label>
                            <input class="checkbox" type="checkbox" value="option1" aria-label="..."
                                   name="checkbox1">
                        </label>
                    </td>
                    <td class="text-center" name="id"></td>
                    <td class="text-center" name="userName"></td>
                    <td class="text-center" name="name"></td>
                    <td class="text-center"></td>
                    <td class="text-center"></td>
                    <td class="text-center"></td>
                    <td class="text-center"></td>
                    <td class="text-center"></td>
                    <td class="text-center">
                        <a onclick="showEditModal(this);" title="修改"><span class="glyphicon glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
                        <a onclick="deleteById(this);" class="delete" title="删除"><span class="glyphicon glyphicon glyphicon-remove" aria-hidden="true"></span></a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- 修改信息模态框 -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">信息修改</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="form-horizontal col-md-6">
                        <div class="form-group">
                            <label for="userName" class="col-sm-4 control-label">用户名 </label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="userName" name="userName" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="password" class="col-sm-4 control-label">密码 </label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="password" name="password">
                            </div>
                        </div>
                        <div class="form-group department" hidden>
                            <label for="department" class="col-sm-4 control-label">部门 </label>
                            <div class="col-xs-8">
                                <select class="form-control" id="department" name="department"
                                        onchange="setTeamSelectData(this)">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-horizontal col-md-6">
                        <div class="form-group">
                            <label for="name" class="col-sm-4 control-label">姓名 </label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="name" name="name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="company" class="col-sm-4 control-label">公司 </label>
                            <div class="col-xs-8">
                                <select class="form-control" id="company" name="company"
                                        onchange="setDepartmentSelectData(this)">

                                </select>
                            </div>
                        </div>
                        <div class="form-group team" hidden>
                            <label for="name" class="col-sm-4 control-label">项目组 </label>
                            <div class="col-xs-8">
                                <select class="form-control" id="team" name="team">
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="updateUser()">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<%--新增模态框--%>
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">新增用户</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="form-horizontal col-md-6">
                        <div class="form-group">
                            <label for="userName" class="col-sm-4 control-label">用户名 </label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="add_userName" name="userName">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="password" class="col-sm-4 control-label">密码 </label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="add_password" name="password">
                            </div>
                        </div>
                        <div class="form-group department" hidden>
                            <label for="department" class="col-sm-4 control-label">部门 </label>
                            <div class="col-xs-8">
                                <select class="form-control" id="add_department" name="department"
                                        onchange="setTeamSelectData(this)">

                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-horizontal col-md-6">
                        <div class="form-group">
                            <label for="name" class="col-sm-4 control-label">姓名 </label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="add_name" name="name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="company" class="col-sm-4 control-label">公司 </label>
                            <div class="col-xs-8">
                                <select class="form-control" id="add_company" name="company"
                                        onchange="setDepartmentSelectData(this)">

                                </select>
                            </div>
                        </div>
                        <div class="form-group team" hidden>
                            <label for="name" class="col-sm-4 control-label">项目组 </label>
                            <div class="col-xs-8">
                                <select class="form-control" id="add_team" name="team">

                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="addUser();">保存</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<%--分页--%>
<div class="content row" style="height: 50px">
    <div class="demo">
        <div id="demo3"></div>
        <br>
        <form class="form-inline">
            <div class="form-group" style="width: 20%">
                <a class="btn btn-primary" onclick="jump()" style="height: 30px;width: 60px">跳转</a>
                <input type="text" style="width:30%" id="jumpPage">
                <span>页</span>
            </div>

            <span>当前第</span>
            <span id="currentPage" style="color: green">1</span>
            <span>页</span>
            <span style="display: inline-block">每页显示</span>
            <select id="count" style="display: inline-block" onchange="switchPageNumber(onLoadAccountList);">
                <option value=1>1</option>
                <option selected value=15>15</option>
                <option value=50>50</option>
            </select>
            <span style="display: inline-block">条记录</span>
            <span>总共</span>
            <span id="totalRecord" style="color: red"></span>
            <span>条记录</span>
        </form>
    </div>
    <script src="js/page.js" type="text/javascript"></script>
</div>
</body>
<script>

</script>
</html>
